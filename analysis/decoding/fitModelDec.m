function lambda = fitModelDec(signal, pos,beta)

% create state matrix
X = zeros(length(pos),length(unique(pos)+1));
for j = 1:length(pos); X(j,pos(j)+1) = 1; end;  X(:,1) = 1;

% initialize firing rate lambda
lambda = zeros(size(signal,1),max(pos));
% fit parameters 
for i = 1:size(signal,1)
     
        opts = optimset('Gradobj','off','Hessian','off','Display','off');

        init_param         = (X'*signal(i,:)')/sum(signal(i,:));

        init_param(isinf(init_param)) = 0; init_param(isnan(init_param)) = 0;
        
        lossfun           = @(params) lnPoissonModel(params,beta, X, signal(i,:)');
        param             = fminunc(lossfun,init_param,opts);
        
        lambda         = exp(X * param');     
end

end