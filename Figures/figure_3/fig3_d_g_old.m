% close all 
% clear all


% MP.figure(4)
% axes = findall(gcf,'Type','Axes');
%direction = '/Users/annachristinagarvert/Desktop/Data/Analysed 03:20/sData/';
%% LDDM  m5051 #4 m5088 #7 m5074 #4 m5052 #1 m5075 #4 m5087 #5

% files{7} =  {'m5115-20201203-02','m5115-20201203-01','m5115-20201202-01','m5114-20201203-01',...
%     'm5114-20201202-02','m5114-20201202-01','m5108-20201120-03','m5108-20201120-02','m5108-20201120-01'};

% files{1} = {'m5142-20210709-01','m5143-20210710-02'};
% 
% %% M2  m5094,  m5095
% % could be added: 'm5095-20200520-01_M2'
% files{2} = {'m5094-20200520-01','m5095-20200520-01','m5094-20200522-03',...
% 'm5095-20200522-01','m5128-20210324-01','m5122-20210304-01',...
% 'm5122-20210305-01'};
% 
% 
% files{3} = {'m5082-20200312-01','m5082-20200312-02',...
%        'm5085-20200313-02','m5085-20200314-01','m5124-20210323-02','m5124-20210324-02',...
%        'm5125-20210324-01','m5125-20210323-01', 'm5125-20210325-01'};
%  %m5082-20200313-02 'm5085-20200313-01'
% 
% files{4} = {'m5074-20191202-01','m5075-20191203-01', 'm5074-20191205-01','m5074-20191219-01',...
%     'm5075-20191205-01','m5075-20191205-02','m5075-20191219-01','m5088-20200430-02','m5088-20200430-03',...
%     'm5088-20200504-01','m5088-20200504-02','m5088-20200504-03','m5088-20200508-01','m5088-20200508-03',...
%     'm5140-20210709-01','m5140-20210710-01','m5140-20210710-02','m5141-20210709-02','m5141-20210710-01'};
% % 
% files{5} = {'m5121-20210204-03','m5121-20210205-01','m5121-20210205-02','m5119-20210204-01',...
%     'm5119-20210204-02','m5153-20211208-01',...
%     'm5153-20211208-02','m5153-20211209-02'};
% 
% 
% files{6} = {'m5137-20210610-01','m5137-20210610-02',...
%     'm5138-20210610-01', 'm5138-20210610-02','m5138-20210611-01',...
%     'm5139-20210611-01','m5139-20210611-02','m5139-20210612-01',...
%     'm5146-20211021-01','m5146-20211024-02','m5146-20211022-01',...
%     'm5147-20211022-01','m5147-20211024-01'};
% 
% files{7} = {'m5108-20201120-01','m5108-20201120-02','m5108-20201120-03','m5114-20201202-01','m5114-20201202-02',...
%     'm5114-20201203-01','m5115-20201202-01','m5115-20201203-01','m5115-20201203-02'};
% 
% % files{8}  = {'m5091-20200504-03','m5091-20200508-03','m5091-20200508-06',...
% %     'm5102-20200713-01'};

% load_all_data()



col =  [122 172 210
        80 106 139
        217 85 88
        129 89 162
        180 151 94
        179 205 142
        0 0 0
        0 0 0]./255; % OFC, M2, ACC, Thal, PPC, V2
% %    LDDM, ACC, M2, PPC, V2, OFC
% Tha, ACC, M2, PPC, V2, OFC
% col = [0 0 0; 129 89 162 ; 217 85 88; 80 106 139; 180 151 94; 179 205 142; 122 172 210]./255;
    
% M2 [238 155 56]./255
% RSC [235 72 83]./255
% LDDM [77 52 142]./255
% ACC [119 152 107]./255
%%  separate plots for mice: 
% figMeanAll = figure; 
%  fig = figure();
% hold(axes(4), 'off')
% area = {'OFC','M2','ACC','Thal', 'PPC', 'V2','RSC','V1'};
area = {'OFC','M2','ACC','Thal', 'PPC', 'V2','RSC'};

