classdef DataLog < handle
    %UNTITLED2 Summary of this class goes here
    %   Detailed explanation goes here
    properties 
        fileName
        fileId
        isOpen = false;
        
        logRateConstrained = false;
        logRate
        timeElapsedSinceLastLog
        lastLogTime = tic;
    end
    
    methods
        function obj = DataLog(mouseId)
            if nargin == 0
                mouseId = 'testMouse';
            end
            [~, obj.fileName] = createNewDataFile(mouseId);
            obj.fileId      = fopen(obj.fileName,'w');
            fprintf('\nData file %s\n ready for logging\n', obj.fileName); 
            obj.isOpen = true;               
        end
    
        
        function obj = writeToDataFile(obj, data)
            if obj.isOpen 
               if obj.logRateConstrained == false
                    obj = write2file(obj,data);
               else
                   obj.timeElapsedSinceLastLog = toc(obj.lastLogTime);
                   if obj.timeElapsedSinceLastLog > (1/obj.logRate)  
                       obj = write2file(obj,data);
                   else
%                       fprintf('\nDid Not Log: Not enough time has passed\n') 
                   end
               end    
            else
                fprintf('\nCANNOT LOG DATA. Open data file first before writing\n')
            end
        end

            
        function obj = unconstrainLogRate(obj)
            obj.logRateConstrained = false;
            obj.logRate  = [];      
        end
        
        function obj = constrainLogRate(obj, logRate)
            if nargin == 1
                obj.logRate  = 10;
            elseif nargin == 2
                obj.logRate  = logRate;                
            end
            obj.logRateConstrained = true;

        end
        
        function obj = closeDataFile(obj)
            fclose(obj.fileId);
            obj.isOpen = true;
        end
        
        
        
    end
   
    methods  (Static)
        function data = viewDataFile
            d = dir([cd '\beh_data']); 
            mouseFolders = d([d.isdir]);
            mouseFolders = mouseFolders(3:end);
            nMiceDataSets = numel(mouseFolders);
            data(nMiceDataSets) = struct('mouse', [], 'path', [], 'fileList', []);
            
            for i = 1:nMiceDataSets
                fname           = [mouseFolders(i).folder, '\', mouseFolders(i).name];
                dataFileList    = getBehDataFileList(fname);
                data(i).path    = mouseFolders(i).folder;
                data(i).mouse   = mouseFolders(i).name;
                data(i).fileList = dataFileList;
            end
            
        end
    end
    
end

%%
function obj = write2file(obj,data)
    if isnumeric(data) % if numbers 
        fprintf(obj.fileId, '%.03f ',data);
    elseif all(cellfun(@(s) ischar(s), data)) % if cell array of strings
        cellfun(@(s) fprintf(obj.fileId, '%s ', s), data)
    end
    fprintf(obj.fileId,'\n');
%     fprintf('\nData Logged\n')
    obj.lastLogTime = tic;
end
