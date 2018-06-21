function McGeeActiveDispense(SubjectId, sessionDay)
%% Active Dispense Training (Mcgee's Method) 
% Dispenses water reward only when subject licks the port...

cd('C:\Users\Mcgeelab\Desktop\MAE')

S               = maeCommunicate('COM5'); 
[I, T, K]       = maeInitializePars;
F               = maeInitializePlots(K,T,I);  

stimPools = {I.sfIntValues(I.sfIntValues<.2), I.sfIntValues(I.sfIntValues>=.2)};

%% PTB
Screen('CloseAll');
AssertOpenGL;
Screen('Preference','SkipSyncTests',1);
w = Screen('OpenWindow',2, [127 127 127], [-1920 0 0 1080]);

%%
if sessionDay == 1;
   waitTime = [2 4];
elseif sessionDay == 2;
    waitTime = [4 7];
elseif sessionDay == 3;
    waitTime = [3 10];
end

%******************
ulPerReward     = 4.5;
%******************
maxWater_uL     = 1000; %Limit the water given for the session to maxWater microLiters (uL)
rewardPort      = 2;    % 2 refers to the right water port, will be used for go/~go task; 

sessStart       = GetSecs;      % Get session start time
go              = sessStart;    % For sampling the lick response 
F.sessStart     = sessStart;    % For realtime plot
pool            = 1;            % Pool 1 is the easy stimulus pool (low Sf Hz)
manualExit      = 0;

while   sum(I.water(:,1)>0)*ulPerReward <= maxWater_uL &&...
        (GetSecs-sessStart) < T.sessDur &&...
        manualExit == 0
    
%% GO     
    %Present Stim
    sptHz       = stimPools{pool}(randi(numel(stimPools{pool}))); % Gabor Spat Hz (in cpd)     
    Screen('DrawTexture', w, Screen('MakeTexture', w, maeMcgeeGetGaborMatrix(sptHz)  ));
    Screen('Flip', w);
    maePlotStimulus(F, 'fullScreen');   
    
    % Choice
    mouseLicked = 0;
    while 1
        [go, K.k, I.lick, mouseLicked] = maeScan(K,go,I,F,S); % scan for licks
        if mouseLicked;                     % once licked,
            maeFeedPorts(S,rewardPort);     % give reward
            I.water = maeStoreEvents(I.water, K.k, rewardPort);  % store this info

            t = GetSecs;
            while (GetSecs - t) <.5 % wait .5 secs
                [go, K.k, I.lick, ~] = maeScan(K,go,I,F,S); 
            end  
            break;
            
        end
        
        % ----------------------
        [~, ~, keyCode] = KbCheck;
        if strcmp(KbName(keyCode),'esc'); manualExit = 1; break; end
        % ----------------------
    end     

    % GRAY SCREEN
    Screen('Flip', w);    % gray screen
    maePlotStimulus(F, 'grayScreen');  
    t = GetSecs;     
    while (GetSecs - t) < randi(waitTime)  
        [go, K.k, I.lick, ~] = maeScan(K,go,I,F,S); %wait again 
        
        % ----------------------
        [~, ~, keyCode] = KbCheck;
        if strcmp(KbName(keyCode),'esc'); manualExit = 1; break; end
        % ----------------------      
        
    end    


end


sca;
save([SubjectId, '_AD_', num2str(sessionDay)],'I')















