
%% Simulation Parameters
c2_values = linspace(3000, 5000, 100);  % 100 equidistant values from 3000 to 5000
stopTimes = 1:1:100;                    % Equidistant stop times from 1 to 100



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


       % Collect the data points for this stopT
        c2_points(cIdx) = c2;
        E_ges_points(cIdx) = E_ges_Werte(cIdx, tIdx);

        % Plot each marker using the unique color for this stopT
        plot3(stopT, c2, E_ges_Werte(cIdx, tIdx), '.', ...
            'Color', colors(tIdx, :), 'MarkerSize', 10);
        hold on;

    end

end


%% Customize the Plot
%set(gca, 'ZScale', 'log');
grid on;
xlabel('stopTime / s');
ylabel('c2 / N/m');
zlabel('Energie / J');
title('Endenergie für c2 und stopTime');
hold off;
