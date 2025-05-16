function binnedTrialedSingleROI = splitInTrialsPos(signal, sData,idx)

for i = 1:numel(sData.trials.trialStart)-1
    isInTrial   = sData.trials.trialLength == i;
    trialSignal = signal(idx,isInTrial);
    
    for jj = 1:78
        idxInTrialBin                = sData.behavior.wheelPosDsBinned(isInTrial) == jj;
        binnedTrialedSingleROI(i,jj) = nanmean(trialSignal(idxInTrialBin));
    end
end

end