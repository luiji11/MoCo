function brokeWithEscButton = waitForRewardConsumption(ard, varargin) 

% Default 
    lickInterval    = .2; % to break, mouse cannot lick within .2 sec of previous lick
    readRate        = 60; % rate at which licks are being sensed

    keyList = varargin(1:2:end);
    valList = varargin(2:2:end);
    
    for i = 1:numel(keyList)
       switch keyList{i}
           case 'lickint'
               lickInterval = valList{i}; 
           case 'readrate'
               readRate = valList{i}; 
           otherwise
               error('unkown argument')
       end
    end
%%
    keepWaiting         = true;
    lastLickTime        = nan;
    brokeWithEscButton   = false;
    disp('Waiting for reward Consumption')
    while keepWaiting
        % read the sensor to check if the mouse licks (sensor state will
        % equal 1) if so record time of lick
        licked = (ard.readSensorState == 1);
        if  licked
            lastLickTime = GetSecs;
            PlaySound.quickLowPitch;
        end

        % get the amount of time elapsed since last lick. if mouse has not
        % licked for 200 ms then increment reward count and move on to next
        % trial
        timeElapsedSinceLastLick = GetSecs - lastLickTime;  
        if timeElapsedSinceLastLick > lickInterval   
            keepWaiting = false;
        end
        % Record time elapsed, log if mouse licked or not and the time
        % stamp. Then pause for 1/loopRate seconds before reading arduino
        % sensor again
        pause(1/readRate);
        
        if strcmp(readKey, 'esc')
           disp('Experimenter pressed escape button');
           brokeWithEscButton = true;
           break;
        end          
               
    end

end