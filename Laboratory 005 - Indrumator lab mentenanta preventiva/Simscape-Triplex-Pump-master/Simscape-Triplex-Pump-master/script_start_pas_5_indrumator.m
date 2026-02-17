

% alegem modul implicit (normal)
faultMode = 'normal';
assignin('base','faultMode', faultMode);

% rulam o simulare
simOut = sim('sm_pump_triplex', 'ReturnWorkspaceOutputs','on');

% extragem semnalele logate din simulare
p_out = simOut.logsout.get('OutletPressure').Values.Data;
i_mot = simOut.logsout.get('MotorCurrent').Values.Data;

% afisam informatii minime
fprintf('Numar esantioane presiune: %d\n', length(p_out));
fprintf('Numar esantioane curent: %d\n', length(i_mot));


