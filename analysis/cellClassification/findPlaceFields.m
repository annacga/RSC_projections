function pfData = findPlaceFields(avgActivity,signalMatrix,sData)
% FINDPLACEFIELDS 
% Uses the averaged position activity map (avgActivity) to extract information about 
% potential place fields within the map. 
% The function takes in an array of length corresponding to the number of
% bins on the wheel (ex 105), where each data point is the summed and
% position occupancy corrected average activity for all laps. A gaussian
% smoothing should also have been applied (like Mao et al (2017) does).
% The signal matrix activity in position bins x trials is further used to
% check if the place field fulfill the following criteria:
% --1 Criteria: the activityRatio of in field activity vs out of field activity is 
%               above 3 (ActivityRatioCriteria = 3) % This is the ratio used by Mao et al (2017)
% --2 Criteria: The percentage of laps where the activity peak is within the 
%                place field is above 20 %
% --3 Criteria: peaks must be above 50 cm and below 140 cm on the wheel so that 
%               cells close to reward are not considered as cue tuned

%
% INPUT
%   avgActivity: Array with the length of number of bins on the wheel,
%       where each sample is the average activity for all laps. 
%       A Gaussian smoothing should also have
%       been applied to this map (like Mao et al (2017) does).
%   
%  signalMatrix : Matrix with the no of columns corresponding to no of bins on the wheel
%       and no of rows corresponds to no of trials.
%       Each sample is the avearge actavity activity for all laps for
%       position/ trial bin
%
% OUTPUT
%   pfData: A struct containing all related place field information:
%         .ifv: mean in-field value
%         .field_width: width of place field as number of bins
%         .field_peak_ind: index of peak of place field(s)
%         .field_start: first index of place field(s)
%         .field_end: last index of place field(s)
%         .n_peaks: number of peaks in position activity map
%         .inFieldIdxs: array containing all indices that are within any field of the position map
%         .outOfFieldIdxs: array containing all indices that are considered out of a field
%
% this function was written by Andreas Lande and adapted to cue field
% identification by Ann Christin Garvert

% Set parameters
% Get initial place field threshold
% Threshold is set as 30% of the difference between the highest and lowest activity of the position activity map.
threshold = min(avgActivity)+(0.3*(max(avgActivity)-min(avgActivity))); 
n_bins = 78;
bin_size = sData.behavior.meta.binSize;

minPeakDist = round(10/bin_size); % Distance needed for two peaks to be considered as individual
minPeakWidth = 1; 
maxPeakWidth = 78;
activityRatioCriteria = 3;

% Check that min peak is not too small

% Use the MATLAB Signal Processing Toolbox function findpeaks() to localize peaks within the position activity map
[~,locs] = findpeaks(avgActivity,'MinPeakDistance',minPeakDist,'MinPeakHeight',threshold,'WidthReference','halfheight','MinPeakWidth',minPeakWidth,'MaxPeakWidth',maxPeakWidth);

% Struct for output
pfData = struct();

% If no peaks are found, skip, else run analysis
if ~isempty(length(locs) == 0)
    
    % For each peak detected
    for peak = 1:length(locs)
        peakIndx = locs(peak);
        
        % Find all neighbouring values that are above the threshold to obtain
        % place field width
        pfStart = peakIndx; % start index of place field
        pfEnd = peakIndx; % end index of place field
        
        % Go from peak index backwards to locate beginning of place field
        look = 1;
        curr_pos = peakIndx;
        while look
            curr_pos = curr_pos - 1;
            if curr_pos < 1
                curr_pos = n_bins;
            end
            
            if avgActivity(curr_pos) > threshold
                pfStart = curr_pos;
            else
                look = 0;
            end
        end
        
        % Go forward from peak to find end index of place field
        look = 1;
        curr_pos = peakIndx;
        while look
            curr_pos = curr_pos + 1;
            if curr_pos > n_bins
                curr_pos = 1;
            end
            
            if avgActivity(curr_pos) > threshold
                pfEnd = curr_pos;
            else
                look = 0;
            end
        end
        
        % Get all in-field and out-of-field indices
        inFieldIdxs = [];
        outOfFieldIdxs = [];
        if pfEnd < pfStart
            inFieldIdxs =  [inFieldIdxs, 1:pfEnd];
            inFieldIdxs = [inFieldIdxs, pfStart:length(avgActivity)];
            outOfFieldIdxs = [pfEnd+1:pfStart-1];
        else
            inFieldIdxs = [inFieldIdxs, pfStart:pfEnd];
            outOfFieldIdxs = [1:pfStart-1,pfEnd+1:length(avgActivity)];
        end
        
        inFieldValue = nanmean(avgActivity(inFieldIdxs));
