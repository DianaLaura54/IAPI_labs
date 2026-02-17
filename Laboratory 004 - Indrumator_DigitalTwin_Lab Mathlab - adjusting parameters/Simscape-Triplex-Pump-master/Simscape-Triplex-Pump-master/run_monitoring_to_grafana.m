for k = 1:60
if rand < 0.8
fm = "normal";
else
fm = "seal_leakage";
end
res = evaluate_pump_once(fm);
push_to_influx(res);
pause(2);
end