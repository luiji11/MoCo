function [CR, FA, M, H, D] = valGetBehavior(subject,sess,subSess, matchedCells)
% Input example...;
% subject         = 'wd12';
% sess            = '005';
% subSess         = '001';

D = valGrabRawData(subject,sess,subSess);
D.zs = zscore( D.s(:,matchedCells) ); % zscored and matched cells
D.sm = D.s(:,matchedCells);


CR  = valGetDprimeStats(D,'CR');
FA  = valGetDprimeStats(D,'FA');
M   = valGetDprimeStats(D,'MISS');
H   = valGetDprimeStats(D,'HIT');
