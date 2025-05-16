
k = 1;
for i = 1:length(data)
    for f = 1:length(data(i).sessionIDs )
        
        sData = mData(i,f).sData;
    
        % find mean lick frequency across position
        [lickFrequencyDs,lickFrequency] = helper.extractLickFrequency(sData, 10000, 15, 15);
        
        matrixLick       = plot.createHeatMap(sData.trials.trialLength, sData.behavior.wheelPosDsBinned,lickFrequencyDs);
        meanLick{i}(f,:) = nanmean(matrixLick);
        
        % find first licks
        firstLicks{k} = [];
        for r = 1:size(matrixLick,1)
            idxLick = find(matrixLick(r,15:end)>1);
            if ~isempty(idxLick)
                firstLicks{k} = [firstLicks{k}, 15+idxLick(1)];
            end
        end
        k = k+1;

        
        %% create run matrix
       
        matrixRun       = plot.createHeatMap(sData.trials.trialLength, sData.behavior.wheelPosDsBinned,sData.behavior.runSpeedDs);   
        meanRun{i}(f,:) = nanmean(matrixRun);
   
    end
end




 F = 1:size(meanRun{1},2);

c1 = [80 134 198]/255;
c2 = [0 0 0]/255;

c = [linspace(c1(1),c2(1),2)', linspace(c1(2),c2(2),2)', linspace(c1(3),c2(3),2)'];

%% plot run behavior
fig_1_a = figure();
amean   = nanmean(cell2mat(meanRun'));
astd    = nanstd(cell2mat(meanRun'));
plot(amean,'LineWidth',1,'Color',c(1,:))
hold on  
patch([F(~isnan(amean)) fliplr(F(~isnan(amean)))],[amean(~isnan(amean))+astd(~isnan(amean)) fliplr(amean(~isnan(amean))-astd(~isnan(amean)))],c(1,:),'linestyle','none','FaceAlpha', 0.2);

box off
set(gca,'FontName', 'Arial', 'FontSize', 12)
xlabel(gca,'Position (cm)')
ylabel(gca,'Speed (cm/s)')
xticks(gca,[1 25 50 78])
xticklabels(gca,{'0' ,'50','100','157'})
xlim([1 79])

%% plot lick behavior
fig_1_b = figure();
amean = nanmean(cell2mat(meanLick'));
astd = nanstd(cell2mat(meanLick'))./sqrt(8);
plot(amean,'LineWidth',1,'Color',c(2,:))
hold on  
patch([F(~isnan(amean)) fliplr(F(~isnan(amean)))],[amean(~isnan(amean))+astd(~isnan(amean)) fliplr(amean(~isnan(amean))-astd(~isnan(amean)))],c(2,:),'linestyle','none','FaceAlpha', 0.2);

firstLicksVal = [];
for i = 1:length(firstLicks); firstLicksVal = [firstLicksVal, nanmean(firstLicks{i})]; end

plot(gca, nanmean(firstLicksVal),6,'.','MarkerSize', 25,'Color', 'k')
errorbar(gca,nanmean(firstLicksVal),6,nanstd(firstLicksVal),'horizontal','k','LineWidth',1.5, 'Color', c(2,:))

box(gca, 'off')
set(gca, 'FontName', 'Arial', 'FontSize', 12)
xlabel(gca,'Position (cm)')
ylabel(gca,'Lick rate (Hz)')
xticks(gca,[1 25 50 78])
xticklabels(gca,{'0' ,'50','100','157'})
xlim([1 79])

