function checkLickSensor
    ard = Arduino;

    if ~ard.isConnected 
       delete(instrfindall)
       ard = Arduino;
    end
        
    while true
        disp(ard.readSensorState)
        if ard.sensorState == 1
            rewardEvents(ard);   
        end
        
        if strcmp(readKey, 'esc')
           break;
        end   
        
    end


end