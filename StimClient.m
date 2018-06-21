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
            instrreset;  close all; delete(instrfindall); 
            ip_stimComputer = '192.168.0.2';   
            port_stimComputer = 50000;   
            port_ctrlComputer = 50001;  
            obj.client = udp(ip_stimComputer, port_stimComputer,'LocalPort',port_ctrlComputer);
            fopen(obj.client);
            obj.status = 'open';
        end         
        
        function sendMessage(obj, message)
            switch obj.status
                case 'open'
                    fprintf(obj.client, message);
                    disp('message sent')
                case obj.status
                    disp('client cannot write bc not open')
            end
            
        end
        
        function msg = waitForMessage(obj, timeOut)    
            tStart = tic;
            while toc(tStart) < timeOut
                msg = obj.readMessageIfAvailable;                
                if ~isempty(msg)                                       
                    break;
                end              
            end
            
            if isempty(msg)                    
                error('Did not receive any relevent messages');
            end              
                       
            
            
            
        end
        
        function msg = readMessageIfAvailable(obj)
           
            if obj.client.BytesAvailable
                msg = fscanf(obj.client, '%s');
            else
                 msg = '';
            end
        end
        
        function obj = closeClient(obj)
            switch obj.status
                case 'open'
                    fclose(obj.client);
                    delete(obj.client);
                    obj.status = 'closed';
            end        
        end
        
        
    end
    
end

