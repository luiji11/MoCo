function maePlotStimulus(F, type)   

switch type
    
    case 'fullScreen'
    F.stim.Position  = [0 0 1 1];
    F.stim.FaceColor = 'g';
    case 'grayScreen'
    F.stim.Position  = [0 0 1 1];
    F.stim.FaceColor = [.5 .5 .5]; 
    case 'timeOut'
    F.stim.Position  = [0 0 1 1];
    F.stim.FaceColor = 'r';     
    
end
end