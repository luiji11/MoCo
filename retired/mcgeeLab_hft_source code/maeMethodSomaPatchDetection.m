%% HFT Experimental Patch Detection
% 4.24.16
%   dsgsd
%%
trMode          = 0;            % Trial mode, Yes (1) or No (0)
trEndTime       = 0;            % Time when last trial ended, initialize to 0
timeOut         = 0;            % Time out interval, initialize to 0 for first trial
iti             = T.iti;        % Inter-trial interval, set to default (see initialiizePars to change)
sessStart       = GetSecs;      % Get session start time
go              = sessStart;    % For sampling the lick response 
F.sessStart     = sessStart;    % For realtime plot

while (GetSecs - sessStart <  T.sessDur) 
    maePlotRealTime(I,K.k,F)
    [go, K.k]             = maeWait(K.sampHz, go, K.k);                     % wait until allowed to sample    
    [I.lick, isLicking]   = maeStoreEvents(I.lick, K.k, maeReadPorts(S));   % Record lick Event

if  ~trMode && isLicking  &&...                                     % If not in trial mode, is in the act of licking (make take that out), 
    (GetSecs - trEndTime > (timeOut+iti))                           % time out is over (for non Guaranteed Reward session), and iti is over

    trMode       = 1;                                               % We're in trial Mode babyyyy    
    trTimeStart  = GetSecs;
    trOnFrame    = K.k;                                             % remember trial onset frame
    trAns        = maeSetStimPosition('NonPsuedo', I.perf, 2, 3);   % determine stim position      
    nMiss        = 0;                                               % prepare to Count the # of incorrect Licks
    
    
    I.sOn          = maeStoreEvents(I.sOn, K.k, []);
    I.sType        = maeStoreEvents(I.sType, trAns, []);
   
    maeTrigStim(S, stimCmd{trAns});                                 % Trigger Stimulus

    fprintf('Go!!! (Trial %d)\n', find(I.perf == 0,1));
    F.tmOutState    = '';

end


if  trMode && isLicking &&...       % If in trial mode, is in the act of licking,
    (GetSecs - trTimeStart > 1);    % and waited 1 s since trial intiated 
    

    if  maeLastEvent(I.lick,2) == trAns                         % check if licked correctly
        maeFeedPorts(S,trAns);                                  % Send water to correct port
        maeTrigStim(S, 'x');                                    % Turn stim off;                               
        
        I.water         =   maeStoreEvents(I.water, K.k, trAns);                
        I.sOff          =   maeStoreEvents(I.sOff, K.k, []);
        I.perf          =   maeStoreEvents(I.perf, K.k, [trAns, nMiss]);
        
        trMode          = 0;                                    % exit trial mode      
        trEndTime       = GetSecs;                              % Remember trial end time
        fprintf('Correct!!!\n');
        timeOut = 0;                                            % No time out
        
    elseif maeLastEvent(I.lick,2) ~= trAns                      % But if missed
        nMiss = nMiss + 1;                                      % Count it
        maeAudFeedBack('instructive')                              % Feedback
        fprintf('Wrong!!!\n')
        
        if rewardGuaranteed == 0;                               % if reward is not gauranteed,
            maeTrigStim(S, 'x');                                % Turn stim off;
            timeOut         = T.timeOutDur;                     % Give him a time out
            trEndTime       = GetSecs;                          % Remember time            
            trMode          = 0;                                % exit trial mode      
            I.perf          = maeStoreEvents(I.perf, K.k, [trAns, nMiss]);
            F.tmOutState    = 'TIME OUT';
        end
        
    end
    

end

end





