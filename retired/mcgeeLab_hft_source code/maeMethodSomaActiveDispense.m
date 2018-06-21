%% HFT ACTIVE DISPENSE
% 4.22.16
%   Some Notes here
%%
sessStart   =   GetSecs;
go          =   sessStart;
F.sessStart =   sessStart;

tic;
while (GetSecs - sessStart <  T.sessDur)
    maePlotRealTime(I,K.k,F)
    [go, K.k]             = maeWait(K.sampHz, go, K.k);                       % wait until allowed to sample    
    [I.lick, isLicking]   = maeStoreEvents(I.lick, K.k, maeReadPorts(S));   % Record lick Event

if  (toc >= 1/K.mxRewardHz) && isLicking
    
    ports2Feed      =   maeLastEvent(I.lick,2);
                        maeTrigStim(S, stimCmd{ports2Feed});
                        maeFeedPorts(S,ports2Feed);              
    
    I.sOn    =   maeStoreEvents(I.sOn, K.k,     []);    
    I.sType  =   maeStoreEvents(I.sType, ports2Feed,  []);
    I.perf   =   maeStoreEvents(I.perf, K.k, [ports2Feed, 0]);
    I.water  =   maeStoreEvents(I.water, K.k, ports2Feed);     
    
    tic;

end
    
    


end

maeTrigStim(S, 'xx'); 
