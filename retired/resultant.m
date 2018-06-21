function [sel, ptheta] = resultant(resp, f, thvals_inDeg)
    result          = sum(resp.*exp(1i*f*thvals_inDeg*pi/180));
    
    sel      = abs(result)/sum(abs(resp));
    
    ptheta    = rad2deg(angle(result)/f);
    ptheta(ptheta < 0) = ptheta(ptheta < 0) +  360/f;

end

