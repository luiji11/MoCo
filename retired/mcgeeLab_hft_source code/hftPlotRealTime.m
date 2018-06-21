function hftPlotRealTime(I, k, F)
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here
%% REALTIME
axes(F.a1);
mn          = k - F.visWindow +1;

% Lick Tracker
    f           = I.lick( I.lick(:,1) >= mn, : );
    f(:,1)      = f(:,1) - mn+1;    
    y           = zeros(F.visWindow,1);
    y(f(:,1))   = f(:,2);             
    y(y == 1)   = -1;
    y(y == 2)   = 1;
    set(F.rawLicks, 'ydata', y);

% Reward Tracker
    f           = I.water( I.water(:,1) >= mn, : );
    f(:,1)      = f(:,1) - mn+1;    
    y           = f(:,2);
    y(y == 1) = -1;
    y(y == 2) = 1;
    y(y == 3) = 0;
    set(F.rewardTime, 'xdata', f(:,1), 'ydata', y);
    
% Time out Tracker
set(F.timeOut, 'String', sprintf('%s',F.tmOutState)) 


% Time Tracker
set(F.time, 'string', sprintf('%.0f/', GetSecs- F.sessStart))


drawnow;


%%


















