%% Draw black line across minimum values in 3d

% Check if the necessary variables exist in the workspace
if exist('E_ges_Werte', 'var') && exist('stopTimes', 'var') && exist('c2_values', 'var')
    % Initialize arrays to store the minimum values
    min_E_ges_values = zeros(1, length(stopTimes));
    min_c2_values = zeros(1, length(stopTimes));

    % Extract the minimum energy values and corresponding c2 values
    for tIdx = 1:length(stopTimes)
        [min_E_ges_values(tIdx), minIdx] = min(E_ges_Werte(:, tIdx));
        min_c2_values(tIdx) = c2_values(minIdx);
    end

    % Plot the line connecting the lowest energy values
    hold on;  % Keep the existing plot
    plot3(stopTimes, min_c2_values, min_E_ges_values, '-k', 'LineWidth', 2);  % Black line for emphasis
    hold off;

    % Customize the Plot (optional)
    xlabel('stopTime / s');
    ylabel('c2 / N/m');
    zlabel('Energie / J');
    title('Line Across Minimum E_ges Values');
else
    error('Required variables (E_ges_Werte, stopTimes, c2_values) are not available in the workspace.');
end
