function S = hftCommunicate( comPort )

% Initialize Communication with Arduino 
delete(instrfindall); 

S.Ard = serial(comPort);
set(S.Ard,'DataBits',8);
set(S.Ard,'StopBits',1);
set(S.Ard,'BaudRate',115200);
set(S.Ard,'Parity','none');
set(S.Ard, 'terminator', 'LF');    % define the terminator for println
fopen(S.Ard);
S.Ard.ReadAsyncMode = 'continuous';
readasync(S.Ard);


pause(2); % Leave this here, otherwise itll try to sample immediately after communicating and just mess up 


end
