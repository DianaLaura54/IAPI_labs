% Inițializare Proiect
if isempty(matlab.project.rootProject)
    openProject('Triplex_Pump.prj');
end

N = 20; 
features = zeros(N, 2); 
labels = cell(N, 1);   
modelName = 'sm_pump_triplex';

fprintf('Începere generare date pentru %d simulări...\n', N);

for k = 1:N
    if rand > 0.5
        faultMode = 'normal'; 
    else
        faultMode = 'seal_leakage'; 
    end
    assignin('base','faultMode', faultMode); 
    
    % Rulăm simularea
    simOut = sim(modelName, 'ReturnWorkspaceOutputs','on', 'SignalLogging', 'on'); 
    
    % Verificăm containerul (Folosim numele implicit 'logsout')
    if isprop(simOut, 'logsout') && ~isempty(simOut.logsout)
        % EXTRAGERE CORECATĂ:
        % pOut_sim trebuie să fie presiunea de ieșire
        % iMeas (sau cum ai numit tu curentul) trebuie să fie curentul
        try
            p_data = simOut.logsout.get('pOut_sim').Values.Data; 
            i_data = simOut.logsout.get('iMeas').Values.Data; % Verifică numele firului de curent!
            
            features(k, 1) = mean(p_data); 
            features(k, 2) = rms(i_data); 
            labels{k} = faultMode; 
            
            fprintf('Simularea %d/%d: Mod %s gata.\n', k, N, faultMode);
        catch ME
            error('Eroare la extragerea semnalelor: %s. Verifică dacă numele firelor din Simulink sunt identice cu cele din cod!', ME.message);
        end
    else
        error('Eroare: logsout nu a fost găsit. Verifică Model Settings -> Data Import/Export -> Signal Logging să fie bifat.');
    end
end


% Salvarea bazei de date
save('pump_data_lab.mat', 'features', 'labels'); 
fprintf('Succes! Fișierul pump_data_lab.mat a fost creat!\n');
figure;
gscatter(features(:,1), features(:,2), labels);
xlabel('Presiune Medie (Pa)');
ylabel('RMS Curent (A)');
title('Distribuția Datelor: Normal vs Scurgere');
grid on;