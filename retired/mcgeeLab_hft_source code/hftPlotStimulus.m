function hftPlotStimulus(F, type)   

switch type
    
    case 'fullScreen'
    F.stim.FaceColor = 'g';
    case 'grayScreen'
    F.stim.FaceColor = [.5 .5 .5]; 
    case 'timeOut'
    F.stim.FaceColor = 'r';     
    
end

end