% figure()

% remove_OFC_sessions= [6,10,11,12];
% file{1}(remove_OFC_sessions)= []; 

for r =     1:7 %length(area)
    rmse_area{r} = []; lengthCells = [];cellsSpaced = []; rand_pos{r}= []; rmse_rand{r}= [];rmse_rand_CI{r}= [];
    cellNo{r} = [];
    f = 1;
    for l = 1:length(file{r})
        
        load(fullfile('/Users/annachristinagarvert/Desktop/Michele/analysis/LNP/5Folds/',area{r},file{r}{l},'axon_final.mat'))  
        pcNo = 0;
        for p = 1:length(axon)
            if ~isempty(find(axon(p).selected_model == 1))
                        pcNo = pcNo +1;
            end
        end
        
       % there has toobe a least one pc
       if pcNo >  0
               
%         load(strcat('/Users/annachristinagarvert/Desktop/Michele/analysis/decoding/decodingVsNoCells/',area{r},'/',file,'/d_data_varN.mat'))         

            load(strcat('/Users/annachristinagarvert/UIO Physiology Dropbox Dropbox/Lab Data/Michele Gianatti/Data&Analysis/Paper/decoding/decodingOnlyPC/',area{r},'/',file{r}{l},'/d_data_varN.mat'))         
            load(fullfile('/Users/annachristinagarvert/UIO Physiology Dropbox Dropbox/Lab Data/Michele Gianatti/Data&Analysis/Paper/sData/',area{r},'/',file{r}{l},'/final_sData.mat'))


            predPos = d_data_varN(end).iter{1, d_data_varN(end).medianTestFold}.predPos_test;
            realPos = d_data_varN(end).iter{1,  d_data_varN(end).medianTestFold}.realPos_test;

            maxval =154.3735;% max([max(predPos(:)) max(realPos(:))]);
            predError = zeros(length(realPos),1);
            for k = 1:length(realPos)
                predError(k) = abs(realPos(k)-predPos(k));
                if predError(k) > maxval/2 && realPos(k) > predPos(k)
                    predError(k) = abs(maxval-realPos(k)+predPos(k));
                elseif predError(k) > maxval/2 && realPos(k) < predPos(k)
                    predError(k) = abs(maxval-predPos(k)+realPos(k));
                end
            end

            meanRMSE(r,f) = nanmean(predError); 

    %         for m = 1:5000
    %             
    %             randPos = circshift(predPos, randperm(length(predPos),1));
    %             
    %             maxval =154.3735;%
    %             randError = zeros(length(realPos),1);
    %             for k = 1:length(realPos)
    %                 randError(k) = abs(realPos(k)-randPos(k));
    %                 if randError(k) > maxval/2 && realPos(k) > randPos(k)
    %                     randError(k) = abs(maxval-realPos(k)+randPos(k));
    %                 elseif randError(k) > maxval/2 && realPos(k) < randPos(k)
    %                     randError(k) = abs(maxval-randPos(k)+realPos(k));
    %                 end
    %             end
    %             
    %             rand_rmse(m) = nanmean(randError);
    % 
    %         end
    % 
    %         mean_rand(r,f) = nanmean(rand_rmse);
    %         tempCI = quantile(rand_rmse,[0.05 0.95]); 
    %         mean_rand_CI(r,f) =  tempCI(1);
            f = f+1;
       end
    end
    
end

meanRMSE(meanRMSE==0) = NaN;
% mean_rand(mean_rand == 0) = NaN;
% mean_rand_CI(mean_rand_CI == 0) = NaN;

figure()
dir = [7 2 4 5 3 6 1]; % only PC xticklabels({'RSC','M2','PPC', 'ACC','Thal', 'V2','OFC'})

