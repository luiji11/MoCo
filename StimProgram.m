classdef StimProgram < handle
    %UNTITLED4 Summary of this class goes here
    %   Detailed explanation goes here
     
    properties
        scr
        dts        
        srv
        msgOptions = {  'pause',...
                        'moco', 'newdirection', 'setcoherence','setlifetime',...
                        'whitescreen', 'grayscreen',...
                        'writenewmessage',...
                        'shutdown'};
        setThenShow = true;
        msg
    end
    
    methods

        function obj = StimProgram
            try
                obj.start;
            catch ME                
                if ~isempty(obj.scr)
                    obj.scr.closeScreen
                end
                if ~isempty(obj.srv)
                    obj.srv.closeServer                     
                end
                instrreset
                disp('Safely Closed Stim Program')
                rethrow(ME)
            end 
        end
        
        function start(obj)
            obj.dts = DotPop;
            obj.scr = obj.dts.openDotPopAndScreen;
            obj.srv = StimServer;
            obj.msg = 'pause';
            while true
                switch obj.msg  
                    case 'pause'
                        obj.pause;
                    case 'moco'
                        obj.moco;
                    case 'newdirection'
                        obj.newdirection
                    case 'setcoherence'
                        obj.setcoherence;  
                    case 'setlifetime'
                        obj.setlifetime
                    case 'whitescreen'
                        obj.coloredScreen([255 255 255]);
                    case 'grayscreen'
                        obj.coloredScreen([127 127 127]); 
                    case 'writenewmessage'
                        obj.writenewmessage;
                    case 'shutdown'
                        obj.shutdown 
                        break;
                end
            end
        end
    
        function obj = pause(obj)
            tstring = cellfun(@(s) sprintf('\n%s', s) , obj.msgOptions, 'uniformoutput', false);
            tstring = [tstring{:}];
            while true
                obj.drawCenterText(sprintf('Waiting for commands:%s',tstring)) ;                 
                obj.scr.flipScreen; 
                obj.msg = obj.srv.readMessageIfAvailable;
                if any(strcmp(obj.msg, obj.msgOptions))
                   break 
                end             
            end
        end
        
        function obj = setcoherence(obj)
            while true
                obj.drawCenterText('Enter coherence [value from 0 to 1]...') ;                 
                obj.scr.flipScreen;    
                obj.msg = obj.srv.readMessageIfAvailable;
                c= str2num(obj.msg);
                if ~isempty(c) && ~isnan(c)
                    numCoherentDots = round(c*obj.dts.numDots);
                    obj.dts.setCoherence(numCoherentDots);
                    if obj.setThenShow
                        obj.msg = 'moco';
                    else
                        obj.drawCenterText(sprintf('Coherence Set to %.02f',c));                                   
                        obj.scr.flipScreen;                          
                        obj.msg = 'pause';
                        pause(1.25)
                    end
                    break 
                end 
            end          
        end
        function obj = setlifetime(obj)
            while true
                obj.drawCenterText('Enter life time value [in frames from 1 to inf]...') ;                 
                obj.scr.flipScreen;    
                obj.msg = obj.srv.readMessageIfAvailable;
                c= str2num(obj.msg);
                if ~isempty(c) && ~isnan(c)
                    obj.dts.setNewLifeTime(c);
                    if obj.setThenShow
                        obj.msg = 'moco';
                    else
                        obj.drawCenterText(sprintf('Life Time Set to %d frames',c))  ;                                   
                        obj.scr.flipScreen;                         
                        obj.msg = 'pause';
                        pause(1.25)
                    end
                    break 
                end 
            end          
        end
        
        function newdirection(obj)
            obj.dts.setNewSignalDirectionAtRandom;
            newDir = obj.dts.setNewSignalDirectionAtRandom;
            obj.srv.sendMessage(num2str(newDir));
            if obj.setThenShow
                obj.msg = 'moco';
            else                       
                obj.msg = 'pause';
            end            
        end

        function obj = moco(obj)
            tStart = tic;
            Screen('FillRect', obj.scr.windowPtr, [127 127 127], obj.scr.dispRect); 
            while true
                Screen('FillOval', obj.scr.windowPtr, obj.dts.color, obj.dts.getDotRectList);
                tstring = sprintf('NumDots: %d\nCoherence: %.01f\nLifeTime: %d (f)\nTimeElapsed: %.01f',...
                                obj.dts.numDots, obj.dts.coherence/obj.dts.numDots, obj.dts.lifeTime, toc(tStart));                               
                DrawFormattedText(obj.scr.windowPtr, tstring,40, 40, [255 0 0]);    
                obj.scr.flipScreen;    
                obj.dts.moveDots;
                obj.msg = obj.srv.readMessageIfAvailable;
                if any(strcmp(obj.msg, obj.msgOptions))
                   break 
                end 
            end                
        
        end
        
        function obj = coloredScreen(obj, color)
            Screen('FillRect', obj.scr.windowPtr, color, obj.scr.dispRect);
            while true
                obj.scr.flipScreen; 
                obj.msg = obj.srv.readMessageIfAvailable;
                if any(strcmp(obj.msg, obj.msgOptions))
                   break 
                end    
            end
        end
        
        
        function obj = drawCenterText(obj, tstring)
            Screen('TextSize', obj.scr.windowPtr, 15);                
            Screen('FillRect', obj.scr.windowPtr, [0 0 0], obj.scr.dispRect);  
            DrawFormattedText(obj.scr.windowPtr, tstring,'center', 'center', [255 0 0])     ;       
        end        
        
        function obj = writenewmessage(obj)
            while true
                obj.drawCenterText('Waiting On Message from Cntrl');
                obj.scr.flipScreen;                
                obj.msg = obj.srv.readMessageIfAvailable;
                if ~isempty(obj.msg)
                    messageFromControl = obj.msg;
                    break;
                end    
            end 
            
            while true
                obj.drawCenterText(messageFromControl);
                obj.scr.flipScreen;
                obj.msg = obj.srv.readMessageIfAvailable;
                if any(strcmp(obj.msg, obj.msgOptions))
                   break; 
                end                  
            end            
            
        end
        
        
        function shutdown(obj)
            obj.scr.closeScreen
            obj.srv.closeServer 
            instrreset
            disp('Program Ended!!!')
        end        
    end
     
     
     

    
end


