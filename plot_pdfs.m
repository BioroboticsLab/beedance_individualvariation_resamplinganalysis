% plot_pdfs(GaussianModels)
% plots n gaussian pdfs given in input n x 2 matrix (mean and std)
function plot_pdfs(GaussianModels)
% plot borders
xmin    = min(GaussianModels(:, 2) - 3*GaussianModels(:, 3));
xmax    = max(GaussianModels(:, 2) + 3*GaussianModels(:, 3));

x       = linspace(xmin, xmax, 500);

N = size(GaussianModels, 1);
close all
for i = 1 : N
    G = normpdf(x, GaussianModels(i,2), GaussianModels(i,3));
    plot(x, G, 'Color', [i 1 N-i+1]/N)
    hold on
end