


for k =1:length(areas)
    meanSignal_area(k).deconv  = [];
    for j = 1:length(data(areas(k)).sessionIDs)
        for f = 1:length(mData(areas(k),j).LNP_results)
            if ~isempty(find(mData(areas(k),j).LNP_results(f).selected_model == 1)) && isempty(find(mData(areas(k),j).LNP_results(f).selected_model == 5))
                 meanSignal_area(k).deconv        = [ meanSignal_area(k).deconv; rmaps(areas(k),j).deconv(f,:)];
            end
        end
    end


    for i  = 1:size(meanSignal_area(k).deconv,2)
        for j  =1:size(meanSignal_area(k).deconv,2)
            f = corrcoef(meanSignal_area(k).deconv(:,i), meanSignal_area(k).deconv(:,j),'rows','complete');
            corrval(i,j) = f(1,2);
        end
    end

    
    fig = figure();
    imagesc(flipud(corrval))
    colormap('jet')
    limsY = get(gca,'YLim');
    hold on
    for i = 1: length(cue1)
        plot(gca, [cue1(i) cue1(i)],limsY, 'LineStyle','--','Color', [1 1 1], 'LineWidth', 2);
    end
    
    for i = 1: length(cue2)
        plot(gca, [cue2(i) cue2(i)],limsY, 'LineStyle','--','Color', [1 1 1], 'LineWidth', 2);
    end
    limsX = get(gca,'XLim');
    
    for i = 1: length(cue1)
        plot(gca,limsX, [limsX(2)-cue1(i) limsX(2)-cue1(i)], 'LineStyle','--','Color', [1 1 1], 'LineWidth', 2);
    end
    
    for i = 1: length(cue2)
        plot(gca,limsX, [limsX(2)-cue2(i) limsX(2)-cue2(i)], 'LineStyle','--','Color', [1 1 1], 'LineWidth', 2);
    end
    %
    xlabel('position (cm)'); ylabel('position (cm)');
    % %
    xticks([1 20 40 60 78]);
    xticklabels({'0','40','80','120', '157'});
    set(gca, 'FontSize',18, 'FontName', 'Arial')
    % ylabel('# axons')
    %
    yticks(flipud([78-1 78-20 78-40 78-60  1]'));
    yticklabels({'157','120','80','40', '0'}');
    title(data(areas(k)).area)
    colorbar

end



