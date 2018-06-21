clc; clear;

mice    = valGetAllMice;
%%
nMice   = length(mice);

for i = 1:nMice
% Naive Eye
    %Hits
    naiveEye = mice(i).naive.H.eyeStimWnd;
    nTrials = size(naiveEye,1);
    nFrames = size(naiveEye,2);
    
    naiveMu  = mean(naiveEye);
    naiveErr = std(naiveEye)./sqrt(nTrials);
    
    subplot(2,nMice,i); hold on;
    shadedErrorBar(1:nFrames,naiveMu,naiveErr,'r',1)
    title(mice(i).name);
    ylabel('Hits')
    
    %Misses
    naiveEye = mice(i).naive.M.eyeStimWnd;
    nTrials = size(naiveEye,1);
    nFrames = size(naiveEye,2);

    naiveMu  = mean(naiveEye);
    naiveErr = std(naiveEye)./sqrt(nTrials);
    
    subplot(2,nMice,i+nMice); hold on;
    shadedErrorBar(1:nFrames,naiveMu,naiveErr,'r',1)
    title(mice(i).name);
    ylabel('Misses')    
    
% Expert Eye
    % Hits
    expertEye = mice(i).expert.H.eyeStimWnd;
    nTrials = size(expertEye,1);
    nFrames = size(expertEye,2);
    
    expertMu  = mean(expertEye);
    expertErr = std(expertEye)./sqrt(nTrials);
    if numel(expertErr)==1; expertErr = repmat(expertErr,1,nFrames) ; end
    subplot(2,nMice,i);
    shadedErrorBar(1:nFrames,expertMu,expertErr,'g',1)    
    
    % Misses
    expertEye = mice(i).expert.M.eyeStimWnd;
    nTrials = size(expertEye,1);
    nFrames = size(expertEye,2);
    
    expertMu  = mean(expertEye,1);
    expertErr = std(expertEye)./sqrt(nTrials);
    if  numel(expertErr)==1; expertErr = repmat(expertErr,1,nFrames) ; end
    
    subplot(2,nMice,i+nMice);
    shadedErrorBar(1:nFrames,expertMu,expertErr,'g',1)    
    ylabel('Misses')    
    
    
    
end

