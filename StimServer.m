classdef StimServer < handle
    %UNTITLED3 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        server
        status = '';
    end
    
    methods
        
        function obj = StimServer
            try
            obj.openServer;
            catch
                 instrreset;  
                disp('Error but safely closed')               
            end
        end
        
        function obj = openServer(obj)
            try
                if KeyInfo.onLuisPc	     
                    instrreset;                  
                    obj.server = udp(KeyInfo.luisMacIp,KeyInfo.luisMacPort,'LocalPort', KeyInfo.luisPcPort);              
                    disp('Opened Stimulus Server (upd)')                
                elseif KeyInfo.onTrachPc
                    obj.server = tcpip('0.0.0.0', KeyInfo.trachPcPort, 'NetworkRole', 'server');
                    disp('Opened Stimulus Server (tcpip)')
                else
                   error('Unkown Machines; cannot set up comminication') 
                end
                fopen(obj.server);
                obj.status = 'open';
            catch ME
                instrreset;  
                disp('Error but safely closed')
                rethrow(ME)
            end
        end         
        
        function sendMessage(obj, message)
            switch obj.status
                case 'open'
                    fprintf(obj.server, message);
                    disp('message sent to cntrlr')
                case obj.server.Status
                    disp('server cannot write bc not open')
            end
        end
        
        function msg = readMessageIfAvailable(obj)
            if obj.server.BytesAvailable
                msg = fscanf(obj.server, '%s');
            else
                 msg = '';
            end
            
            if strcmp(msg, 'shutdown')
                obj.closeServer;
                if KeyInfo.onTrachPc
                    disp('Matlab Will Close...')
                    pause(.5)
                    exit;
                end
            end
        end
        
        function obj = closeServer(obj)
            switch obj.status
                case 'open'
                    fclose(obj.server);
                    delete(obj.server);
                    obj.status = 'closed';
            end        

        end
        
        
    end
    
end

