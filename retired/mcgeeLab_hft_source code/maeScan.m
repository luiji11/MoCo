function [go, newK, newILick, isLicking] = maeScan(K,go,I,F,S)

maePlotRealTime(I,K.k,F)
[go, newK]              = maeWait(K.sampHz, go, K.k);                     % wait until allowed to sample    
[newILick, isLicking]   = maeStoreEvents(I.lick, K.k, maeReadPorts(S));   % Record lick Event

end