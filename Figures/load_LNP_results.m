

LNP_dirct = '/Users/annachristinagarvert/UIO Physiology Dropbox Dropbox/Lab Data/Michele Gianatti/Data&Analysis/Paper/LNP';

for f = 1:length(data)
    for i = 1:length(data(f).sessionIDs)
        load(fullfile(LNP_dirct,data(f).area,strcat(data(f).sessionIDs{i},'.mat')))
        mData(f,i).LNP_results = results;
    end
end

