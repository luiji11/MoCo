classdef StimCmd < handle
    %UNTITLED2 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        client
        status = '';
    end
    
    methods
        
        function obj = StimCmd
            obj.openClient;
        end
        
        function obj = openClient(obj)
            if KeyInfo.onLuisMac 
                obj.client = udp(KeyInfo.luisPcIp, KeyInfo.luisPcPort,'LocalPort',KeyInfo.luisMacPort);
                fopen(obj.client);                
            elseif KeyInfo.onTrachPc
                instrreset;            
                obj.openTcpipOnNewMatlab;
            else
               error('Unkown communication setup') 
            end
            obj.status = 'open';
        end         
        
        function openTcpipOnNewMatlab(obj)
            !matlab -r prg=StimProgram &
            obj.client = tcpip('localhost', KeyInfo.trachPcPort, 'NetworkRole', 'client');
            tStart = tic;
            while toc(tStart) < 40 % wait 40 seconds for new matlab to open and start program
                try
                    fopen(obj.client);
                catch 
                end  
                if strcmp(obj.client.Status, 'open')
                   disp('Successfull open and contact with stim program') ;
                   break;
                else
                    disp('Could Not Connect; will try again')
                end                
                pause(1)
            end
        end
        function sendMessage(obj, message)
            switch obj.status
                case 'open'
                    fprintf(obj.client, message);
                    disp('message sent')
                case obj.status
                    disp('client cannot write bc not open')
            end
            
            if strcmp(message,'shutdown')
                obj.closeClient;
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

