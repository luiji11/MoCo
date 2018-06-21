function event = maeLastEvent(sig, j) 
% This function retreives, from any of your event matrices (e.g. I.lick),
% information regarding the last event that occurred in that data storage
% matrix. 

% So if "event = mpaLastEvent(sig, i)", sig is the event matrix. j is the
% column (e.g. 2) or columns (e.g. [2 3], [2 4 5]) where you wish to
% retreive the last event from.

if find(sig == 0,1)-1 == 0
    event = zeros(1,numel(j));
else
    event = sig( find(sig == 0,1)-1, j );

end

