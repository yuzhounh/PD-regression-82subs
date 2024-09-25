% Load the brain mask and perform erosion
mask = niftiread('MNI152_T1_2mm_Brain_Mask.nii.gz');

% Perform k erosions
k = 3;
for erosion = 1:k
    eroded_mask = mask;
    [rows, cols, slices] = size(mask);

    for i = 2:rows-1
        for j = 2:cols-1
            for k = 2:slices-1
                if mask(i,j,k) == 1
                    % Check 4-neighborhood in 3D
                    if mask(i-1,j,k) == 0 || mask(i+1,j,k) == 0 || ...
                            mask(i,j-1,k) == 0 || mask(i,j+1,k) == 0
                        eroded_mask(i,j,k) = 0;
                    end
                end
            end
        end
    end
    mask = eroded_mask;
end

% Load weight data
load('bayesOptResults.mat');
weights = mean_weights_brain(:);

% Find top 3 regions by absolute weight
[~, sorted_indices] = sort(abs(weights), 'descend');
top_3_indices = sorted_indices(1:3);

% Load brain parcellation 
parcellation_file = 'Schaefer2018_100Parcels_7Networks_w_SubCortAtlas_MNI152_2mm.nii.gz';
parcellation_img = niftiread(parcellation_file);

% Load MNI templates
mni_template_file = 'MNI152_T1_2mm_Brain.nii.gz';
mni_template_img = niftiread('MNI152_T1_2mm_Brain.nii.gz');

% Load transform matrix
mni_template_info = niftiinfo(mni_template_file);
transform_matrix  = mni_template_info.Transform.T';

% Apply eroded mask to MNI template
masked_mni = mni_template_img;
masked_mni(eroded_mask == 0) = 0;

% Create figure
scale = 0.5;
fig = figure('Position', [100, 100, 14*scale*100, 12*scale*100]);

% Define the number of rows and columns
Nh = 3; % Number of rows
Nw = 3; % Number of columns

% Define the gaps and margins
gap = [0.02 -0.05]; % [vertical, horizontal] gap
marg_h = [0.02 0.02]; % [lower, upper] margin
marg_w = [0.0 0.15]; % [left, right] margin

% Create the tight subplot layout
[ha, pos] = tight_subplot(Nh, Nw, gap, marg_h, marg_w);

% Plot three views (sagittal, coronal, axial) for each region
views = {'sagittal', 'coronal', 'axial'};
for row = 1:3
    index = top_3_indices(row);
    
    % Create image containing only current region
    single_region_data = zeros(size(parcellation_img));
    single_region_data(parcellation_img == index) = weights(index);
    
    % Get center coordinates of current region
    [y, x, z] = ind2sub(size(parcellation_img), find(parcellation_img == index));
    center = round(mean([x, y, z]));
    voxel_coords = [center(2)-1; center(1)-1; center(3)-1; 1]; 
    mni_coords = transform_matrix * voxel_coords;
    
    for col = 1:3
        switch views{col}
            case 'sagittal'
                slice = squeeze(single_region_data(center(2), :, :))';
                bg_slice = squeeze(masked_mni(center(2), :, :))';
                slice = flipud(slice);
                bg_slice = flipud(bg_slice);
                coord_text = sprintf('x = %d', mni_coords(1));
            case 'coronal'
                slice = squeeze(single_region_data(:, center(1), :))';
                bg_slice = squeeze(masked_mni(:, center(1), :))';
                slice = rot90(slice,2);
                bg_slice = rot90(bg_slice,2);
                coord_text = sprintf('y = %d', mni_coords(2));
            case 'axial'
                slice = squeeze(single_region_data(:, :, center(3)))';
                bg_slice = squeeze(masked_mni(:, :, center(3)))';
                slice = rot90(slice,2);
                bg_slice = rot90(bg_slice,2);
                coord_text = sprintf('z = %d', mni_coords(3));
        end
        
        % Plot background image
        axes(ha((row-1)*3 + col));
        ax1 = gca; 
        h1 = imagesc(bg_slice);
        set(h1, 'AlphaData', bg_slice ~= 0);
        colormap(ax1, 'gray');
        axis(ax1, 'off');
        axis(ax1, 'equal');
        hold(ax1, 'on');
        
        % Create new axes object and overlay it on the current axes
        ax2 = axes('Position', get(ax1, 'Position'));
        h2 = imagesc(ax2, slice);  % Plot overlay image on the new axes
        set(h2, 'AlphaData', slice ~= 0);
        colormap(ax2, 'parula');
        axis(ax2, 'off');
        axis(ax2, 'equal');
        set(ax2, 'Color', 'none');  % transparent
        
        % Link the position and range of both axes
        linkaxes([ax1, ax2]);
        
        % Add coordinate text to the bottom left corner
        text_with_outline(ax2, 0.7, 0.1, coord_text, 10);
        
        
        % Add L and R labels for coronal and axial views
        if col > 1  % For coronal and axial views
            text_with_outline(ax2, 0.29, 0.75, 'L', 10);
            text_with_outline(ax2, 0.67, 0.75, 'R', 10);
        end
    end
end

% Add colorbar to the right side of the figure
cb = colorbar('Position', [0.88,0.055,0.025,0.88]);
ylabel(cb, 'Weight', 'FontSize', 14);


function text_with_outline(ax, x, y, string, fontSize)
    delta = 0.004;
    for i = -delta:0.001:delta
        for j = -delta:0.001:delta
            text(ax, x + i, y + j, string, 'Units', 'normalized', ...
                    'VerticalAlignment', 'bottom', 'HorizontalAlignment', ...
                    'left', 'Color', 'white', 'FontSize', fontSize);
        end
    end

    text(ax, x, y, string, 'Units', 'normalized', ...
            'VerticalAlignment', 'bottom', 'HorizontalAlignment', ...
            'left', 'Color', 'black', 'FontSize', fontSize);
end