function mpaPlotSession(I,  F)
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here
%{
MCGEE METHOD W/ Luis Staircase
%% Staircases
axes(F.a2);
nTrials     = find(I.perf(:,1) == 0,1)-1;
t           = 1:nTrials;

m  = I.sVal(I.sStair == 1);   
set(F.motivePool, 'xdata', 1:numel(m), 'ydata', m)

c  = I.sVal(I.sStair == 2);   
set(F.climbPool, 'xdata', 1:numel(c), 'ydata', c)

d  = I.sVal(I.sStair == 3);   
set(F.declinePool, 'xdata', 1:numel(d), 'ydata', d)

%%
    
poolPerf    = I.perf(I.sStair == 1,2:3); 
poolPerf    = (poolPerf(:,1)==4) == poolPerf(:,2);
x = find(poolPerf == 0);
set(F.motivePerf, 'xdata', x, 'ydata', m(x))

poolPerf    = I.perf(I.sStair == 2,2:3); 
poolPerf    = (poolPerf(:,1)==4) == poolPerf(:,2);
x = find(poolPerf == 0); 
set(F.climbPerf, 'xdata', x, 'ydata', c(x))

poolPerf    = I.perf(I.sStair == 3,2:3); 
poolPerf    = (poolPerf(:,1)==4) == poolPerf(:,2);
x = find(poolPerf == 0);
set(F.declinePerf, 'xdata', x, 'ydata', d(x))


% xlim([0 max([m c d])+1]);
axis tight

drawnow;
%}

%%



F.stimInt.XData = find(I.sVal ~=0);
I.sVal ( isnan( I.sVal ) ) = 0;
F.stimInt.YData = I.sVal(F.stimInt.XData);


t = find(I.perf(:,1) == 0, 1)-1;
x = I.perf(1:t,:);
perf = ((x(:,2)-1) == (x(:,3)));

F.wrong.XData = find( ((x(:,2)-1) == (x(:,3))) == 0);
F.wrong.YData = F.stimInt.YData(F.wrong.XData);

% Psychmetric Function
% I.sVal(1:t) == perf
% 
% F.psf.XData