% dir = [7 2 5 4 3 6 1];
for r = 1:6
    for l = 1:size(meanRMSE,2)
        scatter(dir(r),meanRMSE(r,l),70, [0.5 0.5 0.5]);
        hold on
    end
    scatter(dir(r),nanmean(meanRMSE(r,:)),70, [0 0 0],'filled');
    errorbar(dir(r),nanmean(meanRMSE(r,:)),nanstd(meanRMSE(r,:))/sqrt(sum(~isnan(meanRMSE(r,:)))),'k','LineWidth',1.5);
end
% xticklabels({'RSC','M2','PPC', 'Thal','ACC', 'V2','OFC'})

xlim([1 8])
ylim([5 55])
xticks([2:7])
ax = gca;
ax.FontSize = 12;
ax.FontName = 'Arial';
ax.XColor = [0 0 0];
ax.YColor = [0 0 0];
ax.XLabel.Color = [0 0 0];
ax.YLabel.Color = [0 0 0];
xticklabels({'M2','PPC','ACC', 'Thal', 'V2','OFC'})
% yline(nanmean(mean_rand_CI(:)))
% yline(nanmean(mean_rand(:)))

sortedRMSE{1}  =  meanRMSE(2,:);
sortedRMSE{2}  =  meanRMSE(5,:);
sortedRMSE{3}  =  meanRMSE(3,:);
sortedRMSE{4}  =  meanRMSE(4,:);
sortedRMSE{5}  =  meanRMSE(6,:);
sortedRMSE{6}  =  meanRMSE(1,:);

for i = 1:6
    for j = 1:6
        pval(i,j) = ranksum(sortedRMSE{i},sortedRMSE{j});
    end
end

matr =triu(ones(6,6));
matr(eye(6,6)==1) = NaN;
matr(matr== 0)= NaN;
pval(isnan(matr)) = NaN;
[corrected_p, h]=bonf_holm(pval);
 
figure()
imagesc(triu(corrected_p))
hold on
alpha(matr)

c = colorbar('Limits',[0 0.05]);
caxis([0 0.05])
ax = gca;
ax.FontSize = 12;
ax.FontName = 'Arial';
ax.XColor = [0 0 0];
ax.YColor = [0 0 0];
ax.XLabel.Color = [0 0 0];
ax.YLabel.Color = [0 0 0];
xtickangle(45)
xticks([1:6])
yticks([1:6])

xticklabels({'M2','PPC','ACC', 'Thal', 'V2','OFC'})
yticklabels({'M2','PPC','ACC', 'Thal', 'V2','OFC'})


%%  decoding vs cell no
for r =     1:6%length(area)
    rmse_area{r} = []; lengthCells = [];cellsSpaced = []; rand_pos{r}= []; rmse_rand{r}= [];rmse_rand_CI{r}= [];
    cellNo{r} = [];
    for f = 1:length(file{r})
            
%         file = files{r}{f};
        load(strcat('/Users/annachristinagarvert/Desktop/Michele/analysis/decoding/decodingOnlyPC/all_place_cells/',area{r},'/',file,'/d_data_varN.mat'))
%         
%         if r == 7
%             load(fullfile('/Users/annachristinagarvert/Desktop/Michele/sData/',area{r},'/',file,'/sData.mat'))
%         else
            load(fullfile('/Users/annachristinagarvert/Dropbox (UIO Physiology Dropbox)/Lab Data/Michele Gianatti/Data&Analysis/sData_SNR/',area{r},'/',file,'/final_sData.mat'))

%         end
        
        noTrials = length(trials.trialStart);
        rmse =  []; meanRMSE = [];  mean_rand =  []; rand_rmse = [];
        for i = 1:length(d_data_varN) 
            
            cellNo{r}{f}(i) = length(d_data_varN(i).iter{1, d_data_varN(i).medianTestFold}.cellIdx); 

            
