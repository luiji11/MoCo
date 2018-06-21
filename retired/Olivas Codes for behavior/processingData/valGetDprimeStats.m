function R = valGetDprimeStats(D,responseOutcome)

switch responseOutcome
    case 'CR'
        R.trial    = find(D.beh(:,1)==1 & D.beh(:,3)== 0);
    case 'FA'
        R.trial    = find(D.beh(:,1)==1 & D.beh(:,3)> 0);
    case 'MISS'
        R.trial    = find(D.beh(:,1)==0 & D.beh(:,3)== 0);
    case 'HIT'
        R.trial    = find(D.beh(:,1)==0 & D.beh(:,3)>0);
end
stmTtls = D.ttlMod(D.ttlMod(:,2) == 2,:);

if stmTtls(1) == 0; stmTtls(1,:) = []; end; % for wd12 (error in ttl) 

sOn     = stmTtls(1:2:end,1);

preView     = 30; %30 is orignal
postView    = 100;
stimLength  = 60; 
nCells      = size(D.zs,2);

R.frame         = sOn(R.trial);
R.lick          = D.beh(R.trial,2:3);
R.zSig          = zeros(preView+postView+1,nCells,length(R.frame));
R.bsSig         = R.zSig;
R.df            = R.bsSig;

R.eyeAll        = zeros(length(R.frame),preView+postView+1);
R.eyeStimWnd    = zeros(length(R.frame),stimLength+1);
R.quad          = R.eyeAll;

for i = 1:length(R.frame)
    allFrames       = R.frame(i)-preView:R.frame(i)+postView;
    stimFrames      = R.frame(i):R.frame(i)+stimLength;
    
    % Get Baseline Signals for each trial 
    blFrames        = R.frame(i)-preView:R.frame(i);
    blMean          = mean( D.zs(blFrames,:));
    blMeanRaw       = mean( D.sm(blFrames,:));
    
    % Get Response Signals for each trial
    R.zSig(:,:,i)   = D.zs( allFrames, :);
    rawSig          = D.sm(allFrames,:);
    % Get some Normalized signal
    R.bsSig(:,:,i)  = bsxfun(@minus, R.zSig(:,:,i), blMean); % zscored, response-mean(baseline)
    
    rawMinBaseSig   = bsxfun(@minus, rawSig, blMeanRaw); 
    R.df(:,:,i)     = bsxfun(@rdivide, rawMinBaseSig, blMeanRaw); % raw, response-mean(baseline)/mean(baseline)
    
    % Other Data
    try
    R.eyeAll(i,:)   = D.eye( allFrames );
    R.eyeStimWnd(i,:) = D.eye( stimFrames );
    R.cnt(i,:)      = D.cnt( allFrames );    
    R.quad(i,:)     = D.q(allFrames );
    
    catch
        
    end    
    
    %%
%         bsxfun(@minus, R.zSig(:,:,i), blMean)./blMean

    
    
end