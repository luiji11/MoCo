classdef TRIAL < handle
    %TRIAL information and methods regarding trials
    %   Detailed explanation goes here
    
    properties
        trialFrameCount = 0;
        currentTrial = 0;
        trialTimeStart = tic;
        maxTrialsAllowed = 10;

    end
    
    methods
        function obj = TRIAL(maxTrialsAllowed)
            obj.maxTrialsAllowed = maxTrialsAllowed;
        
        end

        
    end
    
end

