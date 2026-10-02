Those are my Design of Digital Twin laboratories.
------------------------------
MQTT with a uFactory xArm 5: a Python script receives MQTT commands and opens or closes the gripper of a virtual robot in RoboDK.

MQTT with an ABB IRB 1600: a Python bridge forwards MQTT messages to the robot over a TCP socket, and an ESP8266 sketch blinks an LED from JSON commands.

Li-ion battery twin: a Colab notebook combines a physical degradation formula with a small neural network that corrects its error, using NASA battery discharge data.

Triplex pump twin: MATLAB/Simscape simulations of a three-piston pump (MathWorks' example model) with and without faults.

Preventive maintenance: simulated pump data is classified as normal or seal leakage, and results are pushed to InfluxDB and shown in Grafana via Docker.

ML monitoring: a decision tree is trained on mean pressure and RMS current from 20 simulation runs.
