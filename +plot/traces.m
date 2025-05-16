

sData       = mData(area,session).sData;
figTraces   = figure();
set(figTraces, 'Units', 'centimeters', 'Position', [0 0 20 30]);

ax_signal   = axes('Position',[0.1 0.31 0.8 0.65]);     hold(ax_signal, 'on')
ax_pos      = axes('Position',[0.1 0.19 0.8 0.1]);
ax_speed    = axes('Position',[0.1 0.07 0.8 0.1]);


% fig = gcf;

nRois           = length(rois);
signal          = sData.imdata.roiSignals(2).dff;
signalDeconv    = sData.imdata.roiSignals(2).deconv;

added = 1;

% adjustSizeDFF = 1200;
% adjustSizeDeconv = 3500;

spaceBetweenCells = 1;

title(data(area).area)

jj = 1; minVal = []; maxVal = [];
for rNo = 1:nRois
    signalTemp          = signal(rois(rNo),:)-spaceBetweenCells*(rNo);
    signalDeconvTemp    = signalDeconv(rois(rNo),:)-spaceBetweenCells*(rNo)-0.1*spaceBetweenCells; 
    
    plot(ax_signal, signalTemp, 'LineWidth',0.5,'Color',[0 0 0]); jj = jj+1;
    plot(ax_signal, signalDeconvTemp,'Color','r');

    maxVal = max([maxVal max(signalTemp)]);
    minVal = min([minVal min(signalDeconvTemp)]);
    jj = jj+1;
end

ax_signal.XAxis.Visible = 'off'; ax_signal.YAxis.Visible = 'off';
plot(ax_pos,sData.behavior.wheelPosDs,'k', 'LineWidth',1);
plot(ax_speed,sData.behavior.runSpeedDs,'k', 'LineWidth',1);


set(ax_pos, 'FontSize',12, 'FontName', 'Arial','YTickLabels',[],'XTickLabels',[], 'Box', 'off', 'XLim', xlimit);
set(ax_speed, 'FontSize',12, 'FontName', 'Arial','YTickLabels',[],'XTickLabels',[], 'Box', 'off', 'XLim', xlimit);
set(ax_signal, 'FontSize',12, 'FontName', 'Arial','YTickLabels',[],'XTickLabels',[], 'Box', 'off', 'XLim', xlimit);

ax_pos.YLabel.String= 'pos';
ax_speed.YLabel.String= 'speed';


ax_speed.XTick               = xlimit(1):31*5:xlimit(2);
ax_speed.XTickLabel          = 0:5:5*length(ax_speed.XTick);
ax_speed.XLabel.String       = 'Time(s)';