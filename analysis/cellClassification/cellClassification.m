
%% Clear the workspace and load the data

clear all; close all; clc
% load the data

file = 'm5082-20200313-02';
savePath =  fullfile('/Users/annachristinagarvert/Desktop/',file);
if ~exist(savePath, 'dir'); mkdir(savePath); end

sData = load(strcat('/Users/annachristinagarvert/Desktop/',file,'/final_sData.mat'));

%% hyperparameters (these were optimised before)
N_P = 40; beta{1} = 0.01; % position
N_S = 30; beta{2} = 0.01; speedLimits   = [0 60];% speed
N_A = 40; beta{3} = 0;    accLimits    = [-200 200];% acceleratioon
N_L = 20; beta{4} = 0;    lickLimits    = [0 10];% lick

% other variables
noCov = 4;
numFold = 5; % attention this is also hard coded in the function fit_model
samplingRate        = 10000;

lickLengthThreshold = 15;
lickFreqThreshold   = 15;
dt = 1/31;

% prepare Signal
signal      = double(sData.imdata.roiSignals(2).deconv);
numNeuron   = size(deconvSignal,1);

% prepare covariates
position             = sData.behavior.wheelPosDs;
speed                = sData.behavior.runSpeedDs;
acceleration         = diff(runSpeed)./dt;
lickRate             = extractLickFrequency(sData, samplingRate,lickLengthThreshold, lickFreqThreshold); 


% make sure covariates and signal have the same length
minLength           = min([length(position(2:end)),length(speed(2:end)),length(acceleration),length(lickRate(2:end)),size(signal(:,2:end),2)]);
signal              = signal(:,2:minLength);

position            = position(2:minLength);
speed               = speed(2:minLength);
acceleration        = acceleration(1:minLength);
lickRate            = lickRated(1:minLength);

% create state matrix :
covGrid{1}    = stateMatrixPosition(position, 0, max(position),N_P); % position
covGrid{2}    = stateMatrix(speed, speedLimits(1), speedLimits(2),N_S);
covGrid{3}    = stateMatrix(acceleration, accLimits(1), accLimits(2),N_A);
covGrid{4}    = stateMatrix(lickRate, lickLimits(1), lickLimits(2),N_L);
 
%  calculate LLH 
axon            = cell(numNeuron,1);  
selected_model  = cell(numNeuron,1);

for i = 1:numNeuron
    for j = 1:noCov
        [axon(i).testFit{j},axon(i).trainFit{j},axon(i).param{j}] = fit_model(covGrid{j},signal(i,:), beta{j});
    end
    
    axon(i).selected_model            = compareModelPerformance(axon(i), numFold,noCov);
    
    [isCue, axon(i).cueData] = checkForCueTuning(sData,signal(i,:));
    
    if isCue == 1;axon(i).selected_model  = 5; end
    
end
  
LNP.axon = axonPos; save(fullfile(savePath,'axon'),'-struct', 'LNP');

         



 