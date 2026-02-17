function res = evaluate_pump_once(faultMode)
persistent model
if isempty(model)
load('pump_ml_model.mat','model');
end
assignin('base','faultMode',faultMode);
simOut = sim('sm_pump_triplex','ReturnWorkspaceOutputs','on');
p = simOut.logsout.get('OutletPressure').Values.Data;
i = simOut.logsout.get('MotorCurrent').Values.Data;
res.meanPressure = mean(p);
res.rmsCurrent = rms(i);
res.predictedLabel = string(predict(model,[res.meanPressure res.rmsCurrent]));
res.faultMode = string(faultMode);
res.healthIndex = double(res.predictedLabel=="normal");
res.alarm = double(res.healthIndex==0);
end