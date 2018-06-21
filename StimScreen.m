classdef StimScreen < handle
    %UNTITLED3 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        screenRect  = get(0,'screensize');                      % size of computer display screen
        pcID    = double(~isempty(strfind(cd, 'Luis')));    % 0 if luis's pc, 1 if in trachtenberg lab
%         pcID = 0;
        windowPtr;
        dispRect;
        dispCx;
        dispCy;
        lastFlipTime;
        status = 'closed';
        
        openMiniScreen
        flipCount = 0;
        minFlipInterval = 1/60 -.008;
    end
    
    methods 
        
        function obj = StimScreen(openMiniScreen)
            if nargin == 0
              obj.openMiniScreen = false;
            elseif nargin == 1
                obj.openMiniScreen = openMiniScreen; 
            else
               error('Too many arguments') 
            end
            obj.openWindow;
        end      
        
        function obj = openWindow(obj)
            sca;
            if obj.pcID
                rect = [2000 500 3000 1200] ;   
                rect = [obj.screenRect(3)-500 obj.screenRect(4)-500 obj.screenRect(3) obj.screenRect(4)];
                
            else
                rect = [obj.screenRect(3)-400 obj.screenRect(4)-400 obj.screenRect(3) obj.screenRect(4)];
                
            end
            [obj.windowPtr, obj.dispRect] = Screen('OpenWindow', obj.pcID, 127*[1 1 1], rect);

            obj.status = 'open';                        
            Screen('Preference', 'SkipSyncTests', 1);
            Screen('Preference', 'Verbosity', 0);  
            obj.dispCx = mean(obj.dispRect([1 3]));         % center x of display (not the screen), with respect to display
            obj.dispCy = mean(obj.dispRect([2 4]));         % center y of display (not the screen), with respect to display
            obj.lastFlipTime = Screen('Flip', obj.windowPtr);   % flips screen then returns time of flip        
            Screen('TextSize', obj.windowPtr, 12);
        
        end
        
        function obj = drawInfo(obj, currentBout, currentTrial, trialTimeElapsed)
            Screen('DrawText', obj.windowPtr,...
                    sprintf('Bout: %d | trial: %d (t: %.02f)',currentBout, currentTrial, trialTimeElapsed),...
                    1, 1, [255 0 0]);
        end
 

        function obj = drawColoredBackground(obj, color)
            Screen('FillRect', obj.windowPtr, color, obj.dispRect);
        end
        
        function obj = drawCentralDot(obj, radius)
            if nargin == 1
                r = 10;
            elseif nargin == 2
                r = radius; 
            end
            pos = [obj.dispCx-r obj.dispCy-r obj.dispCx+r obj.dispCy+r];
            Screen('FillOval', obj.windowPtr, [100 255 55], pos);
        end
        
        
        function obj = flipScreen(obj)
            obj.lastFlipTime    = Screen('Flip',obj.windowPtr, obj.minFlipInterval ); 
            obj.flipCount       = obj.flipCount + 1;            
        end
        
        function obj = closeScreen(obj)
            Screen('Close', obj.windowPtr); 
            obj.status = 'closed';                        
        end    
        
        
    end
               
    
end

