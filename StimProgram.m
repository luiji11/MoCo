classdef StimProgram < handle
    %UNTITLED4 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        scr
        dts        
        srv
    end
    
    methods

        function obj = StimProgram
            obj.scr = StimScreen(true);
            obj.dts = DotPop('numdots',10,...
                             'coherence', 5,...
                             'maxwidth', obj.scr.dispRect(3),...
                             'maxheight', obj.scr.dispRect(4),...
                             'dotradius', 5);
            obj.srv = StimServer;  
            obj.StartProgram;
        end
        
        
        function StartProgram(obj)
            
            while 1
            msg = obj.srv.readMessageIfAvailable;
            fprintf('%s ', msg')                
                switch msg  
 
                        
                    case 'mocoprogram'
                        while true
                            Screen('FillOval', obj.scr.windowPtr, obj.dts.color, obj.dts.getDotRectList);
                            obj.scr.flipScreen;    
                            obj.dts.moveDots;
                            msg = obj.srv.readMessageIfAvailable;
                            
                            switch msg
                                case 'newdotpop'
                                obj.dts.createNewDotPop
                            end
                            
                        end                         
                    case 'grayscreen'
                        continueCurrentProgram = true;
                        while continueCurrentProgram
                            Screen('FillRect', obj.scr.windowPtr, color, obj.scr.dispRect);
                            obj.scr.flipScreen; 
                            msg = obj.srv.readMessageIfAvailable;
                            continueCurrentProgram = obj.executeCommand(msg);              
                        end
                    case 'whitescreen'
                        obj.plainColoredScreen([256 256 256]) 
                    case 'endProgram'
                        contCurrentProgram = false;
                    case 'finish'
                        obj.finish 
                end
            end
        end        
        

        
        function finish(obj)
            obj.scr.closeScreen
            obj.srv.closeServer           
        end        
    end
    
end



