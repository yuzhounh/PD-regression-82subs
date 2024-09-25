% Load pre-computed weights and results
load bayesOptResults.mat;

% Create figure and axes
figure1 = figure;
axes1 = axes('Parent', figure1);
hold(axes1, 'on');

% Create scatter plot
scatter(y, y_pred, 'MarkerEdgeColor', 'none', 'MarkerFaceColor', 'flat');

% Perform linear fit
p = polyfit(y, y_pred, 1);
y_fit = polyval(p, y);

% Plot fitted line
plot(y, y_fit, 'LineWidth', 2, 'Color', [1 0 0]);

% Get current axis limits
xlims = xlim;
ylims = ylim;

% Calculate text position (upper left corner)
text_x = xlims(1) + 0.65 * (xlims(2) - xlims(1));
text_y = ylims(1) + 0.28 * (ylims(2) - ylims(1));

% Add text for RMSE and R-squared
text('Parent', axes1, 'Position', [text_x, text_y, 0], ...
    'String', {sprintf('RMSE: %.4f', rmse), sprintf('R-squared: %.4f', r_squared)}, ...
    'VerticalAlignment', 'top', ...
    'BackgroundColor', 'white', ...
    'EdgeColor', 'white', ...
    'FontSize', 12);

% Set labels
ylabel('Predicted MDS-UPDRS Total Score');
xlabel('Actual MDS-UPDRS Total Score');

% Adjust axis
axis(axes1, 'tight');
box(axes1, 'on');
hold(axes1, 'off');