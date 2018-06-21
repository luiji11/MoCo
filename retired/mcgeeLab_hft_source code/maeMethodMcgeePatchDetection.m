%% Mcgee Patch Detection Method
cd('C:\Users\Mcgeelab\Desktop\MAE')
clear; close all; clc;

S               = maeCommunicate('COM5'); 
[I, T, K]       = maeInitializePars;
F               = maeInitializePlots(K,T,I);    
%% PTB
Screen('CloseAll');
AssertOpenGL;
Screen('Preference','SkipSyncTests',1);
w = Screen('OpenWindow',2, [127 127 127], [-1920 0 0 1080]);

%%
rewardPort  = 2; % 2 refers to the right water port; 
timeOut     = 0; % time out

int_rsp     = 2;    % Time allowed to respond after stim onset
int_it      = .5;    % T.iti;
int_to      = .5;    % T.timeOutDur;

sessStart       = GetSecs;      % Get session start time
go              = sessStart;    % For sampling the lick response 
F.sessStart     = sessStart;    % For realtime plot

v = 1;
ansString = {'L','R','L+R','GO', 'NOGO'}; %1 2 3 4 5
poolStrng = {'Easy', 'Climb', 'Decline'};
while (GetSecs - sessStart <  T.sessDur) 

    % Initialize
    maeAudFeedBack('instructive')        
    trTimeStart     = GetSecs;
    F.tmOutState    = ''; 
    mouseLicked     = 0;
    mouseHasTime    = 1;    

    trAns           = maeSetTrialStim('McgeePlacePsuedoRand',I.perf, 2, 3);
    I.sOn           = maeStoreEvents(I.sOn, K.k, []); 
    I.sPos          = maeStoreEvents(I.sPos, trAns, []);    
        if trAns == 4
        [trVal,trPool]  = maeStairCaseLuis_v1(I);
        I.sVal          = maeStoreEvents(I.sVal, trVal, []); 
        I.sStair        = maeStoreEvents(I.sStair,trPool, []);
        Screen('DrawTexture', w,...
        Screen('MakeTexture', w,...
        maeMcgeeGetGaborMatrix(I.sfIntValues(trPool)     )) );
        Screen('Flip', w)
        end
        mpaPlotSession(I,F);
        
    % Choice
    while mouseHasTime 
        mouseHasTime = (GetSecs - trTimeStart < int_rsp) ;
        [go, K.k, I.lick, mouseLicked] = maeScan(K,go,I,F,S);       
        if mouseLicked; break; end
    end
    trTimeOver = GetSecs;
    Screen('Flip', w); 

    % Outcome
    if mouseLicked && trAns == 4; % HIT            
            maeFeedPorts(S,rewardPort); 
            I.water = maeStoreEvents(I.water, K.k, rewardPort);            
            iti     = int_it;            
            timeOut = 0;
            resp    = 1;
            
    elseif mouseLicked && trAns == 5; % FA
            maeAudFeedBack('Wrong')
            iti     = int_it;            
            timeOut = int_to;
            resp    = 1;
            F.tmOutState    = 'TimeOuttyyyy'; 

    elseif ~mouseHasTime && trAns == 4; 
            maeAudFeedBack('Wrong')            
            iti     = int_it;            
            timeOut = 0;
            resp    = 0;
            
    elseif ~mouseHasTime && trAns == 5;            
            iti     = 0;            
            timeOut = 0;
            resp    = 0;     
    end
    
    I.perf = maeStoreEvents(I.perf, K.k, [trAns, resp]);
    mpaPlotSession(I,F);
    
    % ITI
    while (GetSecs - trTimeOver) < (timeOut + iti)
        [go, K.k, I.lick, mouseLicked] = maeScan(K,go,I,F,S); 
    end
    
    
end



