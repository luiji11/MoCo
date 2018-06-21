function hftConstantStimB(SubjectId, sessionDay)
% HFT "CONSTANT STIMULI, EASY TRAINING"

%% INITIALIZATION 
clc;
cd('C:\Users\Mcgeelab\Desktop\MAE')         % change your directory
S               = hftCommunicate('COM5');   % establish communication with arduino
[I, T, K]       = hftInitializePars;        % load some critical* session parameters
F               = hftInitializePlots(K,T);  % initialize real time plot
w               = hftOpenPtb( 1 ) ;         % open PTB window (input 1 to skip PTB sync tests, otherwise input 0)
rewardPort      = 2;                        % 2 refers to the second port, which I used for go/~go task (single lick port experiment); 
manualExit      = 0;                        % used for exiting the session by pressing the esc button

%% SESSION PARAMETERS (play with these)
%******************
% Amount of water (in uL) given for every reward. 
% This value needs to be determined by calibrating the "pulseWidth" on the arduino
    ulPerReward     = 4.5;      
%******************
maxWater_uL     = 1000;                             % Limit the water given in the session to "maxWateruL"
cpdVals         = I.sfIntValues(I.sfIntValues<.2);  % the spat hz that will be used, only those below .2 cpd will be presented here

intStimOn       = 4;             % Amount of time grating is on screen
ignoreWindow    = 2;             % during these first "ignoreWindow" sec of stimulus onset, responses (e.g. licks) will be ignored.     
intLetDrink     = 2;             % amount of time animal will be allowed to drink before moving on to next trial
iti             = randi([8 20]); % the inter trial interval (in sec), a random integer between iti(1) and iti(2)      

%% BEGIN SESSION    
sessStart       = GetSecs;      % Get session start time
go              = sessStart;    % For sampling the lick response 
F.sessStart     = sessStart;    % For realtime plot
                                                                % Keep running the session until...
while   sum(I.water(:,1)>0)*ulPerReward <= maxWater_uL &&...    % mouse gets more than "maxWater_uL" of water, or...
        (GetSecs-sessStart) < T.sessDur &&...                   % time exceeds T.sessDur, or ...
        ~manualExit                                             % manual exit button (esc) is pressed

    % Present Stimulus -------------------
    sptHz       = cpdVals( randi(numel(cpdVals)) );                                 % Choose, @ random, a Spat Hz for the grating     
    I.sVal      = hftStoreEvents(I.sVal, sptHz, []);                                % store the spt hz value of the grating     
    I.sOn       = hftStoreEvents(I.sOn, K.k, []);                                   % store the frame number when stimulus turned on    
    Screen('DrawTexture', w, Screen('MakeTexture', w, hftGetGratingMat(sptHz)  ));  % generate grating matrix, make and draw texture from it  
    Screen('Flip', w);                                                              % Present it on screen
    
    % Animal makes a Choice -----------------
    tStart          = GetSecs;                                      % Get the start time
    mouseLicked     = 0;                                            % set to 0;
    while (GetSecs - tStart < intStimOn)                            % Keep stimulus on the screen for intStimOn seconds      
        [go, K.k, I.lick, mouseLicked] = maeScan(K,go,I,F,S);       % scan for any licks
        if  mouseLicked && (GetSecs - tStart > ignoreWindow);       % If mouse licks during the response window (i.e. the ignore window is over)
            hftFeedPorts(S,rewardPort);                             % Give him a reward   
            I.water = hftStoreEvents(I.water, K.k, rewardPort);     % store frame number when reward was given, and the port that it was delivered to       
            t   = GetSecs;                                
            while (GetSecs - t) < intLetDrink;                      % wait another intLetDrink secs for animal to finish drinking (with stimulus on the screen)
                [go, K.k, I.lick, ~] = hftScan(K,go,I,F,S);         % scan for licks in the meantime
            end                     
        end
        % ------------------------------------------------------------------------------------
        [~, ~, keyCode] = KbCheck; if strcmp(KbName(keyCode),'esc'); manualExit = 1; break; end
        % ------------------------------------------------------------------------------------                  
    end
    
    % Inter Trial Interval -----------------
    Screen('Flip', w);                              % Turn grating off and Show gray screen
    hftPlotStimulus(F, 'grayScreen')                % update the real time figure  
    I.sOff  = hftStoreEvents(I.sOff, K.k, []);      % Store frame when stimulus turned off
    tOver   = GetSecs; 
    while (GetSecs - tOver) < randi(iti)            % wait somewhere between iti(1) and iti(2) seconds
        [go, K.k, I.lick, ~] = hftScan(K,go,I,F,S); % scan for licks in the meantime 
        % ------------------------------------------------------------------------------------
        [~, ~, keyCode] = KbCheck; if strcmp(KbName(keyCode),'esc'); manualExit = 1; break; end
        % ------------------------------------------------------------------------------------           
    end
    
end

sca;
save([SubjectId, '_CS_', num2str(sessionDay)],'I')


