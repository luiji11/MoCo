function displayCenterDot(drw, duration)
    tStart = tic;
    while 1
        drw.drawCentralDot; % draw central dot
        drw.flipScreen;
        if toc(tStart) > duration
            break
        end            
    end
end