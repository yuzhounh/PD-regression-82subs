function [rmse, r_squared] = calculate_metrics(y, y_pred)

% calculate rmse
rmse = sqrt(mean((y - y_pred).^2));

% calculate r_squared
y_mean = mean(y);
ss_res = sum((y - y_pred).^2);
ss_total = sum((y - y_mean).^2);
r_squared = 1 - (ss_res / ss_total);
