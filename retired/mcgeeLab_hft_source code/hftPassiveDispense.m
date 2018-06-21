%% HFT PASSIVE DISPENSE

cd('C:\Users\Mcgeelab\Desktop\HFT')
clear; close all; clc;

S               = maeCommunicate('COM5');   % establish communication with Arduino
[I, T, K]       = hftInitializePars;        % initialize parameters
F               = hftInitializePlots(K,T);  % initiliaze real time figure

%%

ports2Feed  =   3;              % 3 to feed both ports
sessStart   =   GetSecs;        % Get the start time of the session
go          =   sessStart;      % For sampling
F.sessStart =   sessStart;      % For real time plot
rewardHz    =   .5;             % Rate of dispensing water

tic; 
while (GetSecs - sessStart <  T.sessDur) 
    hftPlotRealTime(I,K.k,F)                                         % plots in real time
    [go, K.k]      = hftWait(K.sampHz, go, K.k);                     % wait until allowed to sample    
    I.lick         = hftStoreEvents(I.lick, K.k, maeReadPorts(S));   % Record licks
        
if (toc >= 1/rewardHz)    
    maeFeedPorts(S,ports2Feed);    
    I.water  =   hftStoreEvents(I.water, K.k, ports2Feed);                  
    tic;        
end


end



