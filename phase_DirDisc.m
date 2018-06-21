function phase_DirDisc(mouseId) 

% This training phase utilized a dot and fan image pair stimulus % (Bussey
% et al., 2001) and required the mice to touch a specific target % stimulus
% on the screen to earn a reward. The target stimulus % was randomly
% presented on either the left or right side of the % screen with no more
% than three target stimuli appearing on the % same side sequentially.
% During the initial stage of this phase, no % mask was present in front of
% the screen in order to encourage % touching the screen. Touching the
% target image (dot) on the % screen earned the mouse a reward from the
% reward spout along % with a 1 kHz tone (1 s), while touching the
% distractor image % (fan) resulted in a Gaussian white noise sound (1 s)
% and the house % lights coming on for a timeout period of 10 s (Fig. 2c).
% After an % incorrect answer, a correction trial (Horner et al., 2013;
% Oomen % et al., 2013) was given in which the same stimuli were presented
% % on the same side of the screen. This was repeated until the animal %
% chose correctly. The correction trial helped to break any bias that % a
% mouse might have for one side of the chamber and thus prevents % the
% mouse from accepting a time out 50% of the time. % Only the initial
% answer to a stimulus presentation was counted % toward the percentage
% correct (correction trials were ignored). % Again in this phase, a new
% trial was immediately triggered upon % cessation of licking the reward
% spout. As a result, the stimuli % was present as soon as the mouse turned
% and faced the screen, % maximizing time for discrimination while also
% assuring the stimuli % were presented when the mouse was roughly
% equidistance % between the two choices. In order to advance to the next
% stage % of training, mice had to perform this task with 85% accuracy on %
% 200 or more trials in one hour for two consecutive training days % (Table
% 1). Mice were allowed up to a maximum of 10 training days to reach
% criteria. After reaching criteria, a dividing mask was added in front of
% the screen to more clearly delineate the two stimuli and allowed up to an
% additional two days to return to criteria (Table 1). In practice,
% performance improved on the task with introduction of the mask, with no
% mice in this study taking the maximum of 12 days to pass this stage of
% training (Fig. 3a) The average number of training days at this stage
% (without and with the mask) was 7.4 ± 1.3 (mean ± S.D.) training days
% (Table 1).

try
%%
% Screen
drw = Draw(false);

% Stimulus
dts = DotPop(   'numdots',200,...
                'coherence', 100,...
                'maxwidth', drw.dispRect(3),...
                'maxheight', drw.dispRect(4));% initialize dot population 

% Arduino and Wheel
delete(instrfindall);
readRate = 30;       % rate (num X per sec) of reading the arduino sensor and wheel 
ard     = Arduino;  % arduino for lick sensing and reward distribution
whl     = Wheel;    % wheel for detecting turn     


% Data  
log                 = DataLog(mouseId); % open new data file for mouse to log and save data 
log.constrainLogRate(30); 
log.writeToDataFile({'time', 'lick', 'whlPos'});

% Training 
phaseDuration       = 60*60;    % duration of phase in seconds (so 60 minutes);
phaseStartTime      = tic;      % start time of phase
phaseTimeElapsed    = 0;        % total time elapsed 
stopLickDuration    = 1;        % must stop licking the reward spout for at least 200 ms for next trial to start
turnSpeedThreshold  = 2;
killTask            = false;
sigDirOptions    = [0 180];



%% TRAIN
while (phaseTimeElapsed < phaseDuration) && (killTask == false)
    
    %--------------------------------------------------------------------
    %  DISPLAY CENTER DOT & INITIALIZE TRIAL
    PlaySound.doubleLowPitch;  
    displayCenterDot(drw, 2);
    dts.signalDots_direction = sigDirOptions(randi(2)); 
    dts.assignDotTypeRandomly;
    %------------------------------------------------------------------
    % DISPLAY MOVING DOTS, CHECK FOR WHEEL TURN, AND CHECK IF TURN IS
    % CORRECT
     [correctResponse, killTask] = moveDotsAndReadResponse(drw, dts, whl, turnSpeedThreshold);
    %------------------------------------------------------------------
    % IF CORRECT GIVE REWARD, WAIT FOR CONSUME, AND START NEW TRIAL  
    % OTHERWISE GO TO CORRECTION TRIAL

    if correctResponse && (killTask == false)
        rewardEvents(ard);
        killTask = waitForRewardConsumption(ard, 'lickint', stopLickDuration);
        inCorrectionTrial = false;
    else
        disp('WRONG!!!')        
        inCorrectionTrial = true;
    end    
    %------------------------------------------------------------------
    % CORRECTION TRIAL
    while inCorrectionTrial && (killTask == false)
        disp('TIMEOUT!')
        displayLightsOnScreen(drw, 2);
        [correctResponse, killTask] = moveDotsAndReadResponse(drw, dts, whl, turnSpeedThreshold);
        if correctResponse
            rewardEvents(ard);
            killTask = waitForRewardConsumption(ard, 'lickint', stopLickDuration);
            inCorrectionTrial = false;
        else
            disp('WRONG!!!')        
            inCorrectionTrial = true;
        end            
                
    end
        
    phaseTimeElapsed  = toc(phaseStartTime);
 
end

drw.closeScreen
delete(instrfindall)
fclose('all');

catch ME
    disp('Safely closed')
    delete(instrfindall)
    fclose('all');
    sca;
    rethrow(ME)
    

end

end