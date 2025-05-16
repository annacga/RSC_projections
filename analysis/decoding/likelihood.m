
function likelihood = likelihood(signal,lambda)
% lambda1(n,:) = b(n)+g(n)*exp(k(n)*cos(x-mu(n)));
% calculate  P(spike(i)| time(i)) 

prob = zeros(size(lambda)); 
likelihood = zeros(size(signal,2),size(lambda,2));

for t = 1: size(deconv,2) 
    % select signal for one time bin
    frTemp = repmat(signal(:,t),1,size(lambda,2));
    
    for j = 1:size(frTemp,2)
        for i = 1:size(frTemp,1)
            %prob. of the time points signals (separate per neuron) given position
            prob(i,j) = exp(frTemp(i,j) * log(lambda(i,j)) - lambda(i,j) - gammaln(frTemp(i,j)+1)); 
        end
    end
    
    % probability signal(each time point) given position, multiply over
    % neurons -> here we assume statistical independence
    likelihood(t,:) = prod(prob); %Prob. of all signals (all neurons) given pos
end

% normalisation
likelihood = likelihood./nansum(likelihood,2);

end