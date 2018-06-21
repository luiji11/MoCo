function displayLightsOnScreen(drw, duration)

    tStart = tic;
    drw.drawColoredBackground([255 255 255]); 
    while true
        drw.flipScreen;
        if toc(tStart) > duration
            break
        end            
    end  
    drw.drawColoredBackground([128 128 128]); 
    
        
end