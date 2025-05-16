
% helper.createRMaps;

meanSignal_area = struct();

for k =1:length(data)
    
    meanSignal_area(k).dff  = [];

    for j = 1:length(data(k).sessionIDs)
        for f = 1:length(mData(k,j).LNP_results)
            if ~isempty(find(mData(k,j).LNP_results(f).selected_model == 1)) && isempty(find(mData(k,j).LNP_results(f).selected_model == 5))
                 meanSignal_area(k).dff        = [ meanSignal_area(k).dff; rmaps(k,j).dff(f,:)];
            end
        end
        
    end
end


col =  [122 172 210
        80 106 139
        217 85 88
        129 89 162
        180 151 94
        179 205 142
        0 0 0
        0 0 0]./255; 


fig_g = figure();
for k = 1:length(area)-2
    
    [~, idx] = max(meanSignal_area(k).dff, [], 2); % Returns 2 arrays. Val is the max value of each ROI, idx is the column index of the max value of each ROI.
    idxMatrix = horzcat(idx, meanSignal_area(k).dff); % Appends idx column array to the ROI matrix.
    sortedMatrix = sortrows(idxMatrix, 1); % Sorts ROI matrix by the index of their max values in ascending order.
    sortedMatrix(: , 1) = []; % Removes indexes from first column of sortedMatrix.
    
    sortedMatrix_aligned = NaN(size(sortedMatrix));

    for m = 1:length(idx)
        sortedMatrix_aligned(m,:) = circshift(meanSignal_area(k).dff(m,:), 78-idx(m)+39);
    end

    plot(nanmean(sortedMatrix_aligned), 'LineWidth', 1.5, 'Color', col(k,:));hold on
    
end
ax.FontName = 'Arial';
ax.XColor = [0 0 0];
ax.YColor = [0 0 0];
ax.XLabel.Color = [0 0 0];
ax.YLabel.Color = [0 0 0];
box off
legend({'OFC', 'M2', 'ACC', 'Thal', 'PPC', 'V2'})
xlabel('Position relative to reward(cm)');
%
xticks([1 19 39 58 78]);
xticklabels({'-80','-40','0','40','78'});
set(gca,'FontSize',12, 'FontName', 'Arial')
ylabel('Deconv DFF')
hold on

