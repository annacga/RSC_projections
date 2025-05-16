function results = compareModelPerformance(results, numFold,noCov)

testFit_mat = cell2mat(results.testFit);
LLH_values = reshape(testFit_mat(:,1:3:end),numFold,noCov);
         
% find all models that performe above baseline
aboveBaseline = [];
for i = 1:noCov
    pval_baseline = signrank(LLH_values(:,i),[],'tail','right');
    if pval_baseline <=   0.1
        aboveBaseline(end+1) = i;
    end
end
        
% check wether one model outperforms another if more than one model
% performe above baseline
sortOut = [];
if length(aboveBaseline) > 1
    for i = 1:length(aboveBaseline) 
         for j = 1:length(aboveBaseline) 
            [pval(i,j),~] = signrank(LLH_values(:,i),LLH_values(:,j),'tail','right');
            if  pval(i,j) <=   0.1 % model i is significanlty better than model j
                sortOut(end+1) = j;
            end
         end
    end
end

results.selectedModels = setdiff(aboveBaseline,sortOut);

if ~isempty(results.selectedModels)
    results.selectedModels = NaN;
end

% save p-values for all models
if (sum(isnan(LLH_values(:,1))) == 5); results.P_pval = 1; else
    results.P_pval = signrank(LLH_values(:,1),[],'tail','right'); end
if (sum(isnan(LLH_values(:,2))) == 5); results.S_pval = 1; else
    results.S_pval = signrank(LLH_values(:,2),[],'tail','right'); end
if (sum(isnan(LLH_values(:,3))) == 5); results.A_pval = 1; else
    results.A_pval = signrank(LLH_values(:,3),[],'tail','right');end
if (sum(isnan(LLH_values(:,4))) == 5); results.L_pval = 1; else
    results.L_pval = signrank(LLH_values(:,4),[],'tail','right');end


end