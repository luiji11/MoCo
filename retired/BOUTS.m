classdef BOUTS < handle
    %PHASES information and methods regarding training bouts (within
    %trials)
    %   Detailed explanation goes here
    
    properties
        boutFrameWindows                
        sessionFrameCount = 0;        
        currentBout = 0;
    end
    
    methods
        function obj = BOUTS
                                % Start     Stop Frame
            obj.boutFrameWindows = [1           1;...       % initialize trial in frame 1
                                    1           1*60;...    % fixation for 1 sec 
                                    1*60        1.25*60;... % blank screen for 250 ms
                                    1.25*60     8*60;... % present stimulus for 5 seconds max
                                    8*60        8*60];   % finalize trial at the last frame                                      
        end

        
        function obj = findCurrentBout(obj, trialFrameCount)
            obj.currentBout = find( (trialFrameCount >= obj.boutFrameWindows(:,1)) &...
                                    (trialFrameCount <= obj.boutFrameWindows(:,2))) ;
        
            if isempty(obj.currentBout)
                fprintf('\nCould not find current Bout!(current trial frame is %d)\n', trialFrameCount)
            end
        end
 
        
        
    end
    
end

