function [dataFileList, dirFolderName] = getBehDataFileList(directory)
% returns a list file names in the directory that match the naming
% convention used to store behavioral data file
     
    i               = strfind(directory, '\');
    dirFolderName   =  directory(i(end)+1:end);                 % data files are prefixed with the name of directory folder
    dataFileNameStructure = [dirFolderName, '_\d\d\d\d.txt'];   %  end with a 4 digit id, and are txt files (for now)
    
    filelist = dir(directory); 
    filelist = {(filelist.name)}; % returns list of ALL files in directory
    dataFileList = filelist( cellfun(@(s) ~isempty(s), regexp(filelist, dataFileNameStructure) ) );   % returns only file names with appropriate naming structure 
    
    if isempty(dataFileList)
       fprintf('\nNo behavioral data files found in this directory\n')
    end
end