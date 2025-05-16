function covGrid = stateMatrix(covariat)%,limits,binNo,iscircular)
% changes covariate into categorical numbers and creates state matrix
% input:
% covariate: eg: position, speed, acceleration or lick rate
% binNo # states for covariate
% iscircular: boolean that declares wether covariate is circular (as
% position i
% cov(1).type     = 'position';
% cov(1).predictor          = sData.behavior.wheelPosDs; 
% cov(1).bins     = 40; 
% cov(1).beta     = 0.01; 
% cov(1).limits   = [0 157]; 
% cov(1).circular = 'true';

% create state  matrix
binSize = (covariat.limits(2)-covariat.limits(1))/covariat.bins;

covariatBinned = zeros(length(covariat.predictor),1);

if covariat.circular
    binGaps = binSize/2:binSize:covariat.limits(2)-binSize/2; 
else
    binGaps = covariat.limits(1):binSize:covariat.limits(2);
end

for t = 1:length(covariat.predictor)
    [~,ind]     = min(abs(binGaps-covariat.predictor(t)));
    covariatBinned (t)    = ind;
end

covGrid = zeros(length(covariatBinned),length(binGaps)+1);
for l = 1: length(covariatBinned)
    covGrid(l,covariatBinned(l)+1) = 1; 
end
covGrid(:,1) = 1;
    
end