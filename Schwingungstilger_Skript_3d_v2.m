

%% Gegebene Werte
m1 = 500;       % kg
m2 = 20;        % kg
c1 = 100e3;     % N/m
d2 = 15;        % Ns/m
x1_0 = 1;       % Startwert für x1
x2_0 = 0;       % Startwert für x2

%% Simulation Parameters
c2_values = linspace(3000, 5000, 100);  % 100 equidistant values from 3000 to 5000
stopTimes = 1:1:100;                    % Equidistant stop times from 1 to 100

% Initialize arrays to store results
E_ges_Werte = zeros(length(c2_values), length(stopTimes));

%% Simulation Loop
figure('Name', 'Simulation of c2 and stopTime', 'NumberTitle', 'off');

% Create a colormap for consistent coloring
colors = cool(length(stopTimes));  % Use 'jet' colormap for distinct colors

for tIdx = 1:length(stopTimes)
    stopT = stopTimes(tIdx);

    % Arrays to collect c2 and energy values for plotting lines
    c2_points = zeros(1, length(c2_values));
    E_ges_points = zeros(1, length(c2_values));

    for cIdx = 1:length(c2_values)
        c2 = c2_values(cIdx);

        % Perform simulation
        simOut = sim('Schwingungstilger', ...
            'StopTime', num2str(stopT), ...
            'RelTol', '1e-2');

        % Store the final energy value
        E_ges_Werte(cIdx, tIdx) = simOut.E_ges.Data(end);

        % Collect the data points for this stopT
        c2_points(cIdx) = c2;
        E_ges_points(cIdx) = E_ges_Werte(cIdx, tIdx);

        % Plot each marker using the unique color for this stopT
        plot3(stopT, c2, E_ges_Werte(cIdx, tIdx), '.', ...
            'Color', colors(tIdx, :), 'MarkerSize', 10);
        drawnow
        hold on;

    end

    % Draw a line connecting the markers for this stopT
   % plot3(repmat(stopT, 1, length(c2_values)), c2_points, E_ges_points, '-', ...
    %    'Color', colors(tIdx, :), 'LineWidth', 0.9);  % LineWidth slightly greater than grid lines
end

%% Spline Interpolation Across c2 Values for Each stopTime
fine_c2_values = linspace(3000, 5000, 200);   % Finer c2 grid for smoother interpolation
%interp_colors = cool(length(stopTimes));    % New colormap for interpolated lines

for tIdx = 1:length(stopTimes)
    % Interpolate across c2 values for this specific stopTime
    interp_E_ges_c2 = makima(c2_values, E_ges_Werte(:, tIdx), fine_c2_values);

    % Plot the interpolated line across c2 for this stopTime
    plot3(repmat(stopTimes(tIdx), 1, length(fine_c2_values)), fine_c2_values, interp_E_ges_c2, '-', ...
        'Color', colors(tIdx, :), 'LineWidth', 0.9);  % LineWidth for better visibility
end

%% Spline Interpolation Across stopTimes for Each c2 Value
fine_stopTimes = linspace(1, 100, 200);       % Finer stopTime grid for smoother interpolation
interp_colors_c2 = cool(length(c2_values)); % Different colormap for clarity

for cIdx = 1:length(c2_values)
    % Interpolate across stopTimes for this specific c2 value
    interp_E_ges_stopT = makima(stopTimes, E_ges_Werte(cIdx, :), fine_stopTimes);

    % Plot the interpolated line across stopTimes for this c2 value
    plot3(fine_stopTimes, repmat(c2_values(cIdx), 1, length(fine_stopTimes)), interp_E_ges_stopT, '-', ...
        'Color', interp_colors_c2(cIdx, :), 'LineWidth',0.9);  % LineWidth for visibility
end

%% Customize the Plot
set(gca, 'ZScale', 'log');
grid on;
xlabel('stopTime / s');
ylabel('c2 / N/m');
zlabel('Energie / J');
title('Endenergie für c2 und stopTime with Spline Interpolated Lines');
colorbar;
hold off;
