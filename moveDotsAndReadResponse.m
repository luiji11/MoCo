function [correctResponse,...
          brokeWithEscButton] = moveDotsAndReadResponse(drw, dts, whl)
    whl.readTurnSpeed;
    brokeWithEscButton  = false;
    correctResponse     = false;
    
    
    while 1
        drw.displayDotPop(dts);
        dts.moveDots;
        
        % update and save the current speed & direction of the wheel turn         
        wheelInfo = whl.wheelInfo;
        if wheelInfo.turnedWheel
            correctResponse = (wheelInfo.turnDirection == dts.signalDots_direction);
            break
        end        
        
        if strcmp(readKey, 'esc')
           disp('Experimenter pressed escape button');
           brokeWithEscButton = true;
           break;
        end            
        
    end  
        
end