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
% Stimulus
instrreset;
stm = StimCmd;
stm.sendMessage('newcoherence'); 
stm.sendMessage('.8');
stm.sendMessage('whitescreen');
% Arduino and Wheel
ard         = Arduino;  % arduino for lick sensing and reward distribution
whl         = Wheel;    % wheel for detecting turn     

% Data  
log                 = DataLog(mouseId); % open new data file for mouse to log and save data 
log.constrainLogRate(30); 
log.writeToDataFile({'time', 'lick', 'whlPos'});

% Training 
phaseDuration       = 60*60;    % duration of phase in seconds (so 60 minutes);
phaseStartTime      = tic;      % start time of phase
phaseTimeElapsed    = 0;        % total time elapsed 
killTask            = false;

    
%% TRAIN
while (phaseTimeElapsed < phaseDuration) && (killTask == false)
    
    %  Display Gray Screen
    PlaySound.doubleLowPitch; 
    stm.sendMessage('grayscreen');
    stm.sendMessage('writenewmessage');
    stm.sendMessage('NEW_TRIAL!!!__(wait__1.5__secs)');
    pause(1.5)
    
    % Display Dots random direction 
    flushinput(stm.client);
    stm.sendMessage('newdirection'); 
    
    % Wait for mouse to turn wheel
    [~, whlTrndirection, killTask] = whl.waitForWheelTurn(45, 10); 

    % check if the turn direction corresponds to dot direction
    dotDirection = str2double(stm.waitForMessage(5));
    disp(dotDirection)
    correctTurn = (whlTrndirection == dotDirection);  
    
    % if so give reward and wait for consumption
    if  correctTurn 
        stm.sendMessage('writenewmessage');
        stm.sendMessage('CORRECT!_(waiting_on_consumption)');                  
        ard.triggerValve;
        ard.waitForTouch(2);                
    else
    % otherwise repeat the trial with same dot direction
        while true     
            %  Display White Screen         
            stm.sendMessage('writenewmessage');
            stm.sendMessage('WRONG!!!');   
            pause(2)                  
            stm.sendMessage('whitescreen'); 
            pause(2)      

            % Dots (in same direction) and read wheel       
            stm.sendMessage('moco');
            [~, whlTrndirection, killTask] = whl.waitForWheelTurn(45, 10);            
            correctTurn = (whlTrndirection == dotDirection);               
            if  correctTurn 
                stm.sendMessage('writenewmessage');
                stm.sendMessage('CORRECT!__(Waiting__on__consumption)');                  
                ard.triggerValve;
                ard.waitForTouch(2); 
                break;
            end       
        
        end
                   
    end
    
        
    phaseTimeElapsed  = toc(phaseStartTime);
 
end

stm.sendMessage('shutdown');
instrreset;

catch ME
    stm.sendMessage('shutdown');
    instrreset;
    disp('Safely closed')    
    rethrow(ME)
end

end