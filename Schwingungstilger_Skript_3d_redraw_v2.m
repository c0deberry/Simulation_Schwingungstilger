%% Redraw 3d graph

%% Simulation Parameters
c2_values = linspace(3000, 5000, 100);  % 100 equidistant values from 3000 to 5000
stopTimes = 1:1:100;                    % Equidistant stop times from 1 to 100

%% Simulation Loop
figure('Name', 'Simulation of c2 and stopTime', 'NumberTitle', 'off');

% Calculate the minimum and maximum energy values
E_min = min(E_ges_Werte, [], 'all');
E_max = max(E_ges_Werte, [], 'all');

% To avoid issues with logarithms of zero, ensure all values are positive
E_min = max(E_min, 1e-10);  % Ensure E_min is not zero or negative

% Create a colormap for coloring based on energy values
num_colors = 256;  % Number of colors in the colormap
colormap_data = cool(num_colors);  % Use 'cool' colormap with 256 colors

% Loop through each stopTime and c2 value to plot the markers
for tIdx = 1:length(stopTimes)
    stopT = stopTimes(tIdx);

    for cIdx = 1:length(c2_values)
        c2 = c2_values(cIdx);
        energy_value = E_ges_Werte(cIdx, tIdx);

        % Use the logarithm of the energy value for color mapping
        log_energy_value = log10(energy_value);

        % Normalize the logarithmic energy value to a range from 1 to num_colors
        normalized_index = round((log_energy_value - log10(E_min)) / (log10(E_max) - log10(E_min)) * (num_colors - 1)) + 1;

        % Ensure the index is within the valid range
        normalized_index = max(1, min(num_colors, normalized_index));

        % Plot each marker with a color based on the logarithmic energy value
        plot3(stopT, c2, energy_value, '.', ...
            'Color', colormap_data(normalized_index, :), 'MarkerSize', 10);
        hold on;
    end
end

%% Customize the Plot
set(gca, 'ZScale', 'log');  % Set the z-axis to a logarithmic scale for better visualization
grid on;
xlabel('stopTime / s');
ylabel('c2 / N/m');
zlabel('Energie / J');
title('Endenergie für c2 und stopTime with Logarithmic Energy-Based Coloring');
colorbar;  % Add a colorbar to indicate the energy value mapping
colormap(cool(num_colors));  % Set the colormap for the colorbar
hold off;
