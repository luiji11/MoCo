function maeFeedPorts(S, port)
%MPAFEEDPORTS Commands the Arduino to dispense a water reward to the the
%left or right port, or to both simultaneously.
%   if port is set to 1, then the left port fed
%   if port is set to 2, then the right port is fed
%   if port is set to 3, then both ports are fed 
fwrite(S.Ard,port); 
        
end

