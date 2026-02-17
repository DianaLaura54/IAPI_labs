function push_to_influx(res)
url = "http://localhost:8086/api/v2/write";
params = struct("org","lab-org","bucket","pump_bucket","precision","ns");
token = "lab-token-123";
ts = int64(posixtime(datetime("now"))*1e9);
line = sprintf( ...
"pump_status,faultMode=%s,predLabel=%s meanPressure=%f,rmsCurrent=%f,healthIndex=%f,alarm=%d %d", ...
res.faultMode,res.predictedLabel,res.meanPressure,res.rmsCurrent,res.healthIndex,res.alarm,ts);
headers = [
matlab.net.http.HeaderField("Authorization","Token "+token)
matlab.net.http.HeaderField("Content-Type","text/plain")
];
req = matlab.net.http.RequestMessage("post",headers,line);
uri = matlab.net.URI(url);
uri.Query = matlab.net.QueryParameter(params);
send(req,uri);
end