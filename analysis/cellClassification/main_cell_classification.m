

%% Input structure (required)
%   signal       : array of deconvolved signal for neurons x length of number time bins 
%   covariate struct with fields:
%     {'type'             } % name of covariate
%     {'predictor'        } % variable of this covariate for each time bin
%     {'no bins'          } % categorical bins that will be created
%     {'beta'             } % this is the smoothing parameter
%     {'circular'           } % is the max bin equal to min?
%

%% Output structure
% results with fiels:
%     {'testFit'         } : log likelihood for test data: folds x covariate
%     {'trainFit'        } : log likelihood for train data: folds x covariate
%     {'params'          } : fitted model parameters : covariate x no bins
%     {'selected_model'  } : integer corresponding to cov struct


% llh increase, log_llh_test, log_llh_rand_test

% other variables
noCov = length(cov); % number of covariates tested
numFold = 5;         % attention this is also hard coded in the function fit_model

% prepare Signal
numNeuron   = size(signal,1);

% create state matrix :
for j = 1:noCov
    covGrid{j}    = stateMatrix(cov(j)); % position
end
 
%  calculate LLH 
results         = struct();  

for i = 1:numNeuron
    
    for j = 1:noCov
        [results(i).testFit{j},results(i).trainFit{j},results(i).param{j}] = fit_model(covGrid{j},signal(i,:), cov(j).beta);
    end
    
    results(i)                      = compareModelPerformance(results(i),numFold,noCov);
    [isCue, results(i).cueData]     = checkForCueTuning(sData,signal(i,:));
    
    % if is cue cell, the 
    if isCue == 1
        results(i).selected_model   = noCov+1; 
    end
    
    
end
  
         



 