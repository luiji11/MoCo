function phaseFreeResponse(mouseId)
%% FROM TOUCH SCREEN PAPER...
% 2.4.1. Training stage 1: Free Reward (FR)
% The purpose of this phase of training was to associate the tone
% with the delivery of a reward, and to learn the location of the
% reward (reward spout). During this phase, mice learned to lick
% the reward spout to receive a reward. 

% A trial started with a one second, 1 kHz tone
% followed by the delivery of a reward to the reward spout. 
% Licking the reward spout triggered the start of a new trial
% after the mouse had discontinued licking the reward spout for at
% least 200 ms. 
% This allowed for the mouse to consume the reward (Fig. 2a). 

% There was no timeout and no stimuli were presented on
% the touchscreen during this phase of training. 

% In order to advance, mice had to trigger more than 200 trials in an hour long session
% during two consecutive training days (Table 1). 

% Mice were allowed to take up to a maximum of five training days to reach criteria,
% however the mice in this study completed this stage in an average
% of 2.1 ± 0.4 (mean ± S.D.) days (Fig. 3a, Table 1).


%%
phaseName = 'Free Response Phase';
phaseDuration = 30;  % in seconds (so 60 minutes);
phaseStartTime = tic;
phaseTimeElapsed = 0;

numRewardsGiven = 0;
DATA = [];
%% TRAINING DATA AND INFO
stopLickDuration = .2; % must stop licking the reward spout for at least 200 ms for next trial to start
%% INITIALIZE OBJECTS
delete(instrfindall);
ARD = ARDUINO;                  % intialize arduino
ARD.readSensorState
loopRate = 30;

%% TRAIN

while phaseTimeElapsed < phaseDuration
    
    % play reward tone & deliver reward
    PLAYSOUND.rewardtone;       
    ARD.pulseValve;         
    
    lastLickTime = []; 
    while true
        % check if the mouse licks (sensor state will == 1)
        % if so record time of lick        
        if   ARD.readSensorState == 1 
            lastLickTime = GetSecs;  % disp('LICKED'); 
        end

        % get time elapsed since last lick  and
        % if mouse hasnt licked for 200 ms then move on and provide a new
        % reward
        timeElapsedSinceLastLick = GetSecs - lastLickTime;      
        if timeElapsedSinceLastLick > stopLickDuration      
            break;
        end
        
        % pause for 1/loopRate seconds
        pause(1/loopRate);
    end
    
    % increment reward count & % record time elapsed
    numRewardsGiven = numRewardsGiven + 1; 
    phaseTimeElapsed = toc(phaseStartTime);

end


end