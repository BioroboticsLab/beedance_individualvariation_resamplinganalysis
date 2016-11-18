% [M_S ALL] = mean_std_individualized( data )
% computes mean and std of data column data(:,2) for each unique individual 
% given in data(:,1)
% returns individual models in M_S and population mean and std in ALL
% if bool_centerdata is true, then all values in data will be made relative
% to the population mean
function [Q All] = mean_std_individualized( data, bool_centerdata)
ids = unique( data(:,1) );
fprintf('%d unique ids found.\n', length(ids));
Q = [];

% determine population mean for centering data
if bool_centerdata
    population_mean = mean(data(:,2));
else
    population_mean = 0;
end

% iterate over all IDs
for id = ids'
    % all samples that correspond to current ID
    samples = data( find(data(:,1) == id), 2 );
    % collect mean and std into Q
    if std(samples) ~= 0
        Q = [Q;id mean(samples)-population_mean std(samples) size(samples,1)];
    end
end

All = [mean(data(:,2)) std(data(:,2))];
fprintf('%d ids with std > 0 found.\n', size(Q, 1));

