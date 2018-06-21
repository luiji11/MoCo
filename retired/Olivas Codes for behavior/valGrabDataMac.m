function D = valGrabData(subject,sess,subSess)
% Input example...;
% subject         = 'wd10';
% sess            = '000';
% subSess         = '004';

exp         = ['_', sess, '_', subSess];

pathExp     = 'H:\2pdata\';
pathSbjData = [pathExp, subject, '\'];
addpath(pathSbjData);
cd(pathExp);

D.beh =  load([pathSbjData, subject, exp, '.txt']  );
    load([pathSbjData, subject, exp, '.mat'], 'info');
D.ttl  = [info.frame, info.event_id];
    load([pathSbjData, subject, exp, '.signals'], 'sig', '-mat' );
D.s = sig;
    load([pathSbjData, subject, exp, '_eye.mat'], 'eye'  );
D.eye =  [eye.Area];
    load([pathSbjData, subject, exp, '_quadrature.mat'], 'quad_data' );
D.q = quad_data;

clear info sig eye quad_data

end