%             for l = 1:5
                predPos = d_data_varN(i).iter{1, d_data_varN(i).medianTestFold}.predPos_test;
                realPos = d_data_varN(i).iter{1,  d_data_varN(i).medianTestFold}.realPos_test;
                
                maxval =154.3735;% max([max(predPos(:)) max(realPos(:))]);
                predError = zeros(length(realPos),1);
                for k = 1:length(realPos)
                    predError(k) = abs(realPos(k)-predPos(k));
                    if predError(k) > maxval/2 && realPos(k) > predPos(k)
                        predError(k) = abs(maxval-realPos(k)+predPos(k));
                    elseif predError(k) > maxval/2 && realPos(k) < predPos(k)
                        predError(k) = abs(maxval-predPos(k)+realPos(k));
                    end
                end
                
                meanRMSE(i) = nanmean(predError); 
                
                 for m = 1:5000
                    
                    randPos = circshift(predPos, randperm(length(predPos),1));
%                     if m == 10
%                         figure()
% %                         plot(realPos);  hold on
%                         plot(randPos)
%                         hold on
%                         plot(predPos)
%                     end
                    maxval =154.3735;%
                    randError = zeros(length(realPos),1);
                    for k = 1:length(realPos)
                        randError(k) = abs(realPos(k)-randPos(k));
                        if randError(k) > maxval/2 && realPos(k) > randPos(k)
                            randError(k) = abs(maxval-realPos(k)+randPos(k));
                        elseif randError(k) > maxval/2 && realPos(k) < randPos(k)
                            randError(k) = abs(maxval-randPos(k)+realPos(k));
                        end
                    end
                    
                    rand_rmse(m,i) = nanmean(randError);
                    
                    if i == length(d_data_varN) 
                        classes = unique(realPos);                    
                        realPosBinned = [];
                        classes =  2.6165:5.233:157.05;
                        for t = 1:length(realPos)
                            [~,ind]     = min(abs(classes-realPos(t)));
                            realPosBinned(t)    = classes(ind);
                        end


                        for k= 1:length(classes)
                            idx = find(realPosBinned == classes(k));
                            rand_pos{r}(m,k) = nanmean(randError(idx));
                        end
                        
                    end
                    
                    
              

                 end
%                     

% %                     classes =  unique(realPos);
% %                     if length(classes) > 30
% %                         classes = [classes 149.1405+5.233];
% %                     end
% 
%                     classes =  floor(2.6165:5.233:157.05);
%                     for k= 1:length(classes)
%                         idx = find(floor(realPos) == classes(k));
%                         %                     mouseTemp(l,k) = nanmean(predError(idx));
%                         mouse{r}(f,m,k) = nanmean(randError(idx));
%                     end
%                     
%                     rand_rmse{r}(f,m) =nanmean(randError); 
% 
%                 end
            end
%         end
        
        mean_rand = nanmean(rand_rmse);
        tempCI = quantile(rand_rmse,[0.05 0.95]); mean_rand_CI =  tempCI(1,:);
        if f > 1
            if size(rmse_area{r},2) < length(meanRMSE)
                rmse_rand{r} = [rmse_rand{r} NaN(size(rmse_area{r},1),length(meanRMSE)-size(rmse_area{r},2))];
                rmse_rand_CI{r} = [rmse_rand_CI{r} NaN(size(rmse_area{r},1),length(meanRMSE)-size(rmse_area{r},2))];
                rmse_area{r} = [rmse_area{r} NaN(size(rmse_area{r},1),length(meanRMSE)-size(rmse_area{r},2))];
            end
            if length(meanRMSE) < size(rmse_area{r},2)
                meanRMSE = [meanRMSE  NaN(1,size(rmse_area{r},2)-length(meanRMSE))];
                mean_rand = [mean_rand  NaN(1,size(rmse_area{r},2)-length(mean_rand))];
                mean_rand_CI = [mean_rand_CI  NaN(1,size(rmse_area{r},2)-length(mean_rand_CI))];
            end
        end
       
        rmse_area{r}(f,:)       = meanRMSE;
        rmse_rand{r}(f,:)       = mean_rand;
        rmse_rand_CI{r}(f,:)    = mean_rand_CI;

        cellsSpaced(f) = 10*round(cellNo{r}{f}(2)/10);
        lengthCells(f) = length(cellNo{r}{f});
    end
    
    
    if ~isempty(find(cellsSpaced == 20)) && ~isempty(find(cellsSpaced == 30))
        cellsSpacedShort = find(cellsSpaced == 20);
        lengthCells(cellsSpacedShort) =  1;
        for f = 1:length(cellsSpacedShort)
            rmse_area{r}(cellsSpacedShort(f),2:2:end) = NaN; 
        end
    end
      [maxCells maxCellIdx]= max(lengthCells);
      cellNoSum = cellNo{r}{maxCellIdx};
