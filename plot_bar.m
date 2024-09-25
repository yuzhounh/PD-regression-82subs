load bayesOptResults.mat;

% Read feature names
feature_names = readlines('feature_names.txt');

% Get indices of top 10 features by absolute weight value
[~, sortedIndices] = sort(abs(mean_weights), 'descend');
top10Indices = sortedIndices(1:10);

% Get values for top 10 features
top10Values = mean_weights(top10Indices);

% Set color matrix
color_matrix = [1 0.8 0.8; 0.5 0.8 1]; % Light red and light blue

% Create horizontal bar plot
figure;
hold on
for i = 1:10
    if top10Values(i) >= 0
        b_pos = barh(i, top10Values(i), 0.75, 'stacked');
        set(b_pos, 'FaceColor', color_matrix(1,:))
    else
        b_neg = barh(i, -top10Values(i), 0.75, 'stacked');
        set(b_neg, 'FaceColor', color_matrix(2,:))
    end
end
hold off

% Set y-axis labels to feature names
yticks(1:10);
yticklabels(feature_names(top10Indices));
ylabel('Feature Name');

% Set x-axis label
xlabel('Weight Value');

% Set title
title('Top 10 Features by Absolute Weight Value');

% Adjust plot
set(gca, 'YDir', 'reverse', 'FontSize', 10, 'FontName', 'Arial', ...
    'LabelFontSizeMultiplier', 1.3, 'TitleFontSizeMultiplier', 1.4);
axis tight;

% Add legend
legend([b_pos(1), b_neg(1)], {'Positive', 'Negative'}, 'Location', 'southeast');

% Adjust figure size for long labels
fig = gcf;
fig.Position(3) = fig.Position(3) * 1.2;  % Increase width

% Adjust y-axis label position
ax = gca;
ax.YAxis.TickLabelInterpreter = 'none';  % Prevent underscore interpretation as subscript
ax.Position(1) = 0.275;  % Increase left margin for long labels

% Display feature names
disp(feature_names(top10Indices));