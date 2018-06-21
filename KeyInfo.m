classdef KeyInfo 
    
    properties (Constant)
        isDebugging = true;
        
        onTrachPc   = logical(~isempty(strfind(cd, 'Trach')) );
        trachPcPort = 30000;
        
        onLuisPc    = logical(~isempty(strfind(cd, 'Luis')) ) && ispc;
        onLuisMac   = logical(~isempty(strfind(cd, 'Luis')) ) && ismac;
        luisMacIp   = '192.168.0.6';
        luisMacPort = 50001;
        luisPcIp    = '192.168.0.2';
        luisPcPort  = 50000;
        
    end
    
end

