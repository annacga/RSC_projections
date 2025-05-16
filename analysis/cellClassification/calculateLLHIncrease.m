function sumMat = calculateLLHIncrease(signal,stateMatrix,param)

    % calculate log-likelihood increase from  "mean firing rate model"
    lambdaModel       = exp(stateMatrix * param);
    n                 = signal;
    lambdaMean        = nanmean(signal);

    LLHModel          = exp(n.*log(lambdaModel) - lambdaModel - gammaln(n+1));
    log_LLHModel      = nansum(-log(LLHModel))/sum(n);

    LLHMean           = exp(n.*log(lambdaMean) - lambdaMean - gammaln(n+1));
    log_LLHMean       = nansum(-log(LLHMean))/sum(n);

    logLLH_Increase   = log(2)*(-log_LLHModel + log_LLHMean);

    sumMat            = [logLLH_Increase log_LLHModel log_LLHMean];
    

end

 
 