%         out_of_field_value = nanmean(pos_activity_map(outOfFieldIdxs));
        
        % Save place field information
        pfData.inFieldValue(peak)   = inFieldValue;
        pfData.fieldWidth(peak)     = length(inFieldIdxs);
        pfData.fieldPeakIdx(peak)   = locs(peak);
        pfData.fieldStart{peak}     = pfStart;
        pfData.fieldEnd{peak}       = pfEnd;
        pfData.nPeaks               = length(locs);
        pfData.inFieldIdxs{peak}    = inFieldIdxs;
        pfData.outOfFieldIdxs{peak} = outOfFieldIdxs;
        
        
    end
    
    % For each field, obtain out-of-field/in-field ratio
    totalOutOfFieldIdx            = 1:n_bins; % Start with the assumption that all bins are out of field
    totalInFieldIdxs              = [pfData.inFieldIdxs{:}];
    pfData.totalInFieldIdxs       = totalInFieldIdxs;
    totalOutOfFieldIdx            = totalOutOfFieldIdx(~ismember(totalOutOfFieldIdx,totalInFieldIdxs));
    pfData.totalOutOfFieldIdx     = totalOutOfFieldIdx;
    pfData.outOfFieldValue(peak) = mean(avgActivity(pfData.totalOutOfFieldIdx));
    pfData.inFieldValue(peak)    = mean(avgActivity(pfData.totalInFieldIdxs));
    pfData.activityRatioInVsOut(peak) = pfData.inFieldValue(peak)/pfData.outOfFieldValue(peak);

     
    % calculate for each trials in which activity peak is within the place field
    pfData.isAboveThresholdTrial(peak) = 0;
    for lap = 1:numel(sData.trials.trialStart)-1
        pfData.inFieldValue_trial(peak,lap) = mean(signalMatrix(lap,pfData.inFieldIdxs{peak}));
        pfData.outOfFieldValue_trial(peak,lap) = mean(signalMatrix(lap,pfData.totalOutOfFieldIdx));
        
        if pfData.inFieldValue_trial(peak,lap)/pfData.outOfFieldValue_trial(peak,lap) > activityRatioCriteria 
            pfData.isAboveThresholdTrial(peak) = pfData.isAboveThresholdTrial(peak) +1;
        end
    end
        
    % correct for fields with multiple peaks
    [startVals, startIdx, startValsOcc]= unique([pfData.fieldStart{:}]);
    deleteIdx = [];
    if length(startVals) < length([pfData.fieldStart{:}])
        for i = 1:length(startIdx)
            noPeak = find(startValsOcc == startIdx(i));
            if length(noPeak) > 1
                deleteIdx = [deleteIdx; noPeak(2:end)];

                [~,maxPeakIdx] = max(avgActivity(noPeak));
                
                keepIdx = pfData.fieldPeakIdx(noPeak(maxPeakIdx));
                pfData.fieldPeakIdx(noPeak(1)) = keepIdx;
                
                
                pfData.nPeaks = pfData.nPeaks-(length(noPeak)-1);
            end
        end
        
        pfData.inFieldValue(deleteIdx) = [];
        pfData.fieldWidth(deleteIdx) = [];
        pfData.fieldStart(deleteIdx) = [];
        pfData.fieldEnd(deleteIdx) = [];
        pfData.inFieldIdxs(deleteIdx) = [];
        pfData.outOfFieldIdxs(deleteIdx) = [];
        pfData.fieldPeakIdx(deleteIdx) = [];
        
    end

    
    % Based on the activity ratio measure obtained above peaks must fulfill the
    % following:
    % --1 Criteria: the activityRatio of in field activity vs out of field activity is above 3 (ActivityRatioCriteria = 3) % This is the ratio used by Mao et al (2017)
    % --2 Criteria: The percentage of laps where the activity peak is within the place field is above 30 %
    % --3 Criteria: peaks must be above 50 cm and below 140 cm on the wheel so that cells close to reward are not considered as cue tuned
    
    for peak = 1:pfData.nPeaks
        pfData.isActive(peak) = 1;
        %  --1 Criteria:
        if pfData.activityRatioInVsOut(peak) <  activityRatioCriteria
            pfData.isActive(peak) = 0; end
        
        %  --2 Criteria:
        if pfData.isAboveThresholdTrial(peak)/(numel(sData.trials.trialStart)-1) < 0.2
            pfData.isActive(peak) = 0;
        end
        
        % --3 Criteria
        if pfData.fieldPeakIdx(peak) < 25 || pfData.fieldPeakIdx(peak) > 70
            pfData.isActive(peak) = 0;
        end
        
        
        if pfData.isActive(peak) == 0
            
            pfData.inFieldValue(peak)= [];
            pfData.fieldWidth(peak) = [];
            pfData.fieldStart(peak) = [];
            pfData.fieldEnd(peak) = [];
            pfData.inFieldIdxs(peak) = [];
            pfData.outOfFieldIdxs(peak) = [];
            pfData.fieldPeakIdx(peak) = [];
            pfData.isAboveThresholdTrial(peak)= [];
            
            pfData.nPeaks = pfData.nPeaks-1;
            pfData.isActive(peak) = [];
        end
        
    end
    
end