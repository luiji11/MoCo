classdef DRAWBOARD
    %UNTITLED5 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        rect  = []; % size of computer display screen;
        width = [];
        height =  [];        
    end
    
    methods
        function obj = DRAWBOARD(rect)
            if nargin == 0
                obj.rect = get(0,'screensize');  % size of computer display screen;

            elseif nargin == 1
                obj.rect = rect;
            end

                obj.width= obj.rect(3);
                obj.height= obj.rect(4);           
            end
        
        
    end
    
end

