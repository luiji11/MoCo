classdef StimServer < handle
    %UNTITLED3 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        server
        status = '';
    end
    
    methods
        
        function obj = StimServer
            obj.openServer;
        end
        
        function obj = openServer(obj)
            obj.server = tcpip('0.0.0.0',55000,'NetworkRole','Server');
            disp('Waiting for Client...') 
            fopen(obj.server);
            disp('Contact made. Stimulus Program Ready')            
            obj.status = 'open';
        end         
        
        function sendMessage(obj, message)
            switch obj.status
                case 'open'
                    fwrite(obj.server, message)
                    disp('message sent')
                case obj.server.Status
                    disp('server cannot write bc not open')
            end
            
        end
        
        function msg = readMessageIfAvailable(obj)
           
            if obj.server.BytesAvailable
                numBytes = obj.server.BytesAvailable;
                msg = cellstr(char(fread(obj.server,numBytes)'));
                msg = msg{1};
            else
                 msg = '';
            end
            
        end
        
        function obj = closeServer(obj)
            switch obj.status
                case 'open'
                    fclose(obj.server);
                    obj.status = 'closed';
            end        

        end
        
        
    end
    
end

