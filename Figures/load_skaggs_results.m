
decoding_skaggs = '/Users/annachristinagarvert/UIO Physiology Dropbox Dropbox/Lab Data/Michele Gianatti/Data&Analysis/Paper/Skaggs/';

for f = 1:length(data)
    for i = 1:length(data(f).sessionIDs)
        load(fullfile(decoding_skaggs,data(f).area,data(f).sessionIDs{i},'SI_session.mat'))
        mData(f,i).skaggs = SI_session;
    end
end

