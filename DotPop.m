classdef DotPop < handle
    %UNTITLED2 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (Constant)
        velocity    = 6;
    end
    
    properties
        color       = [0 0 0];
        directionsOptions = 0:15:345; 
        dotRadius      = 10;
        
        
        dots        = struct;        
        numDots           
        coherence   
        
        directionList
        
        maxX  
        maxY     
                
        signalDots_Ids
        noiseDots_Ids
        deadDot_Ids
        livingDot_Ids
        
        signalDots_direction = 0;
        lifeTime             = 10;
    end
    
    
    methods
        
        function [obj, scr] = DotPop   
            windowPtrs=Screen('Windows');
            if isempty(windowPtrs)
                scr = StimScreen;
                obj.maxX  = scr.dispRect(3);
                obj.maxY  = scr.dispRect(4);
            else
                [obj.maxX , obj.maxY]=Screen('WindowSize', windowPtrs(1));
                scr=[];
            end
            % cover 20% of display with dots
            % half of them are coherent
            screenArea = obj.maxX * obj.maxY; 
            dotArea = pi*obj.dotRadius^2 ;
            obj.numDots = round((.20*screenArea)/dotArea);
            obj.coherence  = round(.5*obj.numDots);   
                
            obj.dots = repmat( struct('posIdx', [], 'rect', [], 'direction', [], 'age', 0, 'pathY', [], 'pathX', []), obj.numDots, 1);
            setCoherence(obj, obj.coherence)   ;         
            assignDotTypeRandomly(obj);            
            createDotPaths(obj, 1:obj.numDots);                       
        end
  
        function obj = createDotPaths(obj, dotIds)
            maxNumSteps = round(sqrt(obj.maxX^2 + obj.maxY^2)/2);
            for i = dotIds
                d = obj.dots(i);                
                % generate a path on a random place on the screen 
                a  = randi(obj.maxX);
                b  = randi(obj.maxY);
                pathX = a + obj.velocity *(-maxNumSteps:maxNumSteps) * cosd(d.direction);                    
                pathY = b + obj.velocity *(-maxNumSteps:maxNumSteps) * sind(d.direction);
                               
                % Trim paths to fit within window
                outOfBounds = pathX > obj.maxX | pathX < 1 | pathY > obj.maxY | pathY < 1;
                pathX(outOfBounds) = [];
                pathY(outOfBounds) = [];                
                obj.dots(i).pathX = pathX;
                obj.dots(i).pathY = pathY;
                
                obj.dots(i).posIdx    = randi(numel(pathX)); 
            end
            
        end
        
       function obj = setCoherence(obj, coherence)
            if coherence > obj.numDots
                coherence = obj.numDots;
            elseif coherence < 1
                coherence = 1;
            end
            % change coherence, assign dots to be part of signal or noise at
            % random, then create dot paths again
            obj.coherence   = coherence;   
            obj = assignDotTypeRandomly(obj); 
            obj = createDotPaths(obj, 1:obj.numDots);            
       end        
        

         function obj = assignDotTypeRandomly(obj)
            dotIds                  = randperm(obj.numDots);
            obj.signalDots_Ids      = dotIds(1:obj.coherence);
            obj.noiseDots_Ids       = dotIds(obj.coherence+1:end);
            
            for i = 1:obj.numDots
                if any(i == obj.signalDots_Ids)
                    obj.dots(i).direction = obj.signalDots_direction;
                else
                    obj.dots(i).direction = obj.directionsOptions  ( randi(numel( obj.directionsOptions )) );
                end
            end
        end       
        
        function rectList = getDotRectList(obj)
            rectList = zeros(4, obj.numDots);
            for i = 1:obj.numDots
                d = obj.dots(i);
                idx = d.posIdx;
                rectList(:,i) =[d.pathX(idx)-obj.dotRadius;...
                                d.pathY(idx)-obj.dotRadius;...
                                d.pathX(idx)+obj.dotRadius;...
                                d.pathY(idx)+obj.dotRadius];             
            end

        end
            
        function obj = moveDots(obj)
            for i = 1:obj.numDots
                obj.dots(i).posIdx =   obj.dots(i).posIdx + 1;               
                if obj.dots(i).posIdx > numel(obj.dots(i).pathX)
                    obj.dots(i).posIdx = 1;
                end             
            end
        end

        function obj = setNewSignalDirection(obj, newDir)
            obj.signalDots_direction = newDir;        
            for i = obj.signalDots_Ids
                obj.dots(i).direction = newDir;
            end            
            obj.createDotPaths(obj.signalDots_Ids);       
        end
        
        function newDir = setNewSignalDirectionAtRandom(obj)
            sigDirOptions    = [0 180];
            newDir = sigDirOptions(randi(2));            
            obj.setNewSignalDirection(newDir)                        
        end
        
        function obj = incrementDotAge(obj, dotIds)
            for i = dotIds
                obj.dots(i).age = obj.dots(i).age + 1;                       
            end             
        end
        
        function obj = zeroDotAge(obj, dotIds)
            for i = dotIds
                obj.dots(i).age = 0;                       
            end           
        end
        
        function obj = check4DeadDots(obj) % check which dots exceeded their lifetime
            obj.deadDot_Ids = find( [obj.dots(:).age] >= obj.lifetime ); 
        end
        
        
    end
    
end
%%


function getWrapPoint(dot)
    dist2cx = dot.cx - obj.fieldCxCy(1); 
    dist2cy = dot.cy - obj.fieldCxCy(2);
    d2center = sqrt(dist2cx^2 + dist2cy^2);

    d.wrapPoints(1) 


end
function [sel, ptheta] = resultant(resp, f, thvals_inDeg)
    result          = sum(resp.*exp(1i*f*thvals_inDeg*pi/180));
    
    sel      = abs(result)/sum(abs(resp));
    
    ptheta    = rad2deg(angle(result)/f);
    ptheta(ptheta < 0) = ptheta(ptheta < 0) +  360/f;

end
    