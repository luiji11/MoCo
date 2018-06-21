function [go, newK, newILick, isLicking] = maeScan(K,go,I,F,S)

hftPlotRealTime(I,K.k,F)
[go, newK]              = hftWait(K.sampHz, go, K.k);                     % wait until allowed to sample    
[newILick, isLicking]   = hftStoreEvents(I.lick, K.k, hftReadPorts(S));   % Record lick Event

end