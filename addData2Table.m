function newDataTable = addData2Table(dataTable, row2AppendData, nameDataPairs)

    if dataTable
        
        
    end

    varNames    = nameDataPairs(1:2:end);
    numVars     = numel(varNames);
    dataArray   = nameDataPairs(2:2:end);
    
    for i = 1:numVars
        clm2AppendData = strcmp(dataTable.Properties.VariableNames, varNames{i});
        dataTable{row2AppendData,clm2AppendData} = dataArray(i);
    end
    
    newDataTable = dataTable;

end