%        for f = 1:size(rmse_area{r},1)
%             scatter(cellNo, rmse_area{r}(f,:) ,'k', 'filled')
%             hold on
%        end
        noNan = [];
        for m = 1:size(rmse_area{r},2)
            noNan(m) = length(find(isnan(rmse_area{r}(:,m))));
        end
        
        idx = find(noNan == size(rmse_area{r},1)-1);
        if ~isempty(idx)
            plot(gca,cellNoSum(1:idx(1)-1),nanmean(rmse_area{r}(:,1:idx(1)-1),1), 'Color',col(r,:), 'LineWidth', 1.5)
            hold(gca,'on')
            plot(gca,cellNoSum(idx(1)-1:end),nanmean(rmse_area{r}(:,idx(1)-1:end),1), 'Color',col(r,:), 'LineWidth', 1.5, 'LineStyle','--')
            xval = cellNoSum(1:idx(1)-1); yval = rmse_area{r}(:,1:idx(1)-1);
%             errorbar(axes(4),xval, nanmean(yval), nanstd(yval)./sqrt(size(rmse_area{r},1)-noNan(1:idx(1)-1)), 'LineWidth' ,1.5, 'Color',col(r,:))
             patch(gca,[xval fliplr(xval)],[nanmean(yval)+nanstd(yval)./sqrt(size(rmse_area{r},1)-noNan(1:idx(1)-1)) fliplr(nanmean(yval)-nanstd(yval)./sqrt(size(rmse_area{r},1)-noNan(1:idx(1)-1)))],col(r,:),'linestyle','none','FaceAlpha', 0.2);
        else
            plot(gca, cellNoSum,nanmean(rmse_area{r}), 'Color',col(r,:), 'LineWidth', 1.5)
            hold(gca,'on')
            xval = cellNoSum; yval = rmse_area{r};
%             errorbar(axes(4),xval, nanmean(yval), nanstd(yval)./sqrt(size(rmse_area{r},1)), 'LineWidth' ,1.5, 'Color',col(r,:))
            patch(gca,[xval fliplr(xval)],[nanmean(yval)+nanstd(yval)./sqrt(size(rmse_area{r},1)) fliplr(nanmean(yval)-nanstd(yval)./sqrt(size(rmse_area{r},1)))],col(r,:),'linestyle','none','FaceAlpha', 0.2);
        
        end
        
%         errorbar(cellNo(1:idx(1)),nanmean( rmse_area{r}(:,1:idx(1)),1), nanstd( rmse_area{r}(:,1:idx(1)),1), 'k', 'LineStyle', 'none', 'LineWidth', 1.5)
%         yline(nanmean(rand_rmse(:)), 'k', 'LineWidth', 1.5)
        
%         xlimval = [ 0 max(cellNo)+20 max(cellNo)+20 0];
%         ylimval = [nanmean(rand_rmse(:))-2*nanstd(rand_rmse(:)) nanmean(rand_rmse(:))-2*nanstd(rand_rmse(:))  nanmean(rand_rmse(:)) nanmean(rand_rmse(:))];
%         patch(xlimval, ylimval,[0.5 0.5 0.5],'LineStyle','none','FaceAlpha', 0.2);
%         xlim([ 0 max(cellNo)+20])
        % yline(nanmean(rand_rmse(:))-2*nanstd(rand_rmse(:)))
        
      
