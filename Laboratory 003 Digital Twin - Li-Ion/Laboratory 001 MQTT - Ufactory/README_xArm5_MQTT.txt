README – Digital Twin & MQTT Communication with xArm5 Robot
------------------------------------------------------------

OVERVIEW
------------------------------------------------------------
This project demonstrates a Digital Twin communication experiment using an xArm5 robotic arm connected to a local network and controlled via MQTT messages.
It is designed as an introductory laboratory to understand data transmission between a digital model and a physical robot using lightweight IoT protocols.

The setup allows students to control the xArm5 gripper remotely through an MQTT topic, representing the simplest bridge between the physical system and its digital twin.


CONCEPT: DIGITAL TWIN
------------------------------------------------------------
A Digital Twin is a real-time, virtual representation of a physical system.

In this experiment:
- The xArm5 robot is the physical system.
- The MQTT client is the communication bridge.
- The Python application acts as the connector between real and virtual entities.

Core idea: demonstrate how real robot actions (gripper open/close) can be mirrored, monitored, and controlled through a digital interface using MQTT.


SYSTEM SETUP
------------------------------------------------------------
Network Configuration:
- Router SSID: admin
- Router Password: admin1243
- Robot IP: 192.168.2.199
- MQTT Broker: broker.emqx.io
- Port: 1883
- Topic: xarm5/cmd/gripper

Tip: Both your PC and the xArm5 robot should be connected to the same router.


APPLICATION DESCRIPTION
------------------------------------------------------------
The Python application performs two main functions:
1. Connects to the xArm5 robot using the XArmAPI SDK.
2. Connects to an MQTT broker to receive commands and control the robot’s gripper.

Communication Flow:
1. The robot connects to the MQTT broker.
2. The program subscribes to the topic “xarm5/cmd/gripper”.
3. The broker receives messages (from PC or mobile app).
4. The robot executes the command:
   - “1” → CLOSE gripper
   - “2” → OPEN gripper


CODE SUMMARY
------------------------------------------------------------
Main Components:
- MiniMQTTClient: A minimal MQTT client implemented in pure Python.
- XArmAPI: Used to control the UFactory xArm5 robot.
- on_message: Callback function to interpret MQTT messages and move the gripper accordingly.

Example Commands:
1 → Closes the gripper
2 → Opens the gripper

Example Output:
MQTT connected, rc = 0
Subscribed to xarm5/cmd/gripper
MQTT xarm5/cmd/gripper 1
Gripper CLOSED
MQTT xarm5/cmd/gripper 2
Gripper OPENED


TESTING WITH MOBILE APP
------------------------------------------------------------
You can use the MyMQTT Android app or MQTT Explorer on PC to send test messages.

Broker: broker.emqx.io
Port: 1883
Topic: xarm5/cmd/gripper
Message: 1 or 2


LABORATORY GOALS
------------------------------------------------------------
This laboratory introduces students to:
- Basic Digital Twin concepts
- MQTT protocol for real-time communication
- Robot control via IoT
- The importance of data transmission reliability and latency


NEXT STEPS
------------------------------------------------------------
To expand this laboratory:
1. Implement authentication and TLS encryption for MQTT.
2. Add bi-directional data flow (e.g., send robot joint data, TCP position).
3. Integrate a digital simulation or 3D visualization of the robot.
4. Link with RoboDK or Web-based 3D twin interfaces for extended use.
5. Explore XR applications for immersive robot monitoring.


REPOSITORY STRUCTURE (SUGGESTED)
------------------------------------------------------------
xarm5_digital_twin/
│
├── robot_code_mqtt_UFactory_XARM_5.py      (Main Python application)
├── README.txt
└── requirements.txt                        (Optional: include xArm SDK info)


AUTHOR
------------------------------------------------------------
Balog Bogdan Gheorghe
Technical University of Cluj-Napoca
Laboratory: Digital Twin, MQTT Communication & xArm5 Robot Control
