[N_individuals, N_dances] = size(M_sum)

EXPORT = nan(N_individuals, 3*N_dances);
EXPORT(:, 1:3:end) = M_sum;
EXPORT(:, 2:3:end) = S_sum;
EXPORT(:, 3:3:end) = S_all;

csvwrite('results_resampling_analysis.csv', EXPORT)