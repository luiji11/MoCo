function maePlotPSF(I,F)

nT = find( I.perf(:,1) == 0, 1)-1;

ansCrct = I.perf(1:nT,2);
ansSbjt = I.perf(1:nT,3);
grades  = ansCrct == ansSbjt;

v = unique(I.sVal(1:nT));

psf = zeros(1,length(v));
k = 0;
for i = unique(I.sVal(1:nT))'
   k = k +1; 
   psf(k) = mean(grades( I.sVal(1:nT) == i ));
end

F.psf.XData = v;
F.psf.YData = psf;