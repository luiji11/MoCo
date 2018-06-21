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
      
        
        function posDeg = readWheelPosition(obj) % reads and updates the current speed & direction of the wheel turn

            if obj.isConnected
                 posDeg    = obj.Mod.currentPosition;    
                 obj.currentPosition = posDeg;
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
        
        function winfo = wheelInfo(obj, turnSpeedThreshold)
            whl.readTurnSpeed;
            winfo.turnSpeed           = obj.turnSpeed; 
            winfo.turnDirection       = obj.turnDirection;                          
            winfo.turnedWheel         = abs(winfo.turnSpeed) > turnSpeedThreshold;             
        end
    
        
        function [didTurn, direction, quitBttn] = waitForWheelTurn(obj, deg, secs)
            if obj.isConnected
                obj.Mod.zeroPosition
            end    
            didTurn     = false;
            cPos        = 0;
            direction   = [];            
            tStart      = GetSecs;
            quitBttn    = false;
                       
            while (GetSecs - tStart) < secs
                cmd = readKey;
                if obj.isConnected
                   cPos = obj.readWheelPosition;
                elseif strcmp(cmd, 'a')
                      cPos = cPos - 1; 
                elseif strcmp(cmd, 'd')
                      cPos = cPos + 1;
                elseif strcmp(cmd, 'q')                       
                      quitBttn = true; 
                      disp('User Exited');                                             
                      break;  
                end
                   fprintf('\nWheel turned (@%.01f deg)', cPos)
                
                              
               if abs(cPos) >= deg
                   if cPos < 0
                       direction = 180;
                   elseif cPos > 0
                       direction = 0;                       
                   end   
                   didTurn = true;
                   fprintf('\n\n***Wheel turned %.01f deg within %.01f sec***\n',deg, secs);
                   break; 
               end
               pause(1/60);
            end
            
            if ~didTurn
                fprintf('\n\n***Wheel DID NOT TURN ENOUGH WITHIN %.01f SECS***\n', secs);           
            end

        end
        

        
        
    end
    
end

