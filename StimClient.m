classdef StimClient < handle
    %UNTITLED2 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        client
        status = '';
    end
    
    methods
        
        function obj = StimClient
            obj.openClient;
        end
        
        function obj = openClient(obj)
            obj.client = tcpip('127.0.0.1',55000,'NetworkRole','Client');
            disp('Calling Server...') 
            fopen(obj.client);
            obj.status = 'open';
            disp('Contact made. Ready to control stimulus')   
            
        end         
        
        function sendMessage(obj, message)
            switch obj.status
                case 'open'
                    fwrite(obj.client, message)
                    disp('message sent')
                case obj.status
                    disp('client cannot write bc not open')
            end
            
        end
        
        function msg = readMessageIfAvailable(obj)
           
            if obj.client.BytesAvailable
                numBytes = obj.client.BytesAvailable;
                msg = cellstr(char(fread(obj.client,numBytes)'));
                msg = msg{1};
            else
                 msg = '';
            end
            
        end
        
        function obj = closeClient(obj)
            switch obj.status
                case 'open'
                    fclose(obj.client);
                    obj.status = 'closed';
            end        

        end
        
        
    end
    
end

