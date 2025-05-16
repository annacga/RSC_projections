load_all_data()


for r =     1:length(area)
    count_area(r) = 0;
    for l = 1:length(file{r})
        
       sData = load(fullfile(load_sData_dirct,area{r},'/',file{r}{l},'/final_sData.mat'));
       count_area(r) = count_area(r)+size(sData.imdata.roiSignals(2).dff,1);

    end
    
end
