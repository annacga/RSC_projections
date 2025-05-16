function [SI, sig, pVal ,specificity]  = calculate_skaggs(occupancy_map_2D, activity_map_2D)
%% CALC_SPATIALINFORMATION 
% Calculates spatial information according to the method used by Skaggs et al (1993)
%
% INPUT
%   occupancy_map: A matrix where each row corresponds to a lap of
%       running and each column is a binned position on the wheel. Each
%       element contains the number of samples the animal was in the bin.
%   activity_map_2D: A matrix where each row corresponds to a lap of
%       running and each column is a binned position on the wheel. Each
%       element contains summed activity of a signal (fex deconvolved) 
%       when the animal was in the bin.
%
% OUTPUT
%   SI: The spatial information as bits. 
%   sig: Outputs result of a significance test. 1 if significant, 0 else.
%       For the SI to be significant, it has to be higher than the 95th
%       percentile of SI calculated for 1000 shuffled datasets.


%% Parameters
sig= []; pVal= [];
% bin_size = 1; %cm
n_bins = size(activity_map_2D,2); % The track number of bins

% Down project maps from 2D to 1D
occupancy_map_1D = sum(occupancy_map_2D,1);
% activity_map_1D = sum(activity_map_2D,1);

%% Calculate spatial information
% Create a position corrected activity map
% position_activity_map_1D = activity_map_1D./occupancy_map_1D;
mean_firing_of_bin_1D = nanmean(activity_map_2D);

% Smooth position activity map using a Gaussian window if deconv is used
% position_activity_map_1D = smoothdata(position_activity_map_1D,'gaussian',7); % position_activity_map_1D; %

% Create occupancy proability array
occupancy_probability = zeros(size(occupancy_map_1D));
for p = 1:length(occupancy_map_1D)
    occupancy_probability(p) = occupancy_map_1D(p)/nansum(occupancy_map_1D);
end

SI = NaN(n_bins,1);
for bin = 1:n_bins
    SI(bin) = occupancy_probability(bin) * (mean_firing_of_bin_1D(bin)/nanmean(mean_firing_of_bin_1D)) * ...
        log2(mean_firing_of_bin_1D(bin)/mean(mean_firing_of_bin_1D));
end


% Sum the spatial information across all bins to get the spatial
% information in bits 
if nansum(SI) < 0
    error('Summed SI is below zero');
end

SI = nansum(SI)./0.14;
% information rate divided by overall mean firing rate leads to information
% per spike/specificity 
specificity  = SI/mean(mean_firing_of_bin_1D);

%% Run significance test by shuffling data
% n_shuffles = 1000;
% n_laps = size(occupancy_map_2D,1);
% 
% % Initiate shuffled matrix
% shuffled_SI = [];
% 
% % Make n_shuffles different shuffles
% for i = 1:n_shuffles
%     colShifts = randi(n_bins, 1, n_laps);
%     activity_shuffled = zeros(n_laps,n_bins);
%     occup_shuffled = zeros(n_laps,n_bins);
%     
%     for l = 1:n_laps
%         activity_shuffled(l,:) = circshift(activity_map_2D(l,:),colShifts(l));
%         occup_shuffled(l,:) = circshift(occupancy_map_2D(l,:), colShifts(l));
%     end
% 
%     % Use shuffled activity to estimate new SI
%     % Downproject into 1D   
%     activity_shuffled = sum(activity_shuffled,1);
% 
%     occup_shuffled_map_1D = sum(occup_shuffled,1);
% 
%     % Create a position corrected activity map
%     position_activity_map_1D = activity_shuffled./occup_shuffled_map_1D;
% 
%     % Smooth position activity map using a Gaussian window with std 4.5 cm
%     % given a bin size of 1.5 cm
%     %position_activity_map_1D = smoothdata(position_activity_map_1D,'gaussian',3);
% 
%     SI_shuff = [];
%     for bin = 1:n_bins
%         SI_shuff(bin) = occupancy_probability(bin) * (position_activity_map_1D(bin)/mean(position_activity_map_1D)) * ...
%             log2(position_activity_map_1D(bin)/mean(position_activity_map_1D));
%     end
% 
%     % Sum the spatial information across all bins to get the spatial
%     % information in bits 
%     shuffled_SI(i) = nansum(SI_shuff);
%     
% end
% 
% pVal = length(find(shuffled_SI > SI))/1000;
% % Determine significance by using 95th percentile
% if SI > prctile(shuffled_SI,99)
%     sig = 1;
% else 
%     sig = 0;
% end

end