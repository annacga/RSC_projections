

for l = 1:length(data)-2
    placeCellSignal = []; %width{l} = [];  no_PF{l} = [];
    for i = 1: length(data(l).sessionIDs)
        width{l}{i}  = [];
        no_PF{l}{i}  = [];
        sData = mData(l,i).sData;
        
        pcNo = [];
        for k = 1:length(mData(l,i).LNP_results)
            if ~isempty(find(mData(l,i).LNP_results(k).selected_model == 1)) && isempty(find(mData(l,i).LNP_results(k).selected_model == 5))
                pcNo =   [pcNo k];
            end
        end
        
        if ~isempty(pcNo)
            for r = 1:length(pcNo)
                signal_matrix = helper.splitInTrialsPos(sData.imdata.roiSignals(2).dff, sData,pcNo(r));
                tuning_curve  = nanmean(signal_matrix,1);
                
                halfMaximum = min(tuning_curve)+(max(tuning_curve)-min(tuning_curve))/2;
                
                idxVals =  find(tuning_curve > halfMaximum);
                widthTemp = [];
                
                m = 1;  f = 1; widthTemp{f} = 1; tempM = idxVals(1);
                while m < length(idxVals)
                    if (idxVals(m+1) - idxVals(m))>1
                        widthTemp{f} = idxVals(m)-tempM+1;
                        tempM = idxVals(m+1);
                        f = f+1;
                     end
                    m = m+1;
                end
                widthTemp{f} = idxVals(m)-tempM+1;
                
                % correct for circularity
                if length(widthTemp) >= 2
                    if ~isempty(find(idxVals == 1)) && ~isempty(find(idxVals == 78))
                        widthTemp{1} = widthTemp{1}+widthTemp{end};
                        widthTemp(end) = [];
                    end
                end
                
                widthTemp2 =cell2mat(widthTemp);

                widthTemp2(widthTemp2 < 5) = [];
                width{l}{i} = [width{l}{i} widthTemp2];
                no_PF{l}{i}(end+1) =  length(widthTemp2);
 
            end
        end
        
    end
end



for i = 1:length(data)-2
    for k = 1:length(width{i})
        widthMean{i}(k) = nanmean(width{i}{k});
    end
    widthMeanArea(i) = nanmean(widthMean{i});
    widthSEDArea(i) = nanstd(2*widthMean{i})/sqrt(length(width{i}));
end
        

fig_h = figure();
for i = 1:length(data)-2
    scatter(i,2* widthMeanArea(i),80, 'k', 'filled') ;hold on
    errorbar(i, 2*widthMeanArea(i),widthSEDArea(i),'LineWidth',1.5, 'Color','k')
    
end
    
xticklabels(gca,{'OFC', 'M2', 'ACC', 'Thal','PPC', 'V2'})
xticks(gca,[1:6])
xlim(gca,[0 7])
ylabel('Place field width(cm)')
ylim(gca,[0 100])   
set(gca,'FontName','Arial','FontSize',12)

    