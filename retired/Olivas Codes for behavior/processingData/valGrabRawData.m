function D = valGrabRawData(subject,sess,subSess)
% Input example...;
% subject         = 'wd10';
% sess            = '003';
% subSess         = '000';

exp         = ['_', sess, '_', subSess];

pathExp     = 'H:\2pdata\';
pathSbjData = [pathExp, subject, '\'];
addpath(pathSbjData);
% cd(pathExp);

% Get Trial Stimulus Type, Lick Sounts
D.beh =  load([pathSbjData, subject, exp, '.txt']  );

% Get Stim TTLs
load([pathSbjData, subject, exp, '.mat'], 'info');
    D.ttl  = [info.frame, info.event_id];
    D.ttlMod = D.ttl;
    D.ttlMod(D.ttlMod(:,2) == 3, 2) = 2;

% Get signals
load([pathSbjData, subject, exp, '.signals'], 'sig', '-mat' );
    D.s = sig;

% Get Eye things    
load([pathSbjData, subject, exp, '_eye.mat'], 'eye'  );

    try 
        D.eye =  inpaint_nans([eye.Area],0);
   

    for i = 1:length(eye)
        D.cnt(i,:) = eye(i).Centroid;
    end
        D.cnt = inpaint_nans( D.cnt, 0); 

    catch
    
    
    end    
% Get Quad stuff
    load([pathSbjData, subject, exp, '_quadrature.mat'], 'quad_data' );
    D.q = quad_data;

clear info sig eye quad_data

end
