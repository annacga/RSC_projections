function [isCue, cueData] = checkForCueTuning(sData, signal)
% Uses the signal (deconvolved) for a single cell and the sData struct
% and detemines wether the signal is cue tuned by first determiningthe place 
% fields are determined and
% Then for cells that have more than one place field the distance between place
% fields is compared to the distance of the cues on the wheel

% INPUT
%   signal: Array of deconvolved signal for one cell with the length of number time bins 

% OUTPUT
%   cueData: A struct containing all related cue field information 
%         .ifv: mean in-field value
%         .field_width: width of place field as number of bins
%         .field_peak_ind: index of peak of place field(s)
%         .field_start: first index of place field(s)
%         .field_end: last index of place field(s)
%         .n_peaks: number of peaks in position activity map
%         .inFieldIdxs: array containing all indices that are within any field of the position map
%         .outOfFieldIdxs: array containing all indices that are considered out of a field
%         .isCottonCell : boolean == 1 if the cell is a cotton cue cell
%         (otherwise == 0)
%         .isVelcroCell : boolean == 1 if the cell is a velcro cue cell (otherwise == 0)
%    isCue : 1 if signal is cue tuned otherwise 0


signalMatrix        = splitInTrials(signal, sData);
smoothedMatrix      = smoothdata(signalMatrix , 2,'gaussian',5);
meanSignal          = nanmean(smoothedMatrix, 1);
cueData.fieldInfo   = findPlaceFields(meanSignal,signalMatrix , sData);

% if axon has more than one peak calculate peak distance       
if cueData.fieldInfo.nPeaks >= 2 
    peak = zeros(cueData.fieldInfo.nPeaks,1); 
    for m = 1:cueData.fieldInfo.nPeaks
            peak(m) = cueData.fieldInfo.field_peak_ind(m);       
    end
    
    peakDiff = diff(sort(peak));
    
    % position of cues: 
    % cue1 =  [42 47 122 128]./2; 
    % cue2  = [63 68 100 106]./2;
    % distance of peaks to be counted as cue tuned:
    cottonDist = 16:22;  %  cue 2 : distance  19 +/- 3;
    velcroDist = 37:43;  %  cue 1 : distance 80 +/-3;
    
    isCue = 0;
    for m = 1:length(peakDiff)
        if ~isempty(find(cottonDist == peakDiff(m), 1))
            cueData.isCottonCell = 1;
            isCue = 1;
        end
        if ~isempty(find(velcroDist == peakDiff(m), 1))
            cueData.isVelcroCell = 1;
            isCue = 1;
        end
    end
else
    isCue = 0;
end

end