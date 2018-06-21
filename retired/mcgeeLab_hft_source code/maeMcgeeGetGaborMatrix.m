function Gbp  = maeMcgeeGetGaborMatrix(cpd)
%Generates an 2D Gabor image matrix. Spatial Hz is taken as input, but this
%is adjusted to ensure that there are an integer number of cycles on the
%screen (allowing for equaluminant gratings). Note that this function may
%take as input different cpd values and change them toward the same value
%but only if the input values are too close together. Also depends on the
%screen height and resolution and other stuff. Point is to make the input
%values different enough from eachother in your experiment so that this
%adjustment doesnt set them to be equal.

%   Detailed explanation goes here


scrnHeightCm    = 33.5;        % monitor heigth in cm
viewingDistInCm = 20 ;
V       = maeGetPixelSizeInDegrees(viewingDistInCm, scrnHeightCm);
lx      = V.screenSize_pix(1);
ly      = V.screenSize_pix(2);
D       = V.oneDeg_pix;                                     % a degree of visual angle in pixels
Lm       = 127.5;                                           % Mean luminance of gabors

adjCpd = round((ly/D)*cpd)/(ly/D); % adjusted spatial Hz

y       = 0:ly-1;
Yf      = @(x,f) sin(y*2*pi/f)' * ones(1,round(lx)) ;       % Sinewave Grating filling half the screen


% [X,Y]   = meshgrid(1:round(lx),y);
% Sg      = 20*D;                                             % Sigma of Gaussian in visual angle                   
% Gf      = @(x,y,cx,cy,s) exp( -((x-cx).^2 + (y-cy).^2)/(2*s^2) );
% Gbp     =  (Gf(X,Y,lx/2,ly/2,Sg) .* Yf(y,D/adjCpd) + 1) * Lm ; % for gabor 
Gbp     =  Yf(y,D/adjCpd) * Lm  + Lm; % for grating


end



%% Put your input values here and see if they are changing at every step. 
% z = I.sfIntValues; % values of gabor, in cpd. 
% plot(round((ly/D)*z)/(ly/D), ':.')