function smoothMatrix = smoothParams(param,beta)
    % smoothing penalty
    numParam = numel(param);
    D1  = spdiags(ones(numParam,1)*[-1 1],0:1,numParam-1,numParam);
    DD1 = D1'*D1;
    smoothMatrix = beta*0.5*param'*DD1*param;
end