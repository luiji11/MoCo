function mpaHoldOn(K, startTime, endTime)


while (GetSecs - trialStart <  1)
        go          = mpaWait(K.sampHz, go);
        K.k         = K.k + 1;
        K.sgLick    = mpaStoreEvents(K.sgLick, K.k, mpaReadPorts(S)); % Check For licks
                      mpaPlotRealTime(K.sgLick,K.k, F)
end