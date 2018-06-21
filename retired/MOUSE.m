classdef MOUSE < handle
    %UNTITLED4 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        lastLickTime    = nan;
    end
    
    methods  
        function obj = isLicking(obj, ARDUINO)
            ARDUINO.readSensorState;  % reads and updates the state of arduino sensor 
            if ARDUINO.sensorState ==1 % sensor state = 1 if mouse licks, zero otherwise
                obj.lastLickTime = tic;
            end
        end
        
        function timeElapsed = timeElapsedSinceLastLick(obj)
            timeElapsed = toc(obj.lastLickTime);
        end
        
    end
    
    
    
end

