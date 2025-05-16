
%% Clear the workspace and load the data

% clear all; close all; clc
% load sData with data

%% Input structure (required)
% signal       : No. neurons x No. Time points -matrix  
% make sure that the signal and all predictors have the same length!

signal      = double(sData.imdata.roiSignals(2).dff);

% position
cov(1).type     = 'position';
cov(1).predictor          = sData.behavior.wheelPosDs; 
cov(1).bins     = 40; 
cov(1).beta     = 0.01; 
cov(1).limits   = [0 157]; 
cov(1).circular = 'true';

% speed
cov(2).type     = 'speed';
cov(2).predictor          = sData.behavior.runSpeedDs;
cov(2).bins     = 30; 
cov(2).beta     = 0.01; 
cov(2).limits   = [0 60];    
cov(2).circular = 'false';

% acceleration
cov(1).type      = 'acceleration';
dt = 1/31; 
cov(3).predictor = diff(sData.behavior.runSpeedDs)./dt;        
cov(3).bins      = 40; 
cov(3).beta      = 0;    
cov(3).limits    = [-200 200];
cov(3).circular  = 'false';

% lick rate
cov(4).type      = 'lick_rate';
cov(4).lickLengthThreshold = 15; 
cov(4).lickFreqThreshold  = 15; 
cov(4).predictor          = extractLickFrequency(sData,  10000,cov(4).lickLengthThreshold, cov(4).lickFreqThreshold);  
cov(4).bins     = 20; 
cov(4).beta     = 0;    
cov(4).limits   = [0 10];    
cov(4).circular = 'false';


main_cell_classification

         



 