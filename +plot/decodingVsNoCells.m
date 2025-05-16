rmse_all    = NaN(length(data(area).sessionIDs),1);
cell_no     = cell(length(data(area).sessionIDs),1);
cellsSpaced = NaN(length(data(area).sessionIDs),1);
lengthCells = NaN(length(data(area).sessionIDs),1);

f =1;
for g = 1: length(data(area).sessionIDs)
        
    % read out decoding error
    rmse_session =  NaN(1,length(mData(area,f).d_data)); 
    if length(mData(area,g).d_data)>1
        for i = 1:length(mData(area,g).d_data)
            cell_no{f}(i)   = length(mData(area,g).d_data(i).iter{1, mData(area,g).d_data(i).medianTestFold}.cellIdx);
            rmse_session(i) = mData(area,g).d_data(i).meanRMSE_test;
        end

        % prepare a matrix that contains all decoding errors
        maxLength       = max([length(rmse_session),size(rmse_all,2)]);
        rmse_all        = [rmse_all NaN(size(rmse_all,1), maxLength-size(rmse_all,2))];
        rmse_session    = [rmse_session NaN(1,maxLength-length(rmse_session))];

        rmse_all(f,:)   = rmse_session;

        cellsSpaced(f)  = 10*round(cell_no{f}(2)/10);
        lengthCells(f)  = length(cell_no{f});
        f =f+1;
    end

end


% make sure that the spacing of no of cells used for decoding is the
% same for all sessions (starts at 10 and is then spaced with 20)
% this is necessary because for some sessions we calculated the decoding erroor with spacing of 10
% cells
if ~isempty(find(cellsSpaced == 30, 1)) 
    cellsSpacedShort = find(cellsSpaced == 20);
    lengthCells(cellsSpacedShort) =  ceil(lengthCells(cellsSpacedShort)/2);
    for f = 1:length(cellsSpacedShort)
        rmse_all(cellsSpacedShort(f),2:2:end) = NaN;
    end
end

[maxCells, maxCellIdx]= max(lengthCells);
cellNoSum = cell_no{maxCellIdx};

% find idx from which there is only one session left, these will not be use
noNan = NaN(size(rmse_all,2),1);
for m = 1:size(rmse_all,2)
    noNan(m) = length(find(isnan(rmse_all(:,m))));
end

idx_singleSesssion = find(noNan == size(rmse_all,1)-1);
rmse_all(:,idx_singleSesssion) = [];
cellNoSum(idx_singleSesssion) = [];
