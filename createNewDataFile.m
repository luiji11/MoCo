function [fileName, fileNameFull, phaseId] = createNewDataFile(mouseId)
    dataPath    = [cd '\beh_data\',  mouseId]; 
    % Step 1: If mouse data folder does not exist then create one
    if ~exist(dataPath, 'dir')
        mkdir(dataPath)
        fprintf('\nNEW FOLDER CREATED for mouse %s', mouseId)
    end
    
    % get the name of folder in data path (should be named after mouse)    
    % get list of all file names in data path folder 
    % find files with appropriate name structure and extension
    % - folderName_###.mat are data files) - where ### is the phase Id value
    % then get the file id values from thes file names.
    % Will return as empty if there are no data files in folder
    
    [dataFileList, folderName] = getBehDataFileList(dataPath);
    fldrNameLength = numel(folderName);
    phaseValuesUsed     = zeros(1,numel(dataFileList));
    for i = 1:numel(dataFileList)
        fname_i = dataFileList{i};
        phaseValue_str = fname_i(fldrNameLength+2:end-4);
        phaseValuesUsed(i) = str2double(phaseValue_str);
    end
        
    % if there are no data files, then assume this is the first phase (e.g. phase 000)
    % If there is a data file, then add one to the largest id value found. 
    if  isempty(phaseValuesUsed)
         phaseValue = 0;
    else
        phaseValue = max(phaseValuesUsed)+1; 
    end
    
    %  Name the file based on the assigned phase 
    phaseId     = sprintf('%.04d', phaseValue);  
    fileName    = sprintf('%s_%s.txt', folderName, phaseId );
    fileNameFull = [dataPath '\'  fileName]; 

    fileID = fopen(fileNameFull, 'w');
    fclose(fileID);
    fprintf('\nNEW DATAFILE CREATED for mouse %s (%s)\n', mouseId, fileName)
end



