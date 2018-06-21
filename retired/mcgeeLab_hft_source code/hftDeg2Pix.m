function V = maeGetPixelSizeInDegrees(viewingDistInCm, sh_cm)
%%

sr_px = [1920 1080];  % Double check this
%*========================================
d = viewingDistInCm;                
h = sh_cm;                          
%*========================================

n = sr_px(2);

V.pixSize_deg           = 2*atand(h/2/d)/n; % 1 pixel is this many degrees
V.oneDeg_pix            = 1/V.pixSize_deg;  % 1 degree is this many pixels
V.viewDist_cm           = d;
V.screenSize_pix        = sr_px;
V.screenHeigth_cm       = sh_cm;



end






