
function predPos = calcMaxLikelihoodPos(prior,likelihood, binGaps)

    predPos           = nan(size(likelihood,1),1);
    posterior_NotNorm = nan(size(likelihood));
    posterior         = nan(size(likelihood));

    for t = 1:size(likelihood_train,1)
        posterior_NotNorm(t,:)         = likelihood(t,:).*prior;
        posterior(t,:)                 = posterior_NotNorm(t,:)./nansum(posterior_NotNorm(t,:));

        [~, maxInd]                    = nanmax(posterior(t,:));
        predPos(t)                     = binGaps(maxInd);
    end

end