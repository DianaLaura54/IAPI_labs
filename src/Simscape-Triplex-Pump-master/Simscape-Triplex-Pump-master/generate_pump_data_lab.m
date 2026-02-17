N = 20;
features = zeros(N,2);
labels = strings(N,1);
for k = 1:N
if rand < 0.5
faultMode = 'normal';
else
faultMode = 'seal_leakage';
end
assignin('base','faultMode', faultMode);
simOut = sim('sm_pump_triplex','ReturnWorkspaceOutputs','on');
p = simOut.logsout.get('OutletPressure').Values.Data;
i = simOut.logsout.get('MotorCurrent').Values.Data;
features(k,1) = mean(p);
features(k,2) = rms(i);
labels(k) = faultMode;
end
save('pump_data_lab.mat','features','labels');