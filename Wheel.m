classdef Wheel < handle
    %UNTITLED2 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        isConnected = true;
        Mod
        lastPosition  
        currentPosition

        turnSpeed
        turnDirection
    end
    
    methods
        function obj = Wheel()
            obj = callWheel(obj);
        end
 
        function obj = callWheel(obj)
            try 
                warning('off');
                fprintf('\t\n')        
                obj.Mod = RotaryEncoderModule('COM15'); % encoder in port #15 
                obj.Mod.zeroPosition;           % zero the encoder
                obj.lastPosition = 0;
                readTurnSpeed(obj);                
                disp('      Connected :)')

                warning('on');

            catch
                warning('on');
                obj.isConnected = false ; % connection failed
                obj.turnSpeed   = nan;    % cannot compute speed of wheel turn
                obj.turnDirection = nan;
                obj.currentPosition = nan;
                disp('      !!!CONNECTION FAILED :(');
                pause(.02)
            end        
        
        
        end
      
        
        function obj = readWheelPosition(obj) % reads and updates the current speed & direction of the wheel turn

            if obj.isConnected
                obj.currentPosition     = obj.Mod.currentPosition;     
            else
               disp('Wheel not connected; cannot read position') 
            end
            
        end
        
        function turnSpeed = readTurnSpeed(obj) % reads and updates the current speed & direction of the wheel turn
            if obj.isConnected
                obj.currentPosition = obj.Mod.currentPosition; 
                obj.turnSpeed       = obj.currentPosition - obj.lastPosition;                
                obj.lastPosition    = obj.currentPosition;
                
                if sign(obj.turnSpeed) > 0 
                    obj.turnDirection = 0;
                elseif sign(obj.turnSpeed) < 0
                    obj.turnDirection = 180;
                elseif sign(obj.turnSpeed) == 0
                    obj.turnDirection = nan;
                end
                turnSpeed = obj.turnSpeed;
            else
                turnSpeed = [];
                disp('Wheel not connected; cannot read speed') 
            end
            
        end
        
        function winfo = wheelInfo(obj, varargin)
            whl.readTurnSpeed;
            winfo.turnSpeed           = obj.turnSpeed; 
            winfo.turnDirection       = obj.turnDirection;
            
            if nargin == 1 
                turnSpeedThreshold = 3;
            elseif nargin == 2
                turnSpeedThreshold = varargin{1};
            end
                
            winfo.turnedWheel         = abs(winfo.turnSpeed) > turnSpeedThreshold;             
        end
    

        
        
    end
    
end