%         ylim([5 40])
end

xlabel(gca,'# axons')
ylabel(gca,'Decoding error (cm)')
set(gca, 'FontName', 'Arial', 'FontSize', 12)
box(gca, 'off')
ylim(gca,[5 45])


figure()
dir = [2 4 3 1 5];
for r = 2:6
    for l = 1:size(rmse_area{r},1)
        scatter(dir(r-1),rmse_area{r}(l,14),70, [0.5 0.5 0.5]);
        hold on
    end
    scatter(dir(r-1),nanmean(rmse_area{r}(:,14)),70, [0 0 0],'filled');
    errorbar(dir(r-1),nanmean(rmse_area{r}(:,14)),nanstd(rmse_area{r}(:,14)),'k','LineWidth',1.5);
end
xlim([0 6])
ylim([5 55])
xticks([1:5])
xticklabels({'PPC','M2','Thal', 'ACC', 'V2'})

figure()
randall = [];
for r = 1:6
   randall = [randall ;rand_pos{r}];
    hold on
end
plot(nanmean(randall))
tempCI = quantile(randall,[0.05 0.95]);
hold on
plot(tempCI(1,:))

rmse_rand_all = []; rmse_rand_CI_all = [];
for i = 1:6
    %     figure()
    for f = 1:length(cellNo{i})
        
        v = rmse_rand_all;  t = rmse_rand_CI_all;
        if ~isempty(find(round(cellNo{i}{f}./10).*10 == 20))
            j = rmse_rand{i}(f,1:2:end);
            k = rmse_rand_CI{i}(f,1:2:end);
        else
            j = rmse_rand{i}(f,:);
            k = rmse_rand_CI{i}(f,:);
        end
        
        n =max(size(v,2),numel(j));
        v(:,end+1:n)=nan;
        j(end+1:n)=nan;
        rmse_rand_all =  [v; j];
        
        n =max(size(t,2),numel(k));
        t(:,end+1:n)=nan;
        k(end+1:n)=nan;
        rmse_rand_CI_all =  [t; k];
    end
    %         plot(cellNo{i}{f},rmse_rand{i}(f,~isnan(rmse_rand{i}(f,:))))
    %      hold on
