% Load data
load data.mat
load data_fMRI.mat

% Combine demographic, clinical, and imaging features (ReHo)
x = [x, x_ReHo];

% Define optimization variables
optimVars = [
    optimizableVariable('C', [1e-3, 1e3], 'Transform', 'log')
    optimizableVariable('Epsilon', [1e-3, 1e3], 'Transform', 'log')
];

% Define objective function
objectiveFunction = @(params) svr_objective(params, x, y);

% Run Bayesian optimization
bayesOptResults = bayesopt(objectiveFunction, optimVars, ...
    'IsObjectiveDeterministic', false, ...
    'AcquisitionFunctionName', 'expected-improvement-plus', ...
    'MaxObjectiveEvaluations', 100);

% Output best results
fprintf('\nBest parameters\nC: %f\nEpsilon: %f\n\nBest objective function value\nRMSE: %f\n', ...
    bayesOptResults.XAtMinObjective.C, ...
    bayesOptResults.XAtMinObjective.Epsilon, ...
    bayesOptResults.MinObjective);

% Save results
save('bayesOptResults.mat', 'bayesOptResults');

% Define SVR objective function
function [rmse, con] = svr_objective(params, x, y)
    C = params.C;
    epsilon = params.Epsilon;
    
    n = size(x, 1);
    y_pred = zeros(n, 1);
    
    for i = 1:n
        % Split data for leave-one-out cross-validation
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
    end
    
    % Calculate evaluation metric
    [rmse, ~] = calculate_metrics(y, y_pred);
    
    con = [];  % No constraints
end