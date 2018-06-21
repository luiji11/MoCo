function [newSampleTime, newSampleCount]  = hftWait(lickRate, oldSampleTime, oldSampleCount)

   while GetSecs - oldSampleTime < 1/lickRate; end; % wait until allowed to sample a response, once you do,
   newSampleTime = GetSecs;                         % Update time
   newSampleCount = oldSampleCount + 1;             % Update sample number

end

