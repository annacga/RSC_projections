function signalMatrix = splitInTrials(signal, sData)
% this script organises into a matrix in which each row corresponds to a
% trial and each column to a position on the track (2cm binning)

    signalMatrix = zeros(numel(sData.trials.trialStart)-1,floor(sData.stats.wheelCircum/2));
    for i = 1:numel(sData.trials.trialStart)-1
        isInTrial   = sData.trials.trialLength == i;
        trialSignal = signal(isInTrial);

        for jj = 1:floor(sData.stats.wheelCircum/2)
            idxInTrialBin                = sData.behavior.wheelPosDsBinned(isInTrial) == jj;
            signalMatrix(i,jj) = nanmean(trialSignal(idxInTrialBin));
        end
    end
end