function mpaTrigStim(S, command) 
% MPATRIGSTIM
% Commands:
% 'fbg', 2 gabors of the same SF are presented on each side of screen. 
%
% 'old', presents a white disk, flashing on and off (e.g. occilating) on
% the LEFT side of the screen. I need to change these names fuckkkkk
%
% 'ord' presents a white disk, flashing on and off (e.g. occilating) on
% the RIGHT side of the screen
%
% 'x' stops the presentation of the flashing disks
%


fwrite(S.Vis, command);     


    