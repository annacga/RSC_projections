% the skaggs values were calculated with the function % calculate skaggs

SI          = cell(length(data),1);
SIPC        = cell(length(data),1);
SI_notPC{l} = cell(length(data),1);

for l = 1:length(data)
    SIPC{l} = [];
    
    for i = 1: length(data(l).sessionIDs)

        SI_session = mData(l,i).skaggs(:);
        
        % find all place tuned cells
        pcNo = [];
        for k = 1:length(mData(l,i).LNP_results)
            if ~isempty(find(mData(l,i).LNP_results(k).selected_model == 1)) && isempty(find(mData(l,i).LNP_results(k).selected_model == 5))
                pcNo = [pcNo k];
            end
        end
                
        SIPC{l}      = [SIPC{l}; real(SI_session(pcNo))];
        meanSIPC{l}(i)     = nanmean(real(SI_session(pcNo)));

    end
end


figure()
subplot(1,2,1)
violin({SIPC{2},SIPC{5},SIPC{4},...
    SIPC{3},SIPC{6},SIPC{1}},'facecolor',[0.5 0.5 0.5])
xticklabels({ 'M2', 'PPC', 'Thal', 'ACC', 'V2', 'OFC'})
xticks(gca,[1:6])
ylabel('Skaggs Spatial Information (Bits/AP)')
ax = gca;
ylim([0 12])
ax.FontSize = 12;
ax.FontName = 'Arial';
ax.XColor = [0 0 0];
ax.YColor = [0 0 0];
ax.XLabel.Color = [0 0 0];
ax.YLabel.Color = [0 0 0];
box off


sortVal = [2 5 4 3 6 1];

% calculate all pvals with ranksum 
for i = 1:6
    for j = 1:6
        pval(i,j) = ranksum(meanSIPC{sortVal(i)}',meanSIPC{sortVal(j)}');
    end
end

matr =triu(ones(6,6));
matr(eye(6,6)==1) = NaN;
matr(matr== 0)= NaN;
pval(isnan(matr)) = NaN;
[corrected_p, ~]=helper.bonf_holm(pval);

subplot(1,2,2)
imagesc(triu(corrected_p))
hold on
alpha(matr)

xticks([1:6])
yticks([1:6])
c = colorbar('Limits',[0 0.05]);
caxis([0 0.05])

xticklabels({'M2', 'PPC', 'Thal', 'ACC', 'V2', 'OFC'})
yticklabels({'M2', 'PPC', 'Thal', 'ACC', 'V2', 'OFC'})

ax = gca;
ax.FontSize = 12;
ax.FontName = 'Arial';
ax.XColor = [0 0 0];
ax.YColor = [0 0 0];
ax.XLabel.Color = [0 0 0];
ax.YLabel.Color = [0 0 0];
xtickangle(45)
title('Place tuned axons/cells')


