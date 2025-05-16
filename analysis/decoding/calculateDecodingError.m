function rmse  = calculateDecodingError(predPos, realPos)

    maxval = max(realPos);
    predError = zeros(length(realPos),1);
    for i = 1:length(realPos)
        predError(i) = abs(realPos(i)-predPos(i));
        if predError(i) > maxval/2 && realPos(i) > predPos(i)
            predError(i) = abs(maxval-realPos(i)+predPos(i));
        elseif predError(i) > maxval/2 && realPos(i) < predPos(i)
            predError(i) = abs(maxval-predPos(i)+realPos(i));
        end
    end

    rmse = mean(predError);

end