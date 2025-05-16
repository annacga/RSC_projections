function [testFit,trainFit,param_mean] = fitModel(stateMatrix,signal,beta)

% make signal and stateMatrix same size:
stateMatrix = stateMatrix(1:min([size(stateMatrix,1),size(signal,2)]),:);
signal = signal(1:min([size(stateMatrix,1),size(signal,2)]));

%% Initialize matrices and section the data for k-fold cross-validation
numFolds    = 5;
[~,numCol]  = size(stateMatrix);
sections    = numFolds*5;

% divide the data up into 5*num_folds pieces
edges       = round(linspace(1,numel(signal)+1,sections+1));

% initialize matrices
testFit     = nan(numFolds,3); % llh increase, log_llh_test, log_llh_rand_test
trainFit    = nan(numFolds,3); % llh increase, log_llh_train, log_llh_rand_train
paramMat    = nan(numFolds,numCol);

%% perform 5-fold cross validation
for k = 1:numFolds    
    
    %% prepare test and train data sets
    testInd  = [edges(k):edges(k+1)-1 edges(k+numFolds):edges(k+numFolds+1)-1 ...
        edges(k+2*numFolds):edges(k+2*numFolds+1)-1 edges(k+3*numFolds):edges(k+3*numFolds+1)-1 ...
        edges(k+4*numFolds):edges(k+4*numFolds+1)-1]   ;
    
    % test data
    testSignal          = signal(testInd)'; 
    testMatrix          = stateMatrix(testInd,:);
    
    % training data
    trainInd            = setdiff(1:numel(signal),testInd);
    trainSignal         = signal(trainInd)';
    trainMatrix         = stateMatrix(trainInd,:);
    
    %% fit the parameters
    opts = optimset('Gradobj','off','Hessian','off','Display','off');
    
    if k == 1
        init_param = 1e-3*randn(numCol, 1);
    else
        init_param = param;
    end
    
    init_param(isinf(init_param)) = 0; init_param(isnan(init_param)) = 0;        
    param = fminunc(@(param) lnPoissonModel(param,beta,trainMatrix,trainSignal),init_param,opts);

         
    % calculate log-likelihood increase from  "mean firing rate model"  
    testFit(k,:)        = calculateLLHIncrease(testSignal,testMatrix,param);
    trainFit(k,:)       = calculateLLHIncrease(trainSignal,trainMatrix,param);
    paramMat(k,:)       = param;

end

param_mean = nanmean(paramMat);

return
end