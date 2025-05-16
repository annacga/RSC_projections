close all

file = 'm5094-20200522-02';
filePath = '';
sData = load(fullfile(filePath,file,'/final_sData.mat'));

savePath = '';
if ~exist(savePath, 'dir'); mkdir(savePath); end


%% set variables
numFolds       = 5; % number of crossvalidation folds

% hyperparameters that were optimized beforehand:
tempBinSize    = 3;      % temporal bin sized
spatialbinSize = 5.233;  % so that we have 30 evenly sized spatial bins
beta           = 1;      % roughness penalty
speedThreshold = 1;

% initialise signal and position
deconvSignalTemp = sData.imdata.roiSignals(2).deconv;
pos              = sData.behavior.wheelPosDs;

% create time bins 
timeBins = 1:tempBinSize:length(pos);
for t = 1:length(timeBins)-1
    position(t)             = nanmean(pos(timeBins(t):timeBins(t+1)-1));
    signal(:,t)             = nanmean(deconvSignalTemp(:,timeBins(t):timeBins(t+1)-1),2);
    speed(t)                = nanmean(sData.behavior.runSpeedDs(timeBins(t):timeBins(t+1)-1));
end


% make sure all parameters have the same length
minLength   = min([length(position), size(signal,2), length(speed), length(sData.trials.trialLength)]);
position    = position(1:minLength);
signal      = signal(:,1:minLength);
speed       = speed(1:minLength);


binGaps     = spatialbinSize/2:spatialbinSize:max(position); 
bins        = 1:length(binGaps);
posBinned   = zeros(length(position),1);

for t = 1:length(position)
    [~,ind] = min(abs(binGaps-position(t)));
    posBinned(t) = ind;
end


% delete indices where animal is too slow
signal(:,(runSpeed < speedThreshold)) = [];
posBinned(runSpeed < speedThreshold)        = [];

% divide the data up into 5*num_folds pieces

sections = numFolds*5;
edges = round(linspace(1,size(signal,2)+1,sections+1));

d_data = [];

for k = 1:numFolds
    testIdx  = [edges(k):edges(k+1)-1 edges(k+numFolds):edges(k+numFolds+1)-1 ...
        edges(k+2*numFolds):edges(k+2*numFolds+1)-1 edges(k+3*numFolds):edges(k+3*numFolds+1)-1 ...
        edges(k+4*numFolds):edges(k+4*numFolds+1)-1];
    
    trainIdx = setdiff(1:size(signal,2),testIdx);
    
    d_data.iter{k}.trainSignal = signal(:,trainIdx);
    d_data.iter{k}.testSignal  = signal(:, testIdx);
    
    d_data.iter{k}.realPos_train = posBinned(trainIdx);
    d_data.iter{k}.realPos_test  = posBinned(testIdx);
    
    %% find cells without signal and delete
    d_data.iter{k}.cellIdx  = 1:size(signal,1);
    d_data.iter{k}          = findEmptyROIs(d_data.iter{k});
    
    %% calculate encoding models for
    d_data.iter{k}.lambda           = fitModelDec(d_data.iter{k}.trainSignal, posBinned(trainIdx),beta);
    
    % calculate likelihood: P(signal|position)
    likelihood_test    = likelihood(d_data.iter{k}.testSignal, d_data.iter{k}.lambda);
    likelihood_train   = likelihood(d_data.iter{k}.trainSignal, d_data.iter{k}.lambda);
    
    
    %% calculate posterior: P(position| signal) = P(signal|position)*P(position)
    % calculate prior P(position) --> flat prior, assume every position is equally likely
    % predicted position is the position with maximum likelihood
    prior        = ones(1,size(likelihood_train,2)).*1/size(likelihood_train,2);
    
    d_data.iter{k}.predPos_train = calcMaxLikelihoodPos(prior,likelihood_train, binGaps);
    d_data.iter{k}.predPos_test  = calcMaxLikelihoodPos(prior,likelihood_test, binGaps);

    d_data.rmse_test(k)   = calculateDecodingError(d_data.iter{k}.predPos_test, d_data.iter{k}.realPos_test);
    d_data.rmse_train(k)  = calculateDecodingError(d_data.iter{k}.predPos_train, d_data.iter{k}.realPos_train);
    
    
end

    % choose fold with median performance in test data:
d_data.medianRMSE_test  = nanmedian(d_data.rmse_test(:));
[~, k]                  = min(abs(d_data.rmse_test(:)-median(d_data.rmse_test(:))));
    
% save corresponding train rmse's
d_data.medianRMSE_train = d_data.rmse_train(k);

d_data.meanRMSE_test    = nanmean(rmse_test);
d_data.meanRMSE_train   = nanmean(rmse_train);

d_data.medianTestFold   = k;
d_data.lambda                = d_data.iter{k}.lambda;
    

save(fullfile(savePath, '/d_data.mat'), 'd_data','-v7.3');
