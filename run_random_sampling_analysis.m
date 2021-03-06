% [M_sum S_sum] = run_random_sampling_analysis(GaussianModels)
% samples from a number of Gaussian pdfs
% expected value (the "correct" answer) is 0
% returns accuracy as mean deviation from 0
% and precision as std of samples
function [M_sum S_sum S_all] = run_random_sampling_analysis(GaussianModels)
% number of sampling steps per combination 
N_samples   = 5000;
% number of different, unique individuals to sample from 
N_indiv     = 10;
% number of dances to sample from the given set of individuals
N_dances    = 10;

% convenience renaming 
Q           = GaussianModels;
% number of models
N           = size(Q, 1);
% M holds accuracy for one sample iteration
% and for each combination of #individuals and #dances
M           = zeros(N_indiv, N_dances);
% M_sum is going to hold the mean accuracy over all resampling iterations 
M_sum       = zeros(N_indiv, N_dances);
% S holds precision for all parameter combinations
S           = zeros(N_indiv, N_dances);
% M_sum is going to hold the mean precision over all resampling iterations
S_sum       = zeros(N_indiv, N_dances);
% A holds all resampled data for global statistics
A           = nan([N_indiv N_dances N_samples]);

for n_samples = 1 : N_samples
    for n_individuals = 1 : N_indiv 
        % chose random set of individuals from whom a variable number of
        % dances is sampled
        ids = randsample(1:N, n_individuals, 1);
        % we will collect samples in Y
        Y   = [];
        for n_dances = 1 : N_dances
            % sample every individual from the random set
            % once we have that, draw random samples
            if n_dances < n_individuals
                id = n_dances;
            else
                % chose a random individual from the random subset chosen before
                id = randsample(1:n_individuals, 1, 1);
            end
                
            mu      = Q(ids(id), 2);
            sigma   = Q(ids(id), 3);
            
            % draw sample and collect it in temporary list 
            % for later statistics
            Y       = [Y drawSampleFromGaussian(mu, sigma, 1)];
            
            % we reuse the previous samples 
            % therewith simulating a sequence of invidual samplings 
            if n_dances >= n_individuals
                % accuracy: deviation from 0
                M(n_individuals, n_dances) = abs( mean(Y) );
                % precision: std of samples
                S(n_individuals, n_dances) = std(Y);
            end
        end   
    end

    
    % remove lower triangular measurements
    M(find(tril(ones(size(S_sum)),-1))) = nan;
    S(find(tril(ones(size(S_sum)),-1))) = nan;

    % integrate and store this iteration's measurements
    M_sum = M_sum + M;
    S_sum = S_sum + S;
    A(:, :, n_samples) = M;
end

% S_all holds standard deviation of accuracy across trials
S_all = std(A, 0, 3);

M_sum = M_sum / N_samples;   
S_sum = S_sum / N_samples;   

% plot curves
figure
plot(M_sum');
figure
plot(S_sum');
figure
plot(S_all');


function R = drawSampleFromGaussian(mu, sigma, n_samples) 
R =     repmat( mu,     n_samples, 1 ) + ...
        repmat( sigma,  n_samples, 1 ) .* randn(n_samples, 1); 