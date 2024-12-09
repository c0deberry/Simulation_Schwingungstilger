%% Serch optimum with fminsearch
clear, close all;

%% Gegebene Werte
m1 = 500;       % kg
m2 = 20;        % kg
c1 = 100e3;     % N/m
d2 = 15;        % Ns/m
x1_0 = 1;       % Startwert für x1
x2_0 = 0;       % Startwert für x2

%% Einstellungen
relTol = '1e-6';    % relative Toleranz, über 1e-5 werden Ergebnisse schlecht

%% Initial Values and Bounds for Optimization
c2_initial = 3650;           % Initialer Wert für c2
stopTime_initial = 20;       % Initialer Wert für stopTime
initial_guess = [c2_initial, stopTime_initial];  % Initial guess for both parameters
%initial_guess = c2_initial ;

c2_min = 3600;               % Untere Grenze für c2
c2_max = 3700;               % Obere Grenze für c2
stopTime_min = 10;           % Untere Grenze für stopTime
stopTime_max = 50;           % Obere Grenze für stopTime

%% Objective Function
% Define the objective function to minimize energy
objectiveFunction = @(params) simulateEnergy(params, relTol, c1, x1_0, x2_0);

% Use fminsearch to find the optimal c2 and stopTime
options = optimset('Display', 'iter');  % Set options to display iteration information
[optimal_params, E_min] = fminsearch(objectiveFunction, initial_guess, options);

% Extract the optimized values
c2_opt = optimal_params(1);
stopTime_opt = optimal_params(2);

%% Display Results
fprintf('\n\nOptimales c2: %f', c2_opt);
fprintf('\nOptimales stopTime: %f', stopTime_opt);
fprintf('\nMinimale Energie: %f\n', E_min);

%% Function to Simulate Energy
function E_end = simulateEnergy(params, relTol, c1, x1_0, x2_0)
    % Extract parameters
    c2 = params(1);
    stopTime = params(2);
%stopTime = 20;
    % Set c2 as a variable in the MATLAB workspace
    assignin('base', 'c2', c2);  % Assign c2 to the base workspace

    % Perform the simulation using the given c2 and stopTime values
    simOut = sim('Schwingungstilger', ...
        'StopTime', num2str(stopTime), ...
        'RelTol', relTol);

    % Extract the final energy value
    E_end = simOut.E_ges.Data(end);
end
