clear, close all;


%% Gegebene Werte
m1 = 500;       % kg
m2 = 20;        % kg
c1 = 100e3;     % N/m
d2 = 15;        % Ns/m
x1_0 = 1;       % Startwert für x1
x2_0 = 0;       % Startwert für x2


%% Einstellungen
c2 = 3650; 	        % manueller Wert für c2
stopTime = '30';    % Simulationsdauer
relTol = '1e-5';    % relative Toleranz, über 1e-5 werden Ergebnisse schlecht
layout = 2;         % Layout des Ergebnis
                    % 1: x1_opt und x1_man in einem Diagramm
                    % 2: x1_opt und x2_opt in einem Diagramm


%% c2-Optimierung
optimize = true;            % Optimierung durchführen
c2_min = 0;                 % Unteres Limit
c2_max = 10000;             % Oberes Limit
divisions = 5;              % Unterteilungen pro Intervall
tolerance = 1e-2;           % Welche Genauigkeit (Intervallgröße von c2)
maxCyclesCount = 30;        % Wann soll abgebrochen werden



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


if exist("c2") == 1     % Wenn manuell eingegebenes c2 existiert,
                        % Energie mit dem höchsten c2 berechnen
    c2_man = c2;
    manual = true;
    E_max = 0.5*c1*x1_0^2 +0.5*( ...
        (c2>c2_max) * c2 + (c2_max>c2) * c2_max ...     % größeres c2 finden
        )*(x2_0-x1_0)^2;
else                                                    % Ansonsten c2_max nehmen
    manual = false;
    E_max = 0.5*c1*x1_0^2 +0.5*c2_max*(x2_0-x1_0)^2;
end % if exist("c2") == 1

if optimize  == true % Teilaufgabe c)            Lösung müsste c2 = 3635 N/m sein
    E_min = 1;
    c2_min_org = c2_min;
    c2_max_org = c2_max;

    figure('Name', 'Teilaufgabe c): Optimierung von c_2', 'NumberTitle','off');

    %% Eigentliche Suche beginnen
    iterations = 1;
    c2_Werte =  zeros(divisions, 1);    % Arrays initialisieren
    E_ges_Werte = zeros (divisions, 1);

    if divisions < 4                    % Fehlermeldung ausgeben, wenn divisions zu klein ist
        'Anzahl der Unterteilungen zu klein';
    end % if divisions < 4

    while (c2_max - c2_min) > tolerance && iterations <= maxCyclesCount
        c2_Werte = c2_min: (c2_max-c2_min)/divisions : c2_max;          % Neues Intervall anlegen
        E_ges_Werte = zeros (divisions,1);                              % Werte für E_ges löschen

        for i = 1:divisions         % Simulation für jeweiliges c2 durchführen
           
            c2 = c2_Werte(i);
            simOut = sim(Schwingungstilger, ...
                'StopTime', stopTime, ...
                'relTol', relTol);
            E_ges_Werte(i)= simOut.E_ges.Data(end);

            % Ergebnisse plotten
            semilogy(c2_Werte(i), E_ges_Werte(i), 'x');
            grid on;
            xlim([c2_min_org  c2_max_org]);
            ylim([E_min*0.1 E_max]);
            xlabel('c2 / N/m');
            ylabel('Energie / J');
            title('Endenergie für c2')
            hold on;
            drawnow
        end % for i = 1:divisions

        [E_min, minIndex] = min(E_ges_Werte);   % Niedrigsten Energiewert finden und neue Grenzen festlegen
       
        if minIndex == 1                        % Verhindern, das der untere Rand unterschritten wird
            c2_min =c2_Werte(minIndex);
        else
            c2_min = c2_Werte(minIndex -1);
        end % if minIndex == 1

        if minIndex== divisions                 %Verhindern, dass oberer Rand überschritten wird
            c2_max = c2_Werte(minIndex);
        else
            c2_max = c2_Werte(minIndex +1);
        end % if minIndex== divisions


        if iterations == maxCyclesCount     % Abbruchbedingung, um Endlosschleife zu verhindern
            fprintf("Anzahl der maximalen Durchgänge erreicht, ohne die geforderte Toleranz einzuhalten")
            fprintf('c2_min: %f c2_max: %f', c2_min, c2_max)
        end % if iterations == maxCyclesCount

        iterations=iterations+1;            % Zähler erhöhen

    end % while (c2_max - c2_min) > tolerance && iterations <= maxCyclesCount

    c2_opti = (c2_max + c2_min)/2;      % Optimales c2
    
    % Optimales c2 ausgeben
    fprintf('\n\noptimales c2: %f', c2_opti);
    fprintf('\nGenauigkeit: ∓%f\n\n', (c2_max - c2_min)/2)
    fprintf('%d Berechnungen in %d Iterationen\n', divisions*iterations, iterations)

