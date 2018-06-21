function PER = readExcellPeriodTable
[~,~,PER]=xlsread('plPeriodInitialize.xlsx', 'Sheet1', 'A1:F7'  );
PER = PER(2:end,:);

end