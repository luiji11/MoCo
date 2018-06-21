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
            instrreset;  delete(instrfindall); close all;         
            port_stimComputer = 50000;     
            ip_ctrlComputer= '192.168.0.6';  % Luis Mac Ip 
            port_ctrlComputer = 50001;  
            obj.server = udp(ip_ctrlComputer,port_ctrlComputer,'LocalPort', port_stimComputer);
            fopen(obj.server);
            obj.status = 'open';
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

