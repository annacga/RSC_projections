
decoding_onlyPC_dirct = '/Users/annachristinagarvert/UIO Physiology Dropbox Dropbox/Lab Data/Michele Gianatti/Data&Analysis/Paper/decoding/decodingOnlyPC/';

for f = 1:length(data)
    for i = 1:length(data(f).sessionIDs)
        load(fullfile(decoding_onlyPC_dirct,data(f).area,data(f).sessionIDs{i},'d_data_varN.mat'))
        mData(f,i).d_data_onlyPC = d_data_varN;
    end
end

decoding_dirct = '/Users/annachristinagarvert/UIO Physiology Dropbox Dropbox/Lab Data/Michele Gianatti/Data&Analysis/Paper/decoding/decodingVsNoCells/';

for f = 1:length(data)
    for i = 1:length(data(f).sessionIDs)
        load(fullfile(decoding_dirct,data(f).area,data(f).sessionIDs{i},'d_data_varN.mat'))
        mData(f,i).d_data = d_data_varN;
    end
end


