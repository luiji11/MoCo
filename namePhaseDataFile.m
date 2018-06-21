function [fileName, fileNameFull, phaseId] = namePhaseDataFile(mouseId)
    dataPath = createDataPath4Mouse(mouseId);

    % get the folder of the data path
    % and get list of all file names in data path folder  
    folderName  = getDataPathFolder(dataPath); 
    flist       = getFileList(dataPath); %     
    folderNameLength = numel(folderName);
    extName = '.txt';
    extNameLength = numel(extName);
    
    % find files with appropriate name structure and extension
    % - folderName_###.mat are data files) - where ### is the phase Id value
    % then get the file id values from thes file names.
    % Will return as empty if there are no data files in folder
    flist_dataFiles = flist( cellfun(@(s) ~isempty(s), regexp(flist, [folderName, '_\d\d\d\d.txt']) ) );
    phaseValuesUsed = cellfun(@(s) s(folderNameLength+2:end-extNameLength), flist_dataFiles, 'UniformOutput' , false);
    phaseValuesUsed = str2double(phaseValuesUsed);
        
    % if there are no data files, then assume this is the first phase (e.g. phase 000)
    % If there is a data file, then add one to the largest id value found. 
    if ~isempty(phaseValuesUsed) 
        phaseValue = max(phaseValuesUsed)+1;
    else
         phaseValue = 0;        
    end
    
    %  Name the file based on the assigned phase 
    phaseId     = sprintf('%.04d', phaseValue);  
    fileName    = sprintf('%s_%s.txt', folderName, phaseId );
    fileNameFull = [dataPath '\'  fileName]; 

    fileID = fopen(fileNameFull, 'w');
    fclose(fileID);

end

function mouseDataPath = createDataPath4Mouse(mouseId)
    mouseDataPath    = [cd '\' mouseId]; 
    % Step 1: If mouse data folder does not exist then create one
    if ~exist(mouseDataPath, 'dir')
        mkdir(mouseDataPath)
        fprintf('\n***Created new folder for log file: %s', mouseId)
    end
    
end

function folderName = getDataPathFolder(dataPath)
    i           = strfind(dataPath, '\');
    folderName  =  dataPath(i(end)+1:end); % file will be prefixed with the name of folder of the datapath
end

function filelist = getFileList(dataPath)
    filelist = dir(dataPath); 
    filelist = {(filelist.name)};
end

