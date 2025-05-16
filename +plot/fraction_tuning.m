
col =  [215,223,225;
    175 200 211;
    80 106 139;
    142 175 174;
    230 151 64;
    218 57 38]./255;


prct_all = cell(1);
prct_all_threeCategories = cell(1);
prct_Motor = cell(1);

for l = 1:length(areas)
    
    for f = 1: length(data(areas(l)).sessionIDs)
        
        cue_cells = 0;
        place_cells = 0;
        speed_cells = 0;
        acceleration_cells = 0;
        lick_cells = 0;
        not_tuned_cells = 0;
        
        for i = 1:length(mData(areas(l),f).LNP_results)
            
            if ~isempty(find(mData(areas(l),f).LNP_results(i).selected_model == 5, 1))
                cue_cells = cue_cells+1;
            else
                if ~isempty(find(mData(areas(l),f).LNP_results(i).selected_model == 1, 1))
                    place_cells = place_cells+1; end
                if ~isempty(find(mData(areas(l),f).LNP_results(i).selected_model == 2, 1))
                    speed_cells =speed_cells+1; end
                if ~isempty(find(mData(areas(l),f).LNP_results(i).selected_model == 3, 1))
                    acceleration_cells = acceleration_cells+1; end
                if ~isempty(find(mData(areas(l),f).LNP_results(i).selected_model == 4, 1))
                    lick_cells= lick_cells+1; end
                if isnan(mData(areas(l),f).LNP_results(i).selected_model)
                    not_tuned_cells = not_tuned_cells+1; end
            end
        end
        
        
        sumval = not_tuned_cells+place_cells+speed_cells+acceleration_cells+lick_cells+cue_cells;
        prct_session = 100*[not_tuned_cells place_cells speed_cells acceleration_cells lick_cells cue_cells]./length(mData(areas(l),f).LNP_results);
        prct_all{l}(f,:) = prct_session;
        
        
        % we are mainly interested in no of place tuned cells: therefor we
        % merge all other categories
        prct_session_threeCategories     = 100*[not_tuned_cells place_cells speed_cells+acceleration_cells+lick_cells cue_cells]./length(mData(areas(l),f).LNP_results);
        prct_all_threeCategories{l}(f,:) =  prct_session_threeCategories;
        prct_Motor{l}(f,:)               = 100*[speed_cells acceleration_cells lick_cells]./length(mData(areas(l),f).LNP_results);
        
    end
    
    fig = figure();
    subplot(1,2,1)
    meanvals = nanmean(prct_all_threeCategories{l},1);
    meanstd = nanstd(prct_all_threeCategories{l},1);
    for m = 2: length(meanvals)
        hold on
        scatter(m-1,meanvals(m), 70,col(m,:));
        errorbar(m-1,meanvals(m),meanstd(m)/sqrt(length(data(l).sessionIDs)),'Color',col(m,:),'LineWidth',1)
    end
    
    xlim([0.5 3.5])
    xticks([1:3])
    xticklabels({'P','M','C'})
    ylim([0 50])
    ylabel('Tuning (%)')
    set(gca,'FontName','Arial','FontSize',12)
    title(data(areas(l)).area)
    
    subplot(1,2,2)
    meanvals = nanmean(prct_Motor{l},1);
    meanstd = nanstd(prct_Motor{l},1);
    for m = 1: length(meanvals)
        hold on
        scatter(m,meanvals(m), 70,col(3+m,:));
        errorbar(m,meanvals(m),meanstd(m)/sqrt(length(data(l).sessionIDs)),'Color',col(3+m,:),'LineWidth',1)
    end
    ylim([0 15])
    xlim([0.5 3.5])
    xticks([1:3])
    xticklabels({'S','A','L'})
    ylabel('Tuning (%)')
    set(gca,'FontName','Arial','FontSize',12)
    title(data(areas(l)).area)
end