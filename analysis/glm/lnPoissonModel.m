function logL = lnPoissonModel(param,b,X,Y)
% X: covariate state matrix
% Y: signal

nonlinear = @(x) exp(x) ;
lambda = nonlinear(X * param); % firing rate

% compute smoothing of parameters
smoothVal = smoothParams(param,b);

% compute f, the gradient, and the hessian 
logL       = sum(lambda-Y(:).*log(lambda)) + smoothVal;

end

    