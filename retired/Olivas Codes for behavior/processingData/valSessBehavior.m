% Beh Analysis, Split Sessions

clear;
clc;
mice = valGetAllMice
close all;
%%

cd ('C:\Users\Trach_McGee\Desktop\Nick_OrientationDisc\');
%clc; clear;

analysScriptDir = cd;
dataDir = [analysScriptDir, '\samplephase3data'];
addpath(dataDir);

animalFolders = dir(dataDir);
animalFolders = animalFolders(3:end);

nAnimals    = length(animalFolders);
nSessMax    = 12;   % make this bigger than the max sessions ran (accross ALL animals)
nTrials     = 200;
nStats      = 4;    % number of columns/statistical measurements in data file

data = cell(nAnimals,nSessMax);

for i = 1:nAnimals
    animalDataDir = [dataDir, '\', animalFolders(i).name];
    d = dir(animalDataDir);
    d = d(3:end);    
  
    nSess = length(d);
    for j = 1:nSess
        d(j).name
        c = textscan(fopen([animalDataDir, '\', d(j).name]), '%d %d %d %d %d', nTrials);
        data{i,j} = [c{1} c{2} c{3} c{4}];    
    end
    
end
%%
close all;
figure
SDT = repmat(struct('HIThz',[],'FAhz',[],'Dprime', [] ),1, nAnimals);
splitSess = 3;


for a = 1:nAnimals
    
    nSess = find(cellfun('isempty', data(a,:)),1)-1;
    Ht    = zeros(nSess,splitSess);
    Fa    = Ht;
    Dprime= Ht;
    
    for s = 1:nSess
        D = data{a,s};

        
        sect    = 1:round( length(D)/splitSess )-1:length(D); 
        
        for j = 1:length(sect)-1
            t = sect(j):sect(j)+min(diff(sect))  ;   
            Dsect = D(t,:);
            
            hTrls   = Dsect(:,1) == 0;      % Horizontal trials
            vTrls   = Dsect(:,1) == 1;      % Vertical trials            
            
            Ht(s,j) = mean( Dsect(hTrls,3) > 0 );        if Ht(s) == 1; Ht(s,j) = .99; end 
            Fa(s,j) = mean( Dsect(vTrls,3) > 0);          if Fa(s) == 0; Fa(s,j) = .02; end 
            
            Z_Ht = icdf('norm', Ht(s,j), 0, 1);
            Z_Fa = icdf('norm', Fa(s,j), 0, 1);
            Dprime(s,j) = Z_Ht - Z_Fa;
        end
        
    end
    
    %PLOT
    subplot(nAnimals,2,a*2-1);
    for s = 1:splitSess 
        plot(1:nSess, Ht(:,s), '-o'); hold on;
        plot(1:nSess, Fa(:,s), '-o'); hold on;
    end
    
        axis([0 nSessMax+1, 0 1]);
    ylabel(sprintf('Animal %.3d\n\nRate', a));
    if a == 1; 
        title('Hit Rate vs False Alarm Rate');
%         legend('Hit', 'False Alarm')
    elseif a == nAnimals;
        xlabel('Session')
    end      


    subplot(nAnimals,2,a*2);
    for s = 1:splitSess 
        plot(1:nSess,Dprime(:,s), '-o'); hold on;
        xlim([0 nSessMax+1]);
        ylabel('d''');
        ylim([min(Dprime(:)), 4.5])
    end
    
    legend(cellfun(@num2str, num2cell(1:splitSess), 'UniformOutput', false))
    
    if a == 1; 
        title('d''');
    elseif a == nAnimals;
        xlabel('Session')
    end              
        
end

%%

hits = 0:.01:1;
falm = hits;

Z_Ht = icdf('norm', hits, 0, 1);
Z_Fa = icdf('norm', falm, 0, 1);

Ht = [Z_Ht',-ones(length(Z_Ht),1)];
Fa = [ones(length(Z_Fa),1), Z_Fa'];

figure; 

subplot(1,2,1)
imagesc(Ht*Fa')
colormap jet
colorbar
axis equal;
xlabel('False Alarm Rate')
ylabel('Hit Rate')

subplot(1,2,2)
mesh(Ht*Fa')
xlabel('False Alarm Rate')
ylabel('Hit Rate')
zlabel('D Prime')
colormap jet
colorbar






