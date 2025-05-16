

for k =1:length(areas)
    meanSignal_area(k).deconv  = [];
    for j = 1:length(data(areas(k)).sessionIDs)
        for f = 1:length(mData(areas(k),j).LNP_results)
            if ~isempty(find(mData(areas(k),j).LNP_results(f).selected_model == 1)) && isempty(find(mData(areas(k),j).LNP_results(f).selected_model == 5))
                 meanSignal_area(k).deconv        = [ meanSignal_area(k).deconv; rmaps(areas(k),j).deconv(f,:)];
            end
        end
    end

    normedSignal    = (meanSignal_area(k).deconv - min(meanSignal_area(k).deconv, [], 2))./(max(meanSignal_area(k).deconv, [], 2) - min(meanSignal_area(k).deconv, [], 2));

    [~, idx] = max(normedSignal, [], 2); % Returns 2 arrays. Val is the max value of each ROI, idx is the column index of the max value of each ROI.
    idxMatrix = horzcat(idx, normedSignal); % Appends idx column array to the ROI matrix.
    sortedMatrix = sortrows(idxMatrix, 1); % Sorts ROI matrix by the index of their max values in ascending order.
    sortedMatrix(: , 1) = []; % Removes indexes from first column of sortedMatrix.

    fig = figure();
    imagesc(sortedMatrix)
    c = colorbar;
    colormap(jet);
    c.Label.String = 'Deconv Signal';
    c.Label.FontSize = 11;
    c.Label.FontUnits = 'normalized';
    c.TickDirection = 'out';
    caxis([0 1]); % Sets limit for color map, left is min (black) and right is max (white).
    xlabel('Position (cm)');
    title(data(areas(k)).area)
    xticks(gca,[1 25 50 78])
    xticklabels(gca,{'0' ,'50','100','157'})
    xlim([1 79])
    set(gca, 'FontSize',18, 'FontName', 'Arial')

    hold on
    cue1 =  [42 47 122 128]./2;
    cue2  = [63 68 100 106]./2;
    limsY = get(gca,'YLim');

    for i = 1: length(cue1)
        plot(gca, [cue1(i) cue1(i)],limsY, 'LineStyle','--','Color', [1 1 1], 'LineWidth', 2);
    end

    for i = 1: length(cue2)
        plot(gca, [cue2(i) cue2(i)],limsY, 'LineStyle','--','Color', [1 1 1], 'LineWidth', 2);
    end

end