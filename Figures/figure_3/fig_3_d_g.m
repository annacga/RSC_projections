col = [122 172 210
        80 106 139
        217 85 88
        129 89 162
        180 151 94
        179 205 142
        0 0 0
        255 50 80]./255;
    
fig_d = figure();

for a = 1:length(data)-2
    area = a;
    plot.decodingVsNoCells

    % plot results
    plot(gca,cellNoSum,nanmean(rmse_all,1), 'Color',col(area,:), 'LineWidth', 1.5) 
    yval = rmse_all;
    patch(gca,[cellNoSum fliplr(cellNoSum)],[nanmean(yval)+nanstd(yval)./sqrt(size(rmse_all,1)) fliplr(nanmean(yval)-nanstd(yval)./sqrt(size(rmse_all,1)))],col(area,:),'linestyle','none','FaceAlpha', 0.2);
    hold on
end


ylabel('Decoding error (cm)')
xlabel('# Cells')
set(gca,'FontName','Arial','FontSize',12)
box off
ylim([0 55])