function roiStat = getStats(sData, CH)
%getRoiActivityStats Return struct of different roi activity statistics
%
%   roiStat = getRoiActivityStats(sData) Returns struct with statistics
%   about the roi signal for all rois in sData. 
%
%   roiStat = getRoiActivityStats(sData, CH) calculates the roiStat on the
%   specified channel number CH. CH is an integer. The default value is 2.
%
%   Output, roiStat contains the following fields:
%       peakDff         : Peak dff of the roi time series. 
%       signalToNoise   : Signal to noise 
%       activityLevel   : Fraction of time where activity is above noise
%   
    
% %     pstr = getFilePath(sData.sessionID, 'roiStat');
% %     if exist(pstr, 'file')
% %         roiStat = loaddata(sData.sessionID, 'roiStat');
% %         return
% %     end
    
    if nargin < 2
        CH = 2; % Most of us are imaging on ch2?
    end
    
    dff = double(squeeze(sData.imdata.roiSignals(CH).dff));
    [nRois, nSamples] = size(dff);
    

    % Get max DFF of all rois.
    peakDff = max(dff, [], 2);
    
    
    % Get SNR of all Rois.
    signalToNoise = zeros(nRois, 1);
    noiseLevel = zeros(nRois, 1);
    for i = 1:nRois
        noiseLevel(i) = real(GetSn(dff(i, :)));
        signalToNoise(i) = snr(dff(i, :), ones(1,nSamples) * noiseLevel(i));
    end
    
   signalToNoise = helper.calculateSNR(sData);

    % Get fraction of time above noise level
    %dffSmooth = okada(dff, 2); % Smooth with okada filter
    dffSmooth = smoothdata(dff, 2, 'movmean', 7); % Smooth again with movmean
    
    isHigh = dffSmooth > noiseLevel;
    
    activityLevel = sum(isHigh, 2) ./ nSamples;
    
    roiStat = struct('peakDff', peakDff, ...
                     'signalToNoise', signalToNoise, ....
                     'activityLevel', activityLevel);
    
%     savedata(sData.sessionID, struct('roiStat', roiStat))
    
end