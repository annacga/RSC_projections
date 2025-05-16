
% calculate 
rmse= [];

for r =     1:6 %length(area)
    f = 1;
    for l = 1:length(data(r).sessionIDs)
        
        pcNo = 0;
        for p = 1:length(mData(r,l).LNP_results )
            if ~isempty(find(mData(r,l).LNP_results(p).selected_model  == 1))
                 pcNo = pcNo +1;
            end
        end
        
       % there has to be a least one pc
       if pcNo >  0

            predPos = mData(r,l).d_data_onlyPC(end).iter{1, mData(r,l).d_data_onlyPC(end).medianTestFold}.predPos_test;
            realPos = mData(r,l).d_data_onlyPC(end).iter{1,  mData(r,l).d_data_onlyPC(end).medianTestFold}.realPos_test;

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

            rmse(r,f) = nanmean(predError); 
            f = f+1;
       end
    end
    
end

rmse(rmse==0) = NaN;

%% decoding errors for each area
fig_3_e = figure();

sorting = [6 1 3 4 2 5]; 
for r = 1:6
    for l = 1:size(rmse,2)
        scatter(sorting(r),rmse(r,l),70, [0.5 0.5 0.5]);
        hold on
    end
    scatter(sorting(r),nanmean(rmse(r,:)),70, [0 0 0],'filled');
    errorbar(sorting(r),nanmean(rmse(r,:)),nanstd(rmse(r,:))/sqrt(sum(~isnan(rmse(r,:)))),'k','LineWidth',1.5);
end

xlim([0 7])
ylim([5 55])
xticks([1:6])
ax = gca;
ax.FontSize = 12;
ax.FontName = 'Arial';
ax.XColor = [0 0 0];
ax.YColor = [0 0 0];
ax.XLabel.Color = [0 0 0];
ax.YLabel.Color = [0 0 0];
xticklabels({'M2','PPC','ACC', 'Thal', 'V2M','OFC'})


sorting_inverse =[2 5 3 4 6 1];

for i = 1:6
    for j = 1:6
        pval(i,j) = ranksum(rmse(sorting_inverse(i),:),rmse(sorting_inverse(j),:));
    end
end

matr =triu(ones(6,6));
matr(eye(6,6)==1) = NaN;
matr(matr== 0)= NaN;
pval(isnan(matr)) = NaN;
[corrected_p, h]=helper.bonf_holm(pval);
 

%% plot p values
fig_3_f = figure();
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

% 