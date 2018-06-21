function mice = getOriPrefCaptain(split)
% Gets horizontal orientation preference changes
% Note: Ori Pref stats computed using baseline subtracted signals, NOT
% deltaF/F signals. Consider running this script using deltaF/f signals
% later.

% clear;

mice    = valGetAllMice;
nMice   = length(mice);
% split = 2; 

%%
clc;
OP = repmat(struct('id', [], 'naiveOpi', [],'expertOpi', []),1,nMice);
allOpNaive = [];
allOpExprt = [];

getMu   = @(m,n) abs( mean  ( cat(3,m,n), 3) );

close all; 
figScat = figure;
figLog2 = figure;
figAllMice = figure;

    
for i = 1:nMice    
    
    OP(i).id       = mice(i).name;
    
    % Get Naive Selectivity
    nvH = mice(i).naive.H.bsSig(30:end,:,:);
    nvM = mice(i).naive.M.bsSig(30:end,:,:);
    nvC = mice(i).naive.CR.bsSig(30:end,:,:) ;   
    nvF = mice(i).naive.FA.bsSig(30:end,:,:);
    
    % Get Expert Selectivity
    exH = mice(i).expert.H.bsSig(30:end,:,:);
    exM = mice(i).expert.M.bsSig(30:end,:,:);
    exC = mice(i).expert.CR.bsSig(30:end,:,:);   
    exF = mice(i).expert.FA.bsSig(30:end,:,:);
    
    
    sect    = 1:round( size(nvH,1)/split )-1:size(nvH,1);    
    for j = 1:length(sect)-1
        f = sect(j):sect(j)+min(diff(sect))-1;
        muNvH = getMu(nvH(f,:,:),nvM(f,:,:));    
        muNvV = getMu(nvC(f,:,:),nvF(f,:,:));          
        OP(i).naiveOpi = [OP(i).naiveOpi; mean( muNvH )./( mean(muNvV )+ mean(muNvH)) ]   ; 
        
        muExH = getMu(exH(f,:,:),exM(f,:,:));    
        muExV = getMu(exC(f,:,:),exF(f,:,:));
        OP(i).expertOpi  = [OP(i).expertOpi; mean( muExH )./( mean(muExV )+ mean(muExH))] ;
        OP(i).expertOpi
    end
       mice(i).naive.D.Op = OP(i).naiveOpi;
       mice(i).expert.D.Op = OP(i).expertOpi;
    
    
    for s = 1:split
        figure(figScat);
        subplot(split,nMice, i + (s-1)*nMice)  
        scatter(OP(i).naiveOpi(s,:), OP(i).expertOpi(s,:), 50, 'k'); hold on;
        
        [~, mn, sn] = zscore(OP(i).naiveOpi(s,:));
        [~, me, se] = zscore(OP(i).expertOpi(s,:));
        plot(mn, me, 'r.', 'markersize', 5)
        errorbarxy(mn, me, sn/sqrt(size(OP(i).expertOpi(s,:),2)), se/sqrt(size(OP(i).expertOpi(s,:),2)));
        
%         plot(mean(OP(i).naiveOpi(s,:)), mean(OP(i).expertOpi(s,:)), 'r+', 'markersize', 25)
        
        
        
        axis([0 1 0 1]);
        axis square;
        line(xlim, [0 1], 'color', 'r');
        
        if s == 1; title(mice(i).name); end
        if s == 4; xlabel('Naive Preference'); end
        if i == 1; ylabel( sprintf('%d Second\nExpert  Preference', s) ) ;   end
        xlabel('Naive Preference')
        
        figure(figLog2);
        subplot(split,nMice, i + (s-1)*nMice)  
        prefRatio = log2( OP(i).expertOpi(s,:)./OP(i).naiveOpi(s,:) );
        hist(prefRatio)
        xlim([-2 4]);
        axis square;

        if s == 1; title(mice(i).name); end
        if s == 4; xlabel('Log2 (Expert/Naive)'); end
        if i == 1; ylabel( sprintf('%d Second\nFrequency', s) ) ;   end        
    end
    
    xlabel('Log2(ExpPref/NaivePref)')
    
    allOpNaive = [allOpNaive, OP(i).naiveOpi];
    allOpExprt = [allOpExprt, OP(i).expertOpi];

end

%%
% figure(figAllMice)
for s = 1:split
    
    subplot(split,2, s)  
    scatter(allOpNaive(s,:), allOpExprt(s,:), 50, 'k'); hold on;
    plot(mean(allOpNaive(s,:)), mean(allOpExprt(s,:)), 'r+', 'markersize', 25)
    errorbarxy(mean(allOpNaive(s,:)), mean(allOpExprt(s,:)),...
                std(allOpNaive(s,:))/sqrt(size(allOpNaive(s,:),2)), std(allOpExprt(s,:))/sqrt(size(allOpNaive(s,:),2)));
        
        axis([0 1 0 1]);
        axis square;
        line(xlim, [0 1], 'color', 'r');    
    
    
end




end