end % if optimize  == true


%% x1, x2 und E_ges für c2_opt und c2_manual ausgeben
figure('Name', 'Schwingungstilger', 'NumberTitle','off');
if optimize == true                                         % Wenn Optimierung stattgefunden hat
    simOut_opt = sim(Schwingungstilger, ...
        'StopTime', stopTime, ...
        'relTol', relTol);
    t_opt = simOut_opt.x1.time;
    x1_opt = simOut_opt.x1.Data;
    x2_opt = simOut_opt.x2.Data;
    E_ges_opt = simOut_opt.E_ges.Data;

end % if optimize == true

if manual == true % Wenn manueller Wert ausgerechnet werden soll
    c2 = c2_man;
    simOut_man = sim(Schwingungstilger, ...
        'StopTime', stopTime, ...
        'relTol', relTol);
    t_man = simOut_man.x1.time;
    x1_man = simOut_man.x1.Data;
    x2_man = simOut_man.x2.Data;
    E_ges_man = simOut_man.E_ges.Data;
end % if manual == true

%% Ausgabe der Simulationen

if layout == 1  % 1: x1_opt und x1_man in einem Diagramm

    if optimize == true && manual == true
        subplot(2,2,1);
        plot(t_opt, x1_opt, ...
            'LineWidth', 1.5, ...
            'Color', 'r');
        hold on;
        plot(t_man, x1_man, ...
            'LineWidth', 1.5, ...
            'Color', 'm');
        hold on;
        legend('x_{1, opt}(t)', 'x_{1, man}(t)')

        xlabel('Zeit / s');
        ylabel('Position / m');
        title('Position der Masse m_1');

        subplot(2,2,3)
        plot(t_opt, x2_opt, ...
            'LineWidth', 1.5, ...
            'Color', 'b');
        hold on;
        plot(t_man, x2_man, ...
            'LineWidth', 1.5, ...
            'Color', 'c');
        hold on;
        legend('x_{2, opt}(t)', 'x_{2, man}(t)')

        xlabel('Zeit / s');
        ylabel('Position / m');
        title('Position der Masse m_2');

        subplot(2,2,2);
        plot(t_opt, E_ges_opt, ...
            'LineWidth', 1.5, ...
            'Color', 'g');
        ylim([0 E_max]);
        grid on;
        hold on;
        plot(t_man, E_ges_man, ...
            'LineWidth', 1.5, ...
            'Color', 'y');
        ylim([0 E_max]);
        hold on;
        legend('E_{ges, opt}(t)','E_{ges, man}(t)')

        xlabel('Zeit / s');
        ylabel('Energie / J');
        title('Gesamtenergie');

    elseif optimize == true && manual == false
        subplot(2,2,1);
        plot(t_opt, x1_opt, ...
            'LineWidth', 1.5, ...
            'Color', 'r');
        hold on;
        legend('x_{1, opt}(t)')

        xlabel('Zeit / s');
        ylabel('Position / m');
        title('Position der Masse m_1');

        subplot(2,2,3)
        plot(t_opt, x2_opt, ...
            'LineWidth', 1.5, ...
            'Color', 'b');
        hold on;
        legend('x_{2, opt}(t)')

        xlabel('Zeit / s');
        ylabel('Position / m');
        title('Position der Masse m_2');

        subplot(2,2,2);
        plot(t_opt, E_ges_opt, ...
            'LineWidth', 1.5, ...
            'Color', 'g');
        ylim([0 E_max]);
        grid on;
        hold on;
        legend('E_{ges, opt}(t)')

        xlabel('Zeit / s');
        ylabel('Energie / J');
        title('Gesamtenergie');


    elseif optimize == false && manual == true
        subplot(2,2,1);
        plot(t_man, x1_man, ...
            'LineWidth', 1.5, ...
            'Color', 'm');
        hold on;
        legend('x_{1, man}(t)')

        xlabel('Zeit / s');
        ylabel('Position / m');
        title('Position der Masse m_1');

        subplot(2,2,3)
        plot(t_man, x2_man, ...
            'LineWidth', 1.5, ...
            'Color', 'c');
        hold on;
        legend('x_{2, man}(t)')

        xlabel('Zeit / s');
        ylabel('Position / m');
        title('Position der Masse m_2');

        subplot(2,2,2);
        plot(t_man, E_ges_man, ...
            'LineWidth', 1.5, ...
            'Color', 'y');
        ylim([0 E_max]);
        grid on;
        hold on;
        legend('E_{ges, man}(t)')

        xlabel('Zeit / s');
        ylabel('Energie / J');
        title('Gesamtenergie');


    elseif optimize == false && manual == false
        close all
        return
    end % if optimize == true && manual == true



