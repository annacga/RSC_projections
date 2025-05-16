
   
function [lickFrequencyDs ,lickFrequency]= extractLickFrequency(sData,samplingRate,lickLengthThr,lickFreqThr)

lickSignal          = sData.daqdata.lickSignal;
lickStartInd        = find(diff(lickSignal) == 1)+1;
lickEndInd          = find(diff(lickSignal) == -1);

% Correct for licks not fully captured at the beginning or end of the recording
if lickSignal(1) == 1
    lickEndInd = lickEndInd(2:numel(lickEndInd));
end
if lickSignal(numel(lickSignal)) == 1
    lickStartInd= lickStartInd(1:numel(lickStartInd)-1);
end

% convert length in sample points to length in ms
lickLength  = (lickEndInd - lickStartInd)/(samplingRate/1000); 

% convert to lick frequency
diffLickStart   = diff(lickStartInd);
lickFreq        = samplingRate./diffLickStart;

% remove too short lick events (and licks with too high frequency)
shortLickInd = lickStartInd(find(lickLength< lickLengthThr));
tooFastLickInd = lickStartInd(find(lickFreq > lickFreqThr));

lickErrorsInd = union(shortLickInd,tooFastLickInd);
lickStartInd  = setdiff(lickStartInd,lickErrorsInd);

lickEvents(1:numel(lickSignal)) = zeros;
lickEvents(lickStartInd) = 1;

lickFrequency        = helper.ifreq(lickEvents,samplingRate);
lickFrequencyDs      = lickFrequency(sData.daqdata.frameIndex(1):323:end);
     
   
% lickFrequencyDs =[];
end