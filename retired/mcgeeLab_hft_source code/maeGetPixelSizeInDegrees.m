function V = bmagetPixelSizeInDegrees(viewingDistInCm, sh_cm)
%%
% viewingDistInCm = 35;
% sh_cm = 33.7;        %mcGee lab monitor

sr_px = [1920 1080]; % Double check this
%*========================================
d = viewingDistInCm;                % viewingDistInCm = 35;
h = sh_cm;                          % sh_cm = 33.7;        %mcGee lab monitor
%*========================================

n = sr_px(2);

V.pixSize_deg           = 2*atand(h/2/d)/n; % 1 pixel is this many degrees
V.oneDeg_pix            = 1/V.pixSize_deg;  % 1 degree is this many pixels
V.viewDist_cm           = d;
V.screenSize_pix        = sr_px;
V.screenHeigth_cm       = sh_cm;



end






