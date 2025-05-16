
% initiate variables

figure()
area = 7;
plot.decodingVsNoCells

% plot results

plot(gca,cellNoSum,nanmean(rmse_all,1), 'Color',[0 0 0], 'LineWidth', 1.5) 
yval = rmse_all;
patch(gca,[cellNoSum fliplr(cellNoSum)],[nanmean(yval)+nanstd(yval)./sqrt(size(rmse_all,1)) fliplr(nanmean(yval)-nanstd(yval)./sqrt(size(rmse_all,1)))],[0 0 0],'linestyle','none','FaceAlpha', 0.2);

ylabel('Decoding error (cm)')
xlabel('# Cells')
set(gca,'FontName','Arial','FontSize',12)
box off
ylim([0 55])

