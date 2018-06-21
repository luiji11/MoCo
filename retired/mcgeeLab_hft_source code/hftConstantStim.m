function hftConstantStim(SubjectId, sessionDay)
%% Mcgee's Method of Constant Stimuli
cd('C:\Users\Mcgeelab\Desktop\MAE')
clc;

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
%******************
ulPerReward     = 4.5;
%******************
maxWater_uL     = 1000; %Limit the water given for the session to maxWater microLiters (uL)


rewardPort  = 2;    % 2 refers to the right water port, will be used for go/~go task; 
timeOut     = 0;    % time out

int_rsp     = 4;        % Time allowed to respond after stim onset

sessStart       = GetSecs;      % Get session start time
go              = sessStart;    % For sampling the lick response 
F.sessStart     = sessStart;    % For realtime plot
pool            = 1;
manualExit      = 0;

while sum(I.water(:,1)>0)*ulPerReward <= maxWater_uL &&...
      (GetSecs - sessStart <  T.sessDur) &&...
      manualExit == 0
%% GO
    trAns = 1;
    sptHz       = stimPools{pool}(randi(numel(stimPools{pool}))); % Gabor Spat Hz (cpd) 
    I.sOn       = maeStoreEvents(I.sOn, K.k, []); 
    I.sPos      = maeStoreEvents(I.sPos, trAns, []);
    I.sVal      = maeStoreEvents(I.sVal, sptHz, []);     
    I.sStair    = maeStoreEvents(I.sVal, pool, []);
    
    mpaPlotSession(I,F);
    maeAudFeedBack('instructive')        
   
    %Present Stim
    Screen('DrawTexture', w, Screen('MakeTexture', w, maeMcgeeGetGaborMatrix(sptHz)));
    Screen('Flip', w);
    maePlotStimulus(F, 'fullScreen');   
    
    % Choice
    tStart = GetSecs;    
    response    = 0;               
    while (GetSecs - tStart < int_rsp) % int_rsp sec to respond
        [go, K.k, I.lick, mouseLicked] = maeScan(K,go,I,F,S);       
        if response == 0 && mouseLicked; % if HIT
            response = 1; 
            maeFeedPorts(S,rewardPort);
            I.water = maeStoreEvents(I.water, K.k, rewardPort);           
            tOver = GetSecs;
%             while (GetSecs - tOver) < 5; [go, K.k, I.lick, ~] = maeScan(K,go,I,F,S); end % wait .75 s                        
            if pool == 1; pool = 1; end            
        end
        
        % ------------------------------------------------------------------------------------
        [~, ~, keyCode] = KbCheck; if strcmp(KbName(keyCode),'esc'); manualExit = 1; break; end
        % ------------------------------------------------------------------------------------           
        
    end
    
    if ~response ; % MISS                         
        maeAudFeedBack('Wrong')        
        if pool == 1; pool = 1; end        
    end
    
    I.perf  = maeStoreEvents(I.perf, K.k, [trAns, response]);    
    
    
%% ITI     
    Screen('Flip', w); % grayscreen
    maePlotStimulus(F, 'grayScreen')      
    I.sOff  = maeStoreEvents(I.sOff, K.k, []); 
    
    mpaPlotSession(I,F);  
    maePlotPSF(I,F)    
    tOver = GetSecs; 
    response        = 0;  
    
%     iti = randi([8 20]); % for cloudy
    iti = randi([13 25]); % for sharpie
    
%         iti = randi([1]);

    while (GetSecs - tOver) < iti
        [go, K.k, I.lick, mouseLicked] = maeScan(K,go,I,F,S); 
        
%         if response == 0 && mouseLicked; % False Alarm 
%             timeOut = 1;
%             break;
%         end
        
        % ------------------------------------------------------------------------------------
        [~, ~, keyCode] = KbCheck; if strcmp(KbName(keyCode),'esc'); manualExit = 1; break; end
        % ------------------------------------------------------------------------------------           
    end
    
%% Time Out   

    
%     if timeOut == 1
% %         Screen('DrawTexture', w, Screen('MakeTexture', w, zeros([1080 1920])  )); % black screen
% %         Screen('Flip', w);
%         maePlotStimulus(F, 'timeOut')        
%   
%         while timeOut
%             t = GetSecs;
%             k = 0; 
%             tot = 5;
%             while (GetSecs - t) < tot    
%                 [go, K.k, I.lick, licked] = maeScan(K,go,I,F,S);
%                 k = k + licked;
%                 % ------------------------------------------------------------------------------------
%                 [~, ~, keyCode] = KbCheck; if strcmp(KbName(keyCode),'esc'); manualExit = 1; break; end
%                 % ------------------------------------------------------------------------------------               
%             end
%             tot = tot - 1;
%             if tot == 0; k =0; end
%             if k == 0; timeOut = 0; end
%         end
%     end
    
    

end




sca;
save([SubjectId, '_CS_', num2str(sessionDay)],'I')
















