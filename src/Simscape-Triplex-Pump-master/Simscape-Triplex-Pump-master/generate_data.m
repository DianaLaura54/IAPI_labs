%% 5.2 Generare date - regim sanatos (Healthy)
healthyRuns = 20; % [cite: 80]
simTime = 10; % [cite: 82]
healthyData = cell(healthyRuns, 1); 
faultGain = 2.5; % [cite: 102]

fprintf('Simulare regim sanatos...\n');
for k = 1:healthyRuns
    motorSpeed = 1500 + 50*randn; % [cite: 92]
    out = sim('HydraulicPump_DigitalTwin', 'StopTime', num2str(simTime)); % [cite: 95]
    
    % FIX: Extragem datele din structura yout folosind indexul 1
    % Aceasta varianta functioneaza indiferent de numele portului
    healthyData{k} = out.yout.getElement(1).Values; 
end

%% Generare date - regim cu defect (Faulty)
faultyRuns = 20; % [cite: 108]
faultyData = cell(faultyRuns, 1);
faultGain = 2.5; % [cite: 102]

fprintf('Simulare regim cu defect...\n');
for k = 1:faultyRuns
    motorSpeed = 1500 + 50*randn; % [cite: 119]
    out = sim('HydraulicPump_DigitalTwin', 'StopTime', num2str(simTime)); % [cite: 120]
    
    % FIX: Extragem datele din structura yout folosind indexul 1
    faultyData{k} = out.yout.getElement(1).Values; 
end

%% Salvare date [cite: 125]
save('pump_data.mat', 'healthyData', 'faultyData'); % [cite: 126]
fprintf('Datele au fost salvate in pump_data.mat\n');

%% Vizualizare [cite: 128]
figure;
plot(healthyData{1}.Time, healthyData{1}.Data); hold on; % [cite: 129]
plot(faultyData{1}.Time, faultyData{1}.Data, '--'); % [cite: 130]
legend('Healthy', 'Faulty'); % [cite: 131]
xlabel('Time (s)'); ylabel('Pressure'); % [cite: 132]
%% 5.3 Extragerea indicatorilor (features)
load('pump_data.mat');
numH = numel(healthyData); 
numF = numel(faultyData);

featMean = []; featRMS = []; label = []; % label: 0=OK, 1=Defect [cite: 144, 147]

% Extragere pentru Healthy [cite: 148]
for k = 1:numH
    x = healthyData{k}.Data; 
    featMean(end+1, 1) = mean(x);
    featRMS(end+1, 1) = rms(x); 
    label(end+1, 1) = 0; 
end

% Extragere pentru Faulty [cite: 168]
for k = 1:numF
    x = faultyData{k}.Data; 
    featMean(end+1, 1) = mean(x); 
    featRMS(end+1, 1) = rms(x);
    label(end+1, 1) = 1; 
end

% Creare tabel pentru Classification Learner [cite: 186]
dataTbl = table(featMean, featRMS, label, ...
    'VariableNames', {'MeanPressure', 'RMSPressure', 'Fault'}); 

% Vizualizare separare clase [cite: 190]
figure;
gscatter(dataTbl.MeanPressure, dataTbl.RMSPressure, dataTbl.Fault, 'rb', 'ox'); 
xlabel('Mean Pressure'); ylabel('RMS Pressure'); 
saveLearnerForCoder(pumpMdl, 'pumpMdlCompact');