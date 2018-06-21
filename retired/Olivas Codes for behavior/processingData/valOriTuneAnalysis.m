%% Gets orientation preferences AND tuning profiles 


cd('C:\Users\Trach_McGee\Dropbox (TrachtenbergLab)\TrachtenbergLab Team Folder\Nick\Codes for behavior\processingData\')
clear; clc;
split = 2;
mice = getOriPref(1);
nms = cell(length(mice),1);
for i = 1:length(mice)
    nms{i} = mice(i).name   ;
    
end


%%
clc

clear M
%**************************************************
% Add more animals here
sbjNames        = {'wd12', 'wd13', 'wd15', 'wd22'}; % animal Id goes here
fnNaiveList     = {'wd12_000_004', 'wd13_000_001', 'wd15_000_002', 'wd22_002_000'}; % its 'naive' filename here
fnExpertList    = {'wd12_005_002', 'wd13_007_002', 'wd15_007_002', 'wd22_010_002'}; % its 'expert' filename here
%**************************************************
nMice = length(sbjNames);

M = repmat ( struct('id', [], 'stage', [], 'sig', [], 'cells', [], 'run', [], 'eye', [] , 'tune', [],...
        'thetaVals', [],  'os', []), 2, nMice);
i = 1;
jN = 1;
jE = 2;



%%
close all;
for i = 1:length(sbjNames)
    
fnNv            = fnNaiveList{i};
M(i,1).id       = sbjNames{i};
M(i,1).stage    = 'Naive';

fnEx            = fnExpertList{i};
M(i,2).id       = sbjNames{i};
M(i,2).stage    = 'Expert';

% Load Data
    % Match
        r = sbxmatchfields(fnNv,fnEx,.25);
        close(gcf)
        M(i,1).cells = r.match(:,1);
        M(i,2).cells = r.match(:,2);
    % Get Ca+ Signals
        load([fnNv, '.signals' ], '-mat'); M(i,1).sig = sig(:,r.match(:,1) ); % Naive
        load([fnEx, '.signals' ], '-mat'); M(i,2).sig = sig(:,r.match(:,2) ); % Expert
    % Get Eye Signal
        load([fnNv, '_eye.mat' ], '-mat'); M(i,1).eye = [eye.Area];     % Naive
        load([fnEx, '_eye.mat' ], '-mat'); M(i,2).eye = [eye.Area];     % Expert
    % Get Quad
        load([fnNv, '_quadrature.mat' ], '-mat'); M(i,1).run = quad_data;     % Naive
        load([fnEx, '_quadrature.mat' ], '-mat'); M(i,2).run = quad_data;     % Expert    
        
% Extract Tuning Curves
        [M(i,1).tune, M(i,1).thetaVals, M(i,1).os]  = getOriTuning(fnNv, M(i,1).sig );
        [M(i,2).tune, M(i,2).thetaVals, M(i,2).os]  = getOriTuning(fnEx, M(i,2).sig );
    
% Plot
    nCells = length(M(i,1).cells );
    figure('name', M(i,1).id);
    for j = 1:nCells
        subplot(ceil(sqrt(nCells)), ceil(sqrt(nCells)), j)
        z = [M(i,1).tune(:,j), M(i,2).tune(:,j)];


        plot(M(i,1).thetaVals, z(:,1), 'b-o'); hold on;
        plot(M(i,2).thetaVals, z(:,2),'r-o'); axis tight
        axis([M(i,1).thetaVals(1), M(i,1).thetaVals(end), 0 1])
        title( sprintf('%.3f | %.3f',M(i,1).os(j), M(i,2).os(j) ) ) 
        axis tight;
        if sum([M(i,1).os(j), M(i,2).os(j)] >.1) >=1
            set(gca, 'Color', [.7 .8 .6])
            
            
        end
%         plot(thetaVals, M(i,1).tune(:,j), '-o'); hold on;
%         plot(thetaVals, M(i,2).tune(:,j)),'o-'; axis tight
%          plot( M(i,1).tune(:,j) .*exp(1i*2*pi*thetaVals/360)','-o');

%          polar(thetaVals*pi/180, z(:,1)', '-bo'); hold on
% %          polar(thetaVals*pi/180, z(:,2)', '-ro'); 
%          axis tight
%          axis off
%         axis([-4 4 -4 4])
    end
    
    
    
    tuningFileIdx = ismember(nms,sbjNames{i});
    if any(tuningFileIdx)
        mice(tuningFileIdx).naive.OT = M(i,1);
        mice(tuningFileIdx).expert.OT = M(i,2);
        
    end
    
    
    
    
    


end