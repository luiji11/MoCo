%% Mcgee's Method of Constant Stimuli

cd('C:\Users\Mcgeelab\Desktop\MAE')
clear; close all; clc;

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
rewardPort  = 2;    % 2 refers to the right water port, will be used for go/~go task; 
timeOut     = 0;    % time out

int_rsp     = 4;        % Time allowed to respond after stim onset
int_it      = .5;       % T.iti;
int_to      = .5;       % T.timeOutDur;

sessStart       = GetSecs;      % Get session start time
go              = sessStart;    % For sampling the lick response 
F.sessStart     = sessStart;    % For realtime plot
pool               = 1;

while (GetSecs - sessStart <  T.sessDur) 
%% GO
    trAns = 1;
    sptHz       = stimPools{pool}(randi(numel(stimPools{pool}))); % Gabor Spat Hz (cpd) 
    I.sOn       = maeStoreEvents(I.sOn, K.k, []); 
    I.sPos      = maeStoreEvents(I.sPos, trAns, []);
    I.sVal      = maeStoreEvents(I.sVal, sptHz, []);     
    I.sStair    = maeStoreEvents(I.sVal, pool, []);
    
    mpaPlotSession(I,F);
   
    %Present Stim
    Screen('DrawTexture', w, Screen('MakeTexture', w, maeMcgeeGetGaborMatrix(sptHz)));
    Screen('Flip', w);
    maePlotStimulus(F, 'fullScreen');   
    
    % Choice
    trTimeStart = GetSecs;    
    response    = 0;               
    while (GetSecs - trTimeStart < int_rsp) % int_rsp sec to respond
        [go, K.k, I.lick, mouseLicked] = maeScan(K,go,I,F,S);       
        if response == 0 && mouseLicked; response = 1; end
    end    
    Screen('Flip', w); % grayscreen
    maePlotStimulus(F, 'grayScreen')      
    
    trTimeOver  = GetSecs;
    I.perf      = maeStoreEvents(I.perf, K.k, [trAns, response]);    
    I.sOff      = maeStoreEvents(I.sOff, K.k, []); 
    
    if response ; % HIT            
        maeFeedPorts(S,rewardPort); 
        I.water = maeStoreEvents(I.water, K.k, rewardPort);       
        if pool == 1; pool = 2; end
        while (GetSecs - trTimeOver) < 2 % 2 seconds to drink
            [go, K.k, I.lick, mouseLicked] = maeScan(K,go,I,F,S); 
        end        
    elseif ~response % Miss
        maeAudFeedBack('Wrong')        
        if pool == 2; pool = 1; end        
    end    
    mpaPlotSession(I,F);  
    maePlotPSF(I,F)    
 
%% ITI 
    response        = 0;    
    while (GetSecs - trTimeOver) < (randi(2)) 
        [go, K.k, I.lick, mouseLicked] = maeScan(K,go,I,F,S); 
        
        if response == 0 && mouseLicked; % False Alarm 
            maeAudFeedBack('Wrong'); 
            timeOut = 1;
            break;
        end
        
    end
    
%% Time Out   
    if timeOut == 1
        Screen('DrawTexture', w, Screen('MakeTexture', w, zeros([1080 1920])  )); % black screen
        Screen('Flip', w);
        maePlotStimulus(F, 'timeOut')        

        while (GetSecs - trTimeOver) < 10 % 3 second TO
            [go, K.k, I.lick, mouseLicked] = maeScan(K,go,I,F,S); 
        end
        Screen('Flip', w);
        timeOut = 0;
    end

end





