end
%     hold on
% 
% for i = 1:7
%     cellNoMax = length
% cell2mat(cellNo)
% 
% rmse_rand{1} = rmse_rand{1}(:,1:2:end);
% for i = 1:7
%     for f = 1:length(cellNo{i})
%     if find(cellNo{i}{f}
%     
% end

F = 10:20:730;
amean = nanmean(rmse_rand_all(:,1:end-3));
astd = nanmean(rmse_rand_CI_all(:,1:end-3));
yline(nanmean(amean), 'LineWidth', 1.2, 'Color', 'k')
yline(nanmean(astd), 'LineWidth', 1.2,'LineStyle','--', 'Color', 'k')

hold(axes(4), 'on')
patch(axes(4),[F(~isnan(amean)) fliplr(F(~isnan(amean)))],[amean(~isnan(amean)) fliplr(astd)],'k','linestyle','none','FaceAlpha', 0.2);


% meanAll_ax=axes(2);  hold on
% for j = 1:3%length(mouse)
% %     fig = figure(); 
% %     hax=axes; hold on
% 
%     if length(mouse{j}) > 1
%         xLength = [];  x = []; y = []; yAll = [];
%        
%         for i = 1: length(mouse{j})
%            if mouseIdx{j}{i} == 1
%             uiopen(strcat(mouse{j}{i}, '/decoding_varN/rmse_varN.fig'),1);
%            else
%                uiopen(strcat(mouse{j}{i}, '/rmse_varN.fig'),1);
%            end
%                
%             dataObjs = findobj(gca,'-property','YData');
% %             plot(hax,dataObjs(4).XData ,dataObjs(4).YData, 'LineWidth',2, 'Color', 'k');%col{j})
%             x{i} = dataObjs(4).XData;
%             y{i} = dataObjs(4).YData;
%             
% %             if j ~= 4 || length(x{i})>1
%                 if x{i}(2) == 20
%                     y{i} = y{i}(1:2:end);
%                     x{i} = x{i}(1:2:end);
%                 end
% %             end
%             xLength = [xLength, length(x{i})];
%         end
% 
%         set(gca, 'FontName', 'Gotham', 'FontSize', 18)
%         xlabel('number of axons')
%         ylabel('test mean rmse [cm]')
%         box off
% 
%         [maxLength maxI] = max(xLength);
%         for i = 1: length(mouse{j}); yAll(i,:)= [y{i}, NaN(1,maxLength-xLength(i))]; end
% %         patch(meanAll_ax,[x{maxI} fliplr(x{maxI})],[nanmean(yAll)+nanstd(yAll)./length(mouse{j}) fliplr(nanmean(yAll)-nanstd(yAll)./length(mouse{j}))],col(j,:),'linestyle','none','FaceAlpha', 0.4);
%         plot(axes(4),x{maxI},nanmean(yAll), 'LineWidth' ,1.5, 'Color', col(j,:))
%         hold(axes(4),'on')
%         errorbar(axes(4),x{maxI}, nanmean(yAll), nanstd(yAll), 'LineWidth' ,1.5, 'Color',col(j,:))
%         set(axes(4), 'FontName', 'Arial', 'FontSize', 8)
%         xlabel(axes(4),'# of axons')
%         ylabel(axes(4),'test mean rmse [cm]')
%         box(axes(4),'off')
%     else
%         uiopen(strcat( mouse{j}{1}, '/decoding_varN/rmse_varN.fig'),1);
%         dataObjs = findobj(gca,'-property','YData');
%         x{i} = dataObjs(4).XData;
%         y{i} = dataObjs(4).YData;
%         if x{i}(2) == 20
%             y{i} = y{i}(1:2:end);
%             x{i} = x{i}(1:2:end);
%         end
% %         plot(hax,x{i},y{i}, 'LineWidth',2, 'Color', col(j,:))
%             
%         box on
%         set(gca, 'FontName', 'Gotham', 'FontSize', 22)
%         xlabel('# cells')
%         ylabel('test rmse [cm]')
%         plot(axes(4),dataObjs(4).XData,dataObjs(4).YData, 'LineWidth' ,2, 'Color', col(j,:))
% 
%     end
% end


function [corrected_p, h]=bonf_holm(pvalues,alpha)
if nargin<1
    error('You need to provide a vector or matrix of p-values.');
else
    if ~isempty(find(pvalues<0,1)),
        error('Some p-values are less than 0.');
    elseif ~isempty(find(pvalues>1,1)),
        fprintf('WARNING: Some uncorrected p-values are greater than 1.\n');
    end
end
if nargin<2
    alpha=.05;
elseif alpha<=0
    error('Alpha must be greater than 0.');
elseif alpha>=1
    error('Alpha must be less than 1.');
end
s=size(pvalues);
if isvector(pvalues)
    if size(pvalues,1)>1
       pvalues=pvalues'; 
    end
    [sorted_p sort_ids]=sort(pvalues);    
else
    [sorted_p sort_ids]=sort(reshape(pvalues,1,prod(s)));
end
[dummy, unsort_ids]=sort(sort_ids); %indices to return sorted_p to pvalues order
m=length(sorted_p); %number of tests
mult_fac=m:-1:1;
cor_p_sorted=sorted_p.*mult_fac;
cor_p_sorted(2:m)=max([cor_p_sorted(1:m-1); cor_p_sorted(2:m)]); %Bonferroni-Holm adjusted p-value
corrected_p=cor_p_sorted(unsort_ids);
corrected_p=reshape(corrected_p,s);
h=corrected_p<alpha;
end
