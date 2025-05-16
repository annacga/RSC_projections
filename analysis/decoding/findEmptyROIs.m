function data = findEmptyROIs(data)

    deleteCell = [];
    for n = 1:length(data.cellIdx)
        if isempty(find(data.trainSignal(n,:) ~= 0, 1))|| isempty(find(data.testSignal(n,:)~= 0, 1))||...
                length(find(isnan(data.trainSignal(n,:)) == 1)) == length(find(isnan(data.trainSignal(n,:)) ...
            || length(find(isnan(data.testSignal(n,:)) == 1)) == length(find(isnan(data.testSignal(n,:))
            deleteCell(end+1) = n;
        end
    end

    data.deconvTrain(deleteCell,:) = []; data.deconvTest(deleteCell,:) = [];
    data.cellIdx(deleteCell) = [];

end