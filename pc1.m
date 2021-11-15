function [N_eigs_to_keep, primary_component] = pc1(filtered)
        % [N_eigs_to_keep, primary_component] = pc1(filtered)
        % N_eigs_to_keep: is the number of eigs values to keep 
        % priamary_component: is the compressed version of the raw data
        % filtered is the filtered data produced by the preprocess_marker_data
        % function 
N = size(filtered, 1); % The number of channels
T = size(filtered, 2);
fs = 500;%<--changes here 
% Remove the channel means
filtered_demeaned = filtered - mean(filtered, 2) * ones(1, size(filtered, 2));
Cx = cov(filtered_demeaned');
[V, D] = eig(Cx, 'vector');

% Check signal evergy
x_var = var(filtered_demeaned, [], 2); % Formula 1

% Decorrelate the channels
y = V' * filtered_demeaned;

% Check total energy match
x_total_energy = sum(x_var);

% partial energy in eigenvalues
x_partial_energy = 100.0 * cumsum(D(end : -1 : 1))./x_total_energy;

% set a cut off threshold for the eigenvalues
th = 99.0;
N_eigs_to_keep = find(x_partial_energy <= th, 1, 'last');

% find a compressed version of the raw data using primary component
% analysis
primary_component = V(:, N - N_eigs_to_keep + 1 : N) * y(N - N_eigs_to_keep + 1 : N, :);
% t = (0 : T - 1)/fs;
% for ch = 1 : N
%     figure
%     hold on
%     plot(t, filtered(ch, :));
%     plot(t, primary_component(ch, :));
%     legend(['channel ' num2str(ch)], 'compressed');
%     grid
% end

% % Run JADE
% lastEigJADE = N; % PCA stage
% W_JADE = jadeR(filtered, lastEigJADE);
% primary_component2 = W_JADE * filtered;


end 
