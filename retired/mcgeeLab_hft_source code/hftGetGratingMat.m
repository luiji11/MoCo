function Yf  = hftGetGratingMat(cpd)
% Generates an image matrix of a sine wave grating filling your screen.
% Supply the function with spatial hz of the grating (in cpd) that you
% desire. The spatial hz will be adjusted slightly to ensure that your
% screen contains an integer number of cycles, or put more simply, the same
% amount of "whitness" and "darkness" on the screen. This allows for
% all your displays to have the same mean luminance.

scrnHeightCm    = 33.5;         % This is your monitors heigth in cm, adjust it if you need to
viewingDistInCm = 20 ;          % this is the viewing distance, in cm, adjust it if you need to

V       = hftDeg2Pix(viewingDistInCm, scrnHeightCm);  
lx      = V.screenSize_pix(1);                                      % your screen is lx pixels wide
ly      = V.screenSize_pix(2);                                      % and ly pixels tall
D       = V.oneDeg_pix;                                             % this is one degree of visual angle, in pixels
Lm      = 127.5;                                                    % the mean luminance of gratings (in pixel values, e.g. 0-255)

adjCpd = round((ly/D)*cpd)/(ly/D);                                  % adjust the spatial Hz 

y       = 0:ly-1;
Yf      = Lm * (sin(y*2*pi*adjCpd/D)' * ones(1,round(lx)) + 1) ;  % your full field sinewave grating matrix

end


