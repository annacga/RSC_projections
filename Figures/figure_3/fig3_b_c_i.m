

col = [122 172 210
        80 106 139
        217 85 88
        129 89 162
        180 151 94
        179 205 142
        0 0 0
        255 50 80]./255;
    
randAll = [];

type ='d_data';

maxval =154.3735;  
classes =  2.6165:5.233:157.05;
classbin = 1:30;
    
rmse_vs_pos = cell(6,1);

fig_i = figure();
for r = 1:6
    for f = 1:length(data(r).sessionIDs)
        rmse_vs_pos_folds    = NaN(5,length(classes));
        pred_PosMean         = NaN(5,length(classes));

       if  ~isempty(mData(r,f).(type))
            for l = 1:5
                pred_pos     = mData(r,f).(type)(length(mData(r,f).(type))).iter{1,l}.predPos_test;
                actual_class = mData(r,f).(type)(length(mData(r,f).(type))).iter{1, l}.realPos_test;

                % transform back from class to position bin
                actual_pos = NaN(length(actual_class),1);
                for t = 1:length(actual_class)
                     [~,ind]            = min(abs(classes-actual_class(t)));
                     actual_pos(t)      = classes(ind);
                end
                                
                % calculate error for all time bins
                predError = zeros(length(pred_pos),1);
                for i = 1:length(actual_pos)
                    predError(i)      = abs(actual_pos(i)-pred_pos(i));
                    if predError(i) > maxval/2 && actual_pos(i) > pred_pos(i)
                        predError(i) = abs(maxval-actual_pos(i)+pred_pos(i));
                        pred_pos(i) = maxval+pred_pos(i);
                    elseif predError(i) > maxval/2 &&actual_pos(i) < pred_pos(i)
                        predError(i) = abs(maxval-pred_pos(i)+actual_pos(i));
                        pred_pos(i) = -(maxval-pred_pos(i));
                    end
                end
                
                
                % calculate error for each class (position related error
                for k= 1:length(classes)
                   idx                    = find(actual_pos == classes(k));
                   rmse_vs_pos_folds(l,k) = nanmean(predError(idx'));
                end
                
                
             end
            
     
             rmse_vs_pos{r}(f,:) = nanmean(rmse_vs_pos_folds);
             rmse(r,f) = nanmean(predError);
                
            end
    end

    
    % plot rmse vs pos
    F       = 1:31;
    amean   = nanmean(rmse_vs_pos{r},1);
    amean   = [amean amean(1)];
    astd    = nanstd(rmse_vs_pos{r})./sqrt(size(rmse_vs_pos{r},1));
    astd    = [astd astd(1)];
    patch(gca,[F(~isnan(amean)) fliplr(F(~isnan(amean)))],[amean(~isnan(amean))+astd(~isnan(amean)) fliplr(amean(~isnan(amean))-astd(~isnan(amean)))],col(r,:),'linestyle','none','FaceAlpha', 0.2);
    hold on
    plot(amean, 'LineWidth', 1.2, 'Color', col(r,:))

end


ylabel('Decoding error (cm)')
xlabel('Position (cm)')
set(gca, 'FontName', 'Arial', 'FontSize', 12)
box(gca, 'off')
xticks(gca, [1 7.5 15 22.5 30])
xticklabels(gca, {'0', '40','80' ,'120','157'})


cues = [42 47 122 128 63 68 100 106]./5.2333;

for i = 1:8
    xline(cues(i),'--',[0.5 0.5 0.5],'LineWidth',1.5)
end


% plot mean rmse for each area
fig_b_or_e = figure();
sorting             = [6 1 4 2 3 5];
inverse_sorting     = [2 4 5 3 6 1];

sorted_x_labels = cell(6,1);

for r  = 1:6
    amean = nanmean(rmse_vs_pos{r},2);
    scatter(ones(1,length(amean))*sorting(r), amean, 70,[0.5 0.5 0.5]);%col(l,:))
    hold( 'on')
 
    scatter(sorting(r), nanmean(amean), 70,[0 0 0],'filled');%col(l,:))
    errorbar(sorting(r), nanmean(amean),nanstd(amean)/sqrt(length(amean)),'Color' ,'k', 'LineWidth', 1.5)
    sorted_x_labels{r} = data(inverse_sorting(r)).area;
end

xlim([0.5 6.5])
xticks(gca, 1:6)
xticklabels(gca, sorted_x_labels)
xtickangle(gca, 45)
set(gca, 'FontName', 'Arial', 'FontSize', 12)
ylabel(gca,'Decoding error (cm)')
box(gca, 'off')



% check wether rmse are singificantly different between areas 
% - bonferroni holm corrected pvalues
rmse(rmse==0) = NaN;

for i = 1:6
    for  j = 1:6
        pval(i,j) = ranksum(rmse(inverse_sorting(i),:), rmse(inverse_sorting(j),:));
    end
    
end

matr =triu(ones(6,6));
matr(eye(6,6)==1) = NaN;
matr(matr== 0)= NaN;
pval(isnan(matr)) = NaN;
[corrected_p, h]=helper.bonf_holm(pval);
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

xticklabels(sorted_x_labels);
yticklabels(sorted_x_labels);


