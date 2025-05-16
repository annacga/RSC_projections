
area    = 2; % M2
session = 3;
roi     = 243;
% isPlaceCell =  mData(area,session).LNP_results(roi); check model performance
 
signal =normalize(mData(area,session).sData.imdata.roiSignals(2).dff(roi,:),'range',[0,1]);      
binnedMatrix = plot.createHeatMap(mData(area,session).sData.trials.trialLength,mData(area,session).sData.behavior.wheelPosDsBinned,signal);

fig_1_m = figure();
imagesc(binnedMatrix)
set(gca, 'FontName', 'Arial', 'FontSize', 12)
xticks(gca,[1 20 40 60 78]);
xticklabels(gca,{'0', '40','80','120','158'});
colormap(jet)
ylabel('Trials');
xlabel('Position (cm)');
colormap(jet);
xlim([1 78])
title('Normalized DFF')
colorbar()




function matrix = createHeatMap(lapVector,position,behavior)

heatmap = zeros(max(lapVector)+1,ceil(max(position))+1);
occupancymap = zeros(max(lapVector)+1,ceil(max(position))+1);
offset = min(lapVector);
for x = 1:length(position)
    x_pos = round(position(x));
    y_pos = lapVector(x)+1+(-offset);
    heatmap(y_pos,x_pos+1) = heatmap(y_pos,x_pos+1) + behavior(x);
    occupancymap(y_pos,x_pos+1) = occupancymap(y_pos,x_pos+1) + 1;
end

matrix = heatmap./occupancymap;


% sometimes, the positions are not evenly sampled and some values in
% the matrix remain not assigned (here i fill in these with
% neighbourign values)
% matrix = matrix';
% while ~isempty(find(isnan(matrix)))
%     matrix(isnan(matrix)) = matrix(find(isnan(matrix))-1);
% end
% matrix = matrix';


end