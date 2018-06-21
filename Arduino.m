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
        
        function obj = pulseValve(obj)
            if obj.isConnected
                fwrite(obj.Mod, 'p');     
                disp('Water given');
            else
                disp('Cannot give water: Arduino not connected')
            end
        end
        
        function sensorState = readSensorState(obj)
            if obj.isConnected;    
                fwrite(obj.Mod, 'w');
                obj.sensorState =  fread(obj.Mod,1,'uint8');
                sensorState = obj.sensorState;
            else
                sensorState = [];
                disp('Cannot read sensor: Arduino not connected')
            end      
        end
    end
    
end

