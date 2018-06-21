function obj = nameDataFile(obj, mouseId)

    namePhaseDataFile(mouseId);
    
    fprintf('\n\t\t\tPath: %s', obj.dataPath)    
    fprintf('\n\t\t\tFolder Name: %s', obj.mouseId)
    fprintf('\n\t\t\tFile Name: %s\t\n', obj.fileName) 
end




