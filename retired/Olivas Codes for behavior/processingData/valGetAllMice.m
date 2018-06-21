function mice = valGetAllMice
% Fuck it, hard code the experiment Ids here
% miceInfo        = { 'wd10', 'wd12', 'wd13', 'wd14', 'wd15','wd22', 'wd27', 'wd29', 'wd29', 'wd28','wd31','wd34','wd35';...  % Mouse Name
%                     '003',  '003',  '002',  '002',  '001', '003',  '002', '000', '000', '000', '000','000','000';...       % Naive session
%                     '000',  '000',  '000',  '000',  '000', '000',  '000', '001', '003', '000','000','001','002';...       % Naive subsession
%                     '005',  '005',  '006',  '007',  '007', '013',  '010', '007', '007', '005','004','008','009';...       % Expert session
%                     '000',  '001',  '001',  '002',  '000', '000',  '004', '003', '004', '001','002','002','002'};         % Expert subsession
 
miceInfo =  {'wd33', 'wd33', 'wd33', 'wd37';...
             '000',  '000', '000', '000';...      
             '001',  '002', '003', '001';...
             '005',  '005', '005', '006';...
             '000',  '001', '002', '001'};
%%

            
%% 
nMice = size(miceInfo,2);

for i = 1:nMice
    sbjName         = miceInfo{1,i};
    naiveSess       = miceInfo{2,i};
    naiveSubSess    = miceInfo{3,i};
    expertSess      = miceInfo{4,i};
    expertSubSess   = miceInfo{5,i};    
    r = sbxmatchfields([sbjName,'_', naiveSess,'_', naiveSubSess],...
                       [sbjName,'_', expertSess,'_', expertSubSess], .15); 
                   
    mice(i).name   = sbjName;
    mice(i).match  = r.match;    
    
    [   mice(i).naive.CR,...     
        mice(i).naive.FA,...
        mice(i).naive.M,...
        mice(i).naive.H,...
        mice(i).naive.D] = valGetBehavior(sbjName,naiveSess,naiveSubSess, mice(i).match(:,1));

,    [   mice(i).expert.CR,...     
        mice(i).expert.FA,...
        mice(i).expert.M,...
        mice(i).expert.H,...
        mice(i).expert.D] = valGetBehavior(sbjName,expertSess,expertSubSess, mice(i).match(:,2));
       
              
i
    
     
    
end













