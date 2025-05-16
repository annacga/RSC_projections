
  


%% plot fraction of place tuned axons
fig_2_d = figure();

sorting = [3 5 4 2 6 1]; % this sorts the areas with increasing place tuned fraction
for l = 1:6
        for i = 1: length(data(l).sessionIDs)     
               pcNo = 0;
               for k = 1:length(mData(l,i).LNP_results)
                    if ~isempty(find(mData(l,i).LNP_results(k).selected_model == 1, 1))
                        pcNo = pcNo +1;
                    end
               end
 
               pc{l}(i) = 100*pcNo/length(mData(l,i).LNP_results);
               scatter(sorting(l),  pc{l}(i), 70,[0.5 0.5 0.5]);%col(l,:))
               hold on
        end
    PCall(l) = nanmean(pc{l});
    PCallErr(l) = nanstd(pc{l})/sqrt(length(pc{l}));
    
    scatter(sorting(l),PCall(l),70,[0 0 0],'filled')
    errorbar(sorting(l),PCall(l),PCallErr(l),'k','LineWidth',1.5)
end

xticks([1:6])
xlim([0.5 6.5])    
set(gca,'FontName','Arial','FontSize',12)
xticklabels({'V2','Thal','OFC','ACC','M2','PPC'})
ylabel('Position tuned axon (%)')

%% check p values figure 2 e
sorting_inverse = [6 4 1 3 2 5];

for i = 1:6
    for j = 1:6
        pval(i,j) = ranksum(pc{sorting_inverse(i)},pc{sorting_inverse(j)});
    end
end

matr =triu(ones(6,6));
matr(eye(6,6)==1) = NaN;
matr(matr== 0)= NaN;
pval(isnan(matr)) = NaN;
[corrected_p, h]=helper.bonf_holm(pval);

 
fig_2_e = figure();
imagesc(triu(corrected_p))
hold on
alpha(matr)

xticklabels({'V2','Thal','OFC','ACC','M2', 'PPC'})
yticklabels({'V2','Thal','OFC','ACC','M2', 'PPC'})


c = colorbar('Limits',[0 0.05]);
caxis([0 0.05])
ax = gca;
ax.FontSize = 12;
ax.FontName = 'Arial';
ax.XColor = [0 0 0];
ax.YColor = [0 0 0];
ax.XLabel.Color = [0 0 0];
ax.YLabel.Color = [0 0 0];

 