elseif layout == 2  % 2: x1_opt und x2_opt in einem Diagramm
    if optimize == true && manual == true
        subplot(2,2,1);
        plot(t_opt, x1_opt, ...
            'LineWidth', 1.5, ...
            'Color', 'r');
        hold on;
        plot(t_opt, x2_opt, ...
            'LineWidth', 1.5, ...
            'Color', 'b');
        hold on;
        legend('x_{1, opt}(t)', 'x_{2, opt}(t)')

        xlabel('Zeit / s');
        ylabel('Position / m');
        title('Position der Massen für c_{2, opt}');

        subplot(2,2,2)
        plot(t_man, x1_man, ...
            'LineWidth', 1.5, ...
            'Color', 'm');
        hold on;
        plot(t_man, x2_man, ...
            'LineWidth', 1.5, ...
            'Color', 'c');
        hold on;
        legend('x_{1, man}(t)', 'x_{2, man}(t)')

        xlabel('Zeit / s');
        ylabel('Position / m');
        title('Position der Massen für c_{2, man}');

        subplot(2,2,3);
        plot(t_opt, E_ges_opt, ...
            'LineWidth', 1.5, ...
            'Color', 'g');
        ylim([0 E_max]);
        grid on;
        hold on;
        legend('E_{ges, opt}(t)')

        xlabel('Zeit / s');
        ylabel('Energie / J');
        title('Gesamtenergie für c_{2, opt}');

        subplot(2,2,4);
        plot(t_man, E_ges_man, ...
            'LineWidth', 1.5, ...
            'Color', 'y');
        ylim([0 E_max]);
        grid on;
        hold on;
        legend('E_{ges, man}(t)')

        xlabel('Zeit / s');
        ylabel('Energie / J');
        title('Gesamtenergie für c_{2, man}');

    elseif optimize == true && manual == false
        subplot(2,1,1);
        plot(t_opt, x1_opt, ...
            'LineWidth', 1.5, ...
            'Color', 'r');
        hold on;
        plot(t_opt, x2_opt, ...
            'LineWidth', 1.5, ...
            'Color', 'b');
        hold on;
        legend('x_{1, opt}(t)', 'x_{2, opt}(t)')

        xlabel('Zeit / s');
        ylabel('Position / m');
        title('Position der Massen für c_{2, opt}');

        subplot(2,1,2);
        plot(t_opt, E_ges_opt, ...
            'LineWidth', 1.5, ...
            'Color', 'g');
        ylim([0 E_max]);
        grid on;
        hold on;
        legend('E_{ges, opt}(t)')

        xlabel('Zeit / s');
        ylabel('Energie / J');
        title('Gesamtenergie für c_{2, opt}');


    elseif optimize == false && manual == true
        subplot(2,1,1);
        plot(t_man, x1_man, ...
            'LineWidth', 1.5, ...
            'Color', 'm');
        hold on;
        plot(t_man, x2_man, ...
            'LineWidth', 1.5, ...
            'Color', 'c');
        hold on;
        legend('x_{1, man}(t)', 'x_{2, man}(t)')

        xlabel('Zeit / s');
        ylabel('Position / m');
        title('Position der Massen für c_{2, man}');

        subplot(2,1,2);
        plot(t_man, E_ges_man, ...
            'LineWidth', 1.5, ...
            'Color', 'y');
        ylim([0 E_max]);
        grid on;
        hold on;
        legend('E_{ges, man}(t)')

        xlabel('Zeit / s');
        ylabel('Energie / J');
        title('Gesamtenergie für c_{2, man}');


    elseif optimize == false && manual == false
        close all
        return
    end % if optimize == true && manual == true
end % if layout == 1

