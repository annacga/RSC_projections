
decoding_skaggs = '';

for f = 1:length(data)
    for i = 1:length(data(f).sessionIDs)
        load(fullfile(decoding_skaggs,data(f).area,data(f).sessionIDs{i},'SI_session.mat'))
        mData(f,i).skaggs = SI_session;
    end
end

