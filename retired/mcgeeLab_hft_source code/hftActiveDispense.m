function hftActiveDispense(SubjectId, sessionDay)
%% Active Dispense Training
% Dispenses water reward only when mouse licks the port...

cd('C:\Users\Mcgeelab\Desktop\MAE')
clc;
S               = hftCommunicate('COM5');   % establish communication with arduino
[I, T, K]       = hftInitializePars;        % load session settings
F               = hftInitializePlots(K,T);  % initialize real time plot
w               = hftOpenPtb( 1 ) ;         % open PTB window

%% Settings for Session
%******************
% Amount of water (in uL) given for every reward. 
% This value needs to be determined by calibrating the "pulseWidth" on the arduino
    ulPerReward     = 4.5;      
%******************

maxWater_uL     = 1000;                             % Limit the water given in the session to "maxWateruL"
rewardPort      = 2;                                % 2 refers to the second port, which was used for go/~go task; 
cpdVals         = I.sfIntValues(I.sfIntValues<.2);  % the spat hz that will be used, only gratings with spat hz below .2 cpd will be presented
iti             = [2 4];                            % the inter trial interval (in sec), a random integer between iti(1) and iti(2)                            
intLetDrink     = 3;

sessStart       = GetSecs;      % Get session start time
go              = sessStart;    % For sampling the lick response 
F.sessStart     = sessStart;    % For realtime plot
manualExit      = 0;            % intialize at zero
%%                                                              % Keep session going until...
while   sum(I.water(:,1)>0)*ulPerReward <= maxWater_uL &&...    % mouse gets more than "maxWater_uL" of water, or...
        (GetSecs-sessStart) < T.sessDur &&...                   % time exceeds T.sessDur, or ...
        ~manualExit                                             % manual exit button (esc) is pressed
       
    % Present Stimulus -----------------
    sptHz       = cpdVals( randi(numel(cpdVals)) );                                 % Choose, @ random, a Spat Hz for the graing     
    Screen('DrawTexture', w, Screen('MakeTexture', w, hftGetGratingMat(sptHz)  ));  % generate image matrix, make and draw texture from it  
    Screen('Flip', w);                                                              % Present it on screen
    hftPlotStimulus(F, 'fullScreen');                                               % update the real time figure
    
    % Animal makes a Choice -----------------
    mouseLicked = 0; % intialize at 0
    while ~mouseLicked                                                  % As long as there is no licks,
        [go, K.k, I.lick, mouseLicked] = hftScan(K,go,I,F,S);           % keep scanning for licks
        if mouseLicked;                                                 % if animal licks,
            hftFeedPorts(S,rewardPort);                                 % give reward
            I.water = hftStoreEvents(I.water, K.k, rewardPort);         % store frame number when reward was given, and the port that it was delivered to
            t = GetSecs;                                                
            while (GetSecs - t) < intLetDrink;              % wait another intLetDrink secs for animal to finish drinking, 
                [go, K.k, I.lick, ~] = hftScan(K,go,I,F,S); % scan for licks in the meantime 
            end    
        end
       % ------------------------------------------------------------------------------------
        [~, ~, keyCode] = KbCheck; if strcmp(KbName(keyCode),'esc'); manualExit = 1; break; end % press esc button to manually end session
        % ------------------------------------------------------------------------------------    
    end     

    % Inter Trial Interval -----------------
    Screen('Flip', w);                  % Show gray screen
    hftPlotStimulus(F, 'grayScreen');   % update the real time figure
    t = GetSecs;     
    while (GetSecs - t) < randi(iti)                % wait somewhere between iti(1) and iti(2) seconds
        [go, K.k, I.lick, ~] = hftScan(K,go,I,F,S); % scan for licks in the meantime
       % ------------------------------------------------------------------------------------
        [~, ~, keyCode] = KbCheck; if strcmp(KbName(keyCode),'esc'); manualExit = 1; break; end % press esc button to manually end session
        % ------------------------------------------------------------------------------------    
    end    

end


sca;                                                % close the on-screen window
save([SubjectId, '_AD_', num2str(sessionDay)],'I')  % save your data



