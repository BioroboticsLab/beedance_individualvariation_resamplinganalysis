% [M_S ALL] = mean_std_individualized( data )
% computes mean and std of data column data(:,2) for each unique individual 
% given in data(:,1)
% returns individual models in M_S and population mean and std in ALL
function [Q All] = mean_std_individualized( data )
ids = unique( data(:,1) );
Q = [];
% iterate over all IDs
for id = ids'
    % all samples that correspond to current ID
    samples = data( find(data(:,1) == id), 2 );
    % collect mean and std into Q
    if std(samples) ~= 0
        Q = [Q;id mean(samples) std(samples)];
    end
end
All = [mean(data(:,2)) std(data(:,2))]


