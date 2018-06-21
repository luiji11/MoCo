classdef DotPop < handle
    %UNTITLED2 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (Constant)
        velocity    = 6;
    end
    
    properties
        color       = [0 0 0];
        directionsOptions = 0:15:345; 
        dotRadius      = 12;
        
        
        dots        = struct;        
        numDots     = 100;        
        coherence   = 90;
        
        directionList
        
        maxCx = 1920;
        maxCy = 1080;
        fieldRadius   = 1000;
        fieldCxCy       = [1920/2 1080/2]; 
                
        signalDots_Ids
        noiseDots_Ids
        deadDot_Ids
        livingDot_Ids
        
        signalDots_direction = 0;
        lifeTime             = 10;
    end
    
    
    methods
        
        function obj = DotPop(varargin)            
            keyList = varargin(1:2:end);
            valList = varargin(2:2:end);
            
            for i = 1:numel(keyList)
                switch keyList{i}
                    case 'numdots'
                        obj.numDots  = valList{i};  
                    case 'dotradius'
                        obj.dotRadius = valList{i};
                    case 'coherence'
                        obj.coherence= valList{i};
                    case 'maxwidth'
                         obj.maxCx  = valList{i};
                    case 'maxheight'
                         obj.maxCy  = valList{i};
                    case 'fieldRadius'
                         obj.fieldRadius = valList{i};
                    case 'fieldCxCy'
                         obj.fieldCxCy = valList{i};                         
                    case 'lifetime'
                        obj.lifeTime = valList{i};
                    otherwise
                        error('Unkown argument')
                end
            end
            
            obj.dots = repmat( struct('posIdx', [], 'rect', [], 'direction', [], 'age', 0, 'pathY', [], 'pathX', []), obj.numDots, 1);
            obj = setCoherence(obj, obj.coherence)   ;         
            obj = assignDotTypeRandomly(obj);            
            obj = createDotPaths(obj, 1:obj.numDots);                       
        end
  
        function obj = createDotPaths(obj, dotIds)
            maxNumSteps = round(sqrt(obj.maxCx^2 + obj.maxCy^2)/2);
            for i = dotIds
                d = obj.dots(i);                
                % generate a path on a random place on the screen 
                a  = randi(obj.maxCx);
                b  = randi(obj.maxCy);
                pathX = a + obj.velocity *(-maxNumSteps:maxNumSteps) * cosd(d.direction);                    
                pathY = b + obj.velocity *(-maxNumSteps:maxNumSteps) * sind(d.direction);
                               
                % Trim paths to fit within window
                outOfBounds = pathX > obj.maxCx | pathX < 1 | pathY > obj.maxCy | pathY < 1;
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

        function obj = createNewDotPop(obj)
            sigDirOptions    = [0 180];
            obj.signalDots_direction = sigDirOptions(randi(2)); 
            obj.assignDotTypeRandomly;
            obj.createDotPaths(1:obj.numDots);        
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
    