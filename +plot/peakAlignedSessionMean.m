function peakAlignedSessionMean(meanSignal_area)


col =  [122 172 210
        80 106 139
        217 85 88
        129 89 162
        180 151 94
        179 205 142
        0 0 0
        0 0 0]./255; 

 fig = figure();
 for i = 1:7
    subplot(3,3,i)
    %      for m = 1:length(file{i})
    normedSignalAll = (meanSignal_area{i} - min(meanSignal_area{i},[],2))./(max(meanSignal_area{i},[],2)-min(meanSignal_area{i},[],2));
    
    meanSequence = nanmean(meanSignal_area{i},1);
    plot(meanSequence,'Color',col(i,:),'LineWidth',1)
    yval = meanSignal_area{i};
    xval = 1:157;
    patch(gca,[xval fliplr(xval)],[nanmean(yval)+nanstd(yval)./sqrt(size(yval,1)) fliplr(nanmean(yval)-nanstd(yval)./sqrt(size(yval,1)))],col(i,:),'linestyle','none','FaceAlpha', 0.2);
    
    hold on
    %      end

%     ax = gca;
%     ax.FontSize = 12;
%     ax.FontName = 'Arial';
%     ax.XColor = [0 0 0];
%     ax.YColor = [0 0 0];
%     ax.XLabel.Color = [0 0 0];
%     ax.YLabel.Color = [0 0 0];
%     xticks([1 20 40 60 78])
%     xticklabels([0 40 60 80 157])
%     xlim([1 78])
%     xlabel('Position (cm)')
%     ylabel('Deconv. DFF')
%     box off
%     title(area{i})
 end


ax = gca;
ax.FontSize = 12;
ax.FontName = 'Arial';
ax.XColor = [0 0 0];
ax.YColor = [0 0 0];
ax.XLabel.Color = [0 0 0];
ax.YLabel.Color = [0 0 0];
xticks([1 20 40 60 78])
xticklabels([0 40 60 80 157])
xlim([1 78])
xlabel('Position (cm)')
ylabel('Deconv. DFF')
box off