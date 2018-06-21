function moco(mouseId, numDots, numCoherentDots)
%% Motion Coherence Learning Task
%%
delete(instrfindall);

maxNumTrials = 10;
maxDotLifeTime = 60*10; % life time of dots, in frames
sessionId = '000'; % starting session ID 
openMiniScreen = false; % true for debugging
%%

WHL = WHEEL;                % intialize wheel
ARD = ARDUINO;              % intialize arduino
SCR = SCREEN(openMiniScreen);               % initialize screen
DP = DOTPOP(numDots, numCoherentDots, maxDotLifeTime, SCR);% initialize dot population 
BTS = BOUTS;                % initialize training bouts (i.e. the phases within each trial)
TRL = TRIAL(maxNumTrials);          % initialize trial information 
REW = REWARD;               % initialize reward parameters
LOG = DATALOG(mouseId, sessionId, maxNumTrials); % initialize data log
%% BEGIN TASK

while 1

    SCR.drawInfo(BTS.currentBout, TRL.currentTrial, toc(TRL.trialTimeStart)); % draw information
    SCR.flipScreen;     % display all drawings  
    TRL.trialFrameCount = TRL.trialFrameCount+1; % increament the frame count in the trial        
    BTS.findCurrentBout(TRL.trialFrameCount); % Find the bout to enter in this frame 
    
    %------------------------------------------------------------------
    % BOUT 1: % Initialize trial (in the first frame)
    if any(BTS.currentBout == 1) 
        PLAYSOUND.doubleLowPitch;
                
        TRL.trialTimeStart      = tic;
        TRL.currentTrial        = TRL.currentTrial + 1; % label the trial
        REW.rewardGiven         = false;
        REW.responseMade        = false;
        REW.responseCorrect     = false;        
        REW.responseDirection   = nan;
        DP.setSignalDotDirection(DP.chooseSignalDirectionAtRandom);  % set the direction of the signal (randomly, left or right)                
        DP.randomizeDotPosition(1:DP.numDots);  % randomly distribute ALL dots throughout display
        DP.setDotTypeAtRandom;                 % assign each dot to be a 'signal' or 'noise' dot        
    end
    
    %------------------------------------------------------------------
    % BOUT 2 display a central dot 
    if any(BTS.currentBout == 2)
        SCR.drawCentralDot; % draw central dot
    end
    
    %------------------------------------------------------------------
     % BOUT 3 display a blank screen
    if any(BTS.currentBout == 3)
       % draw gray screen
    end    
    
    %------------------------------------------------------------------
    % BOUT 4 display Stimulus
    if any(BTS.currentBout == 4)
        Screen('FillOval', SCR.windowPtr, DP.color, DP.rectList); % draw the dots in their respective positions
        
        WHL.readWheelSpeed; % reads the current speed & direction of the wheel turn
        frameTurnSpeed      = WHL.turnSpeed;
        frameTurnDirection  = WHL.turnDirection;
        if (abs(frameTurnSpeed) > 1) && REW.responseMade == false     % if wheel turn is large enough (value TBD) and no previous wheel turn            
            REW.responseMade        = true;                                             % record that a response was made
            REW.responseDirection   = frameTurnDirection;                               % record the direction of the wheel turn
            REW.responseCorrect     = REW.responseDirection == DP.signalDots_direction; % record if the response was correct 
            
            if REW.responseCorrect % if correct 
                ARD.pulseValve;    % dispense water 
                REW.rewardGiven = true;
                disp('CORRECT !!!')
                PLAYSOUND.quickMediumPitch;
            else
                PLAYSOUND.quickLowPitch;
                disp('INCORRECT')
            end
            
        end       
        
        LOG.logFastData(SCR.flipCount,...
                        TRL.currentTrial,...
                        DP.signalDots_direction,...
                        frameTurnSpeed,...
                        frameTurnDirection,...
                        REW.rewardGiven);
                
                
        % Initialize dot display for the next frame...
        DP.incrementDotAge(1:DP.numDots);   % increase the age of all dots by 1 frame      
        DP.moveDots(1:DP.numDots);          % move all dots in their respective direction 
        
        DP.check4DeadDots;                          % check which dots have exceeded their life time  (all have the same age and life time in this training program so if one is dead then all are dead )                      
        DP.randomizeDotPosition(DP.deadDot_Ids);    % if dead, randomly distribute the dots throughout display again (both signal and noise dots)
        DP.zeroDotAge(DP.deadDot_Ids);              % set the age of dead dots to zero
        
    end
    
    %------------------------------------------------------------------
    % BOUT 5 Finalize current trial (last frame)
    if any(BTS.currentBout == 5) 
        LOG.logTrialData(SCR.flipCount,...
                         TRL.currentTrial,...
                         DP.signalDots_direction,...
                         REW.responseMade,...
                         REW.responseDirection,...
                         REW.responseCorrect,...
                         REW.rewardGiven);   % Log the events in the trial  
                     
        TRL.trialFrameCount = 0;  % set frame count to zero (for next trial)
    end
    
    
    if TRL.currentTrial > TRL.maxTrialsAllowed || strcmp(readKey, 'esc')
        break;
    end
    
    
    
end


SCR.closeScreen
LOG.saveDataLog;
end












