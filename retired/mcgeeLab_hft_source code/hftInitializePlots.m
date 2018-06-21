function F = hftInitializePlots(K,T)

close(gcf)
clear F;
F.fg        = figure;
set(F.fg, 'position', [1921 -199 720 1204]) % change this to position your figure on your screen
visWindow   = 30;               % plot responses occuring withing the last visWindow seconds 


%% Real Time
F.visWindow = visWindow * K.sampHz; 

F.a1            = subplot(2,3,5);  
% set(F.a1, 'units', 'normalized', 'position', [.07 .6 .2 .25])
F.rawLicks      = plot(1:F.visWindow, nan(1,F.visWindow), 'c-'); hold on;

F.rewardTime    = plot(nan, nan, 'b*', 'markersize', 7);

F.time          = text(1.05, .9, sprintf('%d/',0), 'units', 'normalized');
                  text(1.35, .9, sprintf('%d s',round(T.sessDur)), 'units', 'normalized');
F.rewardCount   = text(1.05, .8, sprintf('0/0 Rewards taken (%d uL)',0), 'units', 'normalized');

F.tmOutState    = '';
F.timeOut       = text(1.05, .7, sprintf('%s', F.tmOutState),'units', 'normalized') ;

xlabel('k');  ylabel('Response');

xlim([-K.sampHz F.visWindow+K.sampHz]); 
ylim([-3 3]); 

set(F.a1,'ytick', ([-1 0 1]),'yticklabel', {'Left', '~', 'Right'}, 'ygrid', 'on');

view(90,90);  

title('Real Time')

%% Stimulus 
F.a2            = subplot(4,3,5);  
% set(F.a2, 'units', 'normalized', 'position', [.25 .25 .2 .2])
F.stim        = rectangle('position', [0 0 1 1], 'facecolor', 'w');
axis off
%%

drawnow;
pause(.1)
end








