function portLicked = mpaReadPorts(S)
%BMAREAD Returns the port that the animal is currently licking (or a human
%is currently touching).
%   if portLicked is 1, then the left port is being licked
%   if portLicked is 2, then the right port is being licked
%   if portLicked is 0, then neither port is being licked
%   if portLicked is 3, then both ports are being licked (this will never
%   be the case unless one is touching both port sensors simultaneously or
%   if the sensors are far too sensitive.

              fwrite(S.Ard, 'w');
portLicked =  fread(S.Ard,1,'uint8') ;


     
  
