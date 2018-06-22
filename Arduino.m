classdef Arduino < handle
    %UNTITLED3 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        isConnected;
        Mod
        pulseWidth
        sensorState
    end
    
    methods
        function obj = Arduino
            obj = callArduino(obj);           
        end
        
        function obj = callArduino(obj)  
       
            if Devices.onTrachPc
                tStart = tic;         
                pause(.5);              
                while toc(tStart) < 40 % wait 40 seconds for new matlab to open and start program
                    try
                        delete(instrfind('tag', Devices.arduinoTag));
                        obj.Mod = serial(Devices.arduinoPort, 'tag', Devices.arduinoNameTag); % COM17                       
                        fopen(obj.Mod);               
                    catch 
                    end  

                    if strcmp(obj.Mod.Status, 'open')
                       obj.isConnected = true;
                       fprintf('/tArduino Connected :)/n') ;
                       break;
                    else
                       obj.isConnected = false;                   
                       disp('Could Not Connect; will try again');
                    end                
                    pause(1);
                end
                pause(1); % pause breifly once connected, otherwise cant read sensor

            elseif Devices.onLuisPc || Devices.onLuisMac
                obj.isConnected = false;   
                disp('Arduino cannot be connected on this device');
            end
            
            obj.updatePulseWidth;
            obj.readSensorState;
        end
        
        function obj = triggerValve(obj)     
            if obj.isConnected
                PlaySound.rewardtone;
                fwrite(obj.Mod, 'p');     
                disp('Valve triggered');
            else
                disp('Cannot trigger valve: Arduino not connected');
            end
        end
        
        function sensorState = readSensorState(obj)
            if obj.isConnected
                fwrite(obj.Mod, 'w');
                obj.sensorState =  fread(obj.Mod,1,'uint8');
                sensorState = obj.sensorState;
            else
                sensorState = [];
                disp('Cannot read sensor: Arduino not connected');
            end      
        end
        
        function qBtn = waitForTouch(obj, interTouchInterval) 
            qBtn                = false;
            lastTouchTime       = nan;
                   
            while true
                % check if sensor was touched if so record time
                if obj.isConnected
                    if (obj.readSensorState == 1) 
                        lastTouchTime = touchEvents;                     
                    end
                end
                
                % check if key was pressed: If l key, then respond as if
                % the sensor was touched (for debugging). If q key pressed,
                % then exit loop 
                cmd = readKey;   
                if strcmp(cmd, 'l')
                        lastTouchTime = touchEvents;                     
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
        

        
        function updatePulseWidth(obj)   
            % write to arduino
            % have it respond with pulse width***
            % arduinoPulseWidth = pulseWidthResponse
            obj.pulseWidth = .045;
        end
        
            
    end
    
    
end

function touchTime = touchEvents
    disp('Sensor was touched')
    touchTime = GetSecs;
end   


