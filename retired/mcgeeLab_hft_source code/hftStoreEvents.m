function [updatedDataMat, event] = maeStoreEvents(eventMat, eventFrame, event2Save)
%MPASTOREEVENTS stores events in the next available position within your
%'sig' data matrix.
%
% This function has proven to be VERY usefull for
% collecting the lick response in real time, and for storing other critical
% data - e.g. stimulus timestamps, frames when water was dispensed, etc.
%
% Specifically, the function ignores anything that is not an event - e.g.
% when 'otherEventOrIgnore' equals zero, we dont save anything. The
% function does, however, save important events - e.g. if
% "otherEventOrIgnore" is greater than zero, then the frame will be stored
% AND 'otherEventOrIgnore' will also be stored.) 

% Here is an example for using the function... 

% When reading a lick response, you do not want to save the frame when
% there is no licking behavior. In such a case, the input variable
% "otherEventorIgnore" would take on the value of zero, and no information
% will be saved. But if the variable happens to be greater than zero (1 or
% 2 for left or right port), then it will store it, along with the frame
% number that it occured with.

%Moreover, This function increases the size of your storage matrices in
%case they run out of space. This is important because I have no idea how
%much space I should preallocate to store the raw lick response, the number
%of trials, the amount of times that water is dispensed, or the number of
%times stimuli will be displayed. 

% Inputs:
%   sig: Your MxN data matrix, such as your lick signal, your trial
%   matrix, or your reward matrix
%
%   eventFrame: the frame number the event(s) coincided with. You tend to
%   have this value stored as R.k.
%
%   otherEventsOrIgnore: a code for the event, or list of codes. These code
%   can refer to the port that was licked (0,1 or 2), the side where the
%   stimulus appeared (1, 2, etc.), or the port that water was delivered
%   to). You can include more than one event by concatenating the events
%   (e.g. [1 3])

% Outputs:
%   updatedSig: An updated version of the matrix, with a new event if one
%   occured.
%    


i = find(eventMat==0,1); % find the first available position in your data matrix.


if i == length(eventMat) % if there are no more positions available, make more space
    eventMat = [eventMat; zeros(round(length(eventMat)/3),size(eventMat,2))];
end


% If otherEventOrIgnore is zero, (i.e. if there is no event), dont store
% anything. If it is greater than zero store the frame and the event. (Or,
% to store only the frame info set otherEventorIgnore to [], in an empty
% bracket).
event = (sum(event2Save) > 0) || isempty(event2Save);

eventMat(i,1:size(event2Save,2)+1) = [eventFrame, event2Save] * event ;   %     

updatedDataMat = eventMat;


end