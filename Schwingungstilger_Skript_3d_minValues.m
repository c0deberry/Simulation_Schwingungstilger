%% Draw optimal c2 over stopTime 

% Check if the necessary variables exist in the workspace
figure
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
    plot3(stopTimes, min_c2_values, min_E_ges_values, '-k', 'LineWidth', 1.1);  % Black line for emphasis
    plot3(stopTimes, min_c2_values-30, min_E_ges_values, 'Color',[0.7 0.7 0.7], 'LineWidth', 0.9);  % Black line for emphasis
    plot3(stopTimes, min_c2_values+30, min_E_ges_values, 'Color',[0.7 0.7 0.7], 'LineWidth', 0.9);  % Black line for emphasis
    grid on
    hold off;

    % Customize the Plot (optional)
    xlabel('stopTime / s');
    ylabel('c2 / N/m');
    zlabel('Energie / J');
    title('Line Across Minimum E_ges Values');
else
    error('Required variables (E_ges_Werte, stopTimes, c2_values) are not available in the workspace.');
end
