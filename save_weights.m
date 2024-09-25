% Load data
load data.mat;
load data_fMRI.mat;
x = [x, x_ReHo];

% Load fixed parameters
load('bayesOptResults.mat', 'bayesOptResults');
C = bayesOptResults.XAtMinObjective.C;
epsilon = bayesOptResults.XAtMinObjective.Epsilon;

% Initialize result storage
n = size(x, 1);
y_pred = zeros(n, 1);
all_weights = zeros(n, size(x, 2)); % Store weights for all folds

% Cross-validation
for i = 1:n
    % Split data
    ix_test = i;
    ix_train = setdiff(1:n, i);
    x_train = x(ix_train, :);
    x_test = x(ix_test, :);
    y_train = y(ix_train);
    
    % Z-score normalization
    [x_train, mu, sigma] = zscore(x_train);
    x_test = (x_test - mu) ./ sigma;
    
    % Train SVR model
    svr_model = fitrsvm(x_train, y_train, 'KernelFunction', 'linear', ...
        'BoxConstraint', C, 'Epsilon', epsilon);
    
    % Predict on test set
    y_pred(i) = predict(svr_model, x_test);
    
    % Store weights
    all_weights(i, :) = svr_model.Beta';
end

% Calculate evaluation metrics
[rmse, r_squared] = calculate_metrics(y, y_pred);

% Calculate mean weights
mean_weights = mean(all_weights, 1);
mean_weights_brain = mean_weights(25:end);

% Output results
fprintf('\nResults:\nC: %f\nEpsilon: %f\nRMSE: %f\nR-squared: %f\n\n', C, epsilon, rmse, r_squared);

% Save results
save('bayesOptResults.mat', 'bayesOptResults', 'C', 'epsilon', 'rmse', 'r_squared', 'mean_weights', 'all_weights', 'mean_weights_brain', 'y', 'y_pred');