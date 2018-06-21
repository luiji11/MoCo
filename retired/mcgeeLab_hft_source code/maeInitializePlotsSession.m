
F.a2            = subplot(3,2,2);
F.climbPool     = plot(nan, nan, 'bo-'); hold on;
F.declinePool   = plot(nan, nan, 'ko-'); 
F.motivePool    = plot(nan, nan, 'co-');
legend('Climb', 'Decline', 'Stationary')
% F.hitData       = plot(nan, nan, 'g.'); hold on;
% F.missData      = plot(nan, nan, 'r.');
title('Session Progress')
% ylim([0 50])

% set(F.a2, 'ytick', [0 1], 'YTickLabel', {'Wrong', 'Correct'});


drawnow;
pause(.1)