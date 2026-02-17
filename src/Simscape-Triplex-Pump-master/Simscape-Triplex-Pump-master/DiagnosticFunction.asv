function faultFlag = DiagnosticFunction(meanP, rmsP)
%#codegen
persistent mdl
if isempty(mdl)
mdl = loadLearnerForCoder('pumpMdlCompact');
end
X = table(meanP, rmsP, 'VariableNames', {'MeanPressure','RMSPressure'});
faultLabel = predict(mdl, X);
faultFlag = double(faultLabel); % 0 sau 1
end