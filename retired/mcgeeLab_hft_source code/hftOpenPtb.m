function windowPointer = hftOpenPtb( skipSyncTests )
%HFTOPENPTB Open Psych Tool Box and Screen

Screen('CloseAll'); 
AssertOpenGL;
Screen('Preference','SkipSyncTests',skipSyncTests);

% Open window, w/ gray background, in full screen. 
% If you change your screen setup, you need to adjust this accordingly
windowPointer = Screen('OpenWindow',2, [127 127 127], [-1920 0 0 1080]); 
end

