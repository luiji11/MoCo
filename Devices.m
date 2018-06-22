classdef Devices < handle
    
    properties (Constant)
        isDebugging = true;
        
        onTrachPc   = contains(cd, 'Trach');
        onLuisPc    = contains(cd, 'Luis') && ispc;
        onLuisMac   = contains(cd, 'luis') && ismac;
        
        luisMacIp   = '192.168.0.6';
        luisPcIp    = '192.168.0.2';

        trachPcPort = 30000;              
        luisMacPort = 50001;
        luisPcPort  = 50000;      
        wheelPort   = 'COM15'; 
        arduinoPort = 'COM17'; 
              
        arduinoNameTag  = 'arduinoLickPort';
        wheelNameTag    = 'ArCOM'; % name tag comes from bpod library
               
    end
  
    

    

end

