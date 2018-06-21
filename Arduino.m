classdef Arduino < handle
    %UNTITLED3 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        isConnected = true;
        Mod
        valve
        sensorState
    end
    
    methods
        function obj = Arduino
            obj = callArduino(obj);
        end
        
        function obj = callArduino(obj)

            try
                disp('CALLING ARDUINO...')        
                obj.Mod = serial('COM17');
                obj.Mod.BaudRate = 9600;
                fopen(obj.Mod);
                disp('      Connected :)')
                obj.valve.pulseWidth = .045; 
                
                pause(1); % pause otherwise cant read sensor 
                obj.readSensorState;

            catch
                obj.isConnected = false;    
                disp('      ***Connection Failed :(')
                pause(.5)
            end  
            
        end
        
        function obj = triggerValve(obj)
            PlaySound.rewardtone;
            if obj.isConnected
                fwrite(obj.Mod, 'p');     
                disp('Valve triggered');
            else
                disp('Cannot trigger valve: Arduino not connected')
            end

        end
        
        function sensorState = readSensorState(obj)
            if obj.isConnected
                fwrite(obj.Mod, 'w');
                obj.sensorState =  fread(obj.Mod,1,'uint8');
                sensorState = obj.sensorState;
            else
                sensorState = [];
                disp('Cannot read sensor: Arduino not connected')
            end      
        end
        
        function qBtn = waitForTouch(obj, interTouchInterval) 
            qBtn                = false;
            lastTouchTime       = nan;
                   
            while true
                % check if sensor was touched if so record time
                if obj.isConnected
                    if (obj.readSensorState == 1) 
                        lastTouchTime = anyTouchEvents;                     
                    end
                end
                
                % check if key was pressed: If l key, then respond as if
                % the sensor was touched (for debugging). If q key pressed,
                % then exit loop 
                cmd = readKey;   
                if strcmp(cmd, 'l')
                        lastTouchTime = anyTouchEvents;                     
                elseif strcmp(cmd, 'q')
                    disp('Quit button pressed')
                    qBtn = true; 
                    break;                          
                end

                % get the amount of time elapsed since last touch. if at least 200 ms have surpassed then exit loop
                if (GetSecs - lastTouchTime) > interTouchInterval
                    break;
                end
               
                % pause for 16ms  seconds before reading sensor again
                pause(1/60);                

            end   
        end
            
    end
    
    
end

function touchTime = anyTouchEvents(obj)
    disp('Sensor was touched')
    touchTime = GetSecs;
end   


