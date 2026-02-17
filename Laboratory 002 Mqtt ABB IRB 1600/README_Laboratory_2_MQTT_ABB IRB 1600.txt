README - Laboratory 2: MQTT Communication with ABB IRB1600 and ESP8266
------------------------------------------------------------

OVERVIEW
------------------------------------------------------------
This laboratory demonstrates how MQTT (Message Queuing Telemetry Transport) can be used
to enable communication between Python applications, industrial robots (ABB IRB1600),
and IoT microcontrollers (ESP8266).

The lab is designed to help students understand IoT communication, data transmission,
and the creation of Digital Twin environments where physical and virtual systems interact.

The lab includes two main tasks:
1. Establishing a connection interface between Python and the ABB IRB1600 robot.
2. Connecting a smartphone and ESP8266 microcontroller using MQTT for wireless control.

------------------------------------------------------------
WHAT IS MQTT?
------------------------------------------------------------
MQTT is a lightweight, low-bandwidth, publish/subscribe messaging protocol for
machine-to-machine (M2M) communication. It is ideal for Internet of Things (IoT)
applications that require real-time, reliable, and efficient data exchange.

Source: https://www.spiceworks.com/tech/iot/articles/what-is-mqtt/

------------------------------------------------------------
TASK 1 - CONNECTION INTERFACE: PYTHON AND ROBOT ABB IRB1600
------------------------------------------------------------
In this task, Python communicates with an ABB IRB1600 robot via MQTT and TCP sockets.

Components:
- Python MQTT client (using Paho MQTT library)
- ABB IRB1600 robot connected via Ethernet TCP socket

Program Flow:
1. Python subscribes to MQTT topic: "button_topic/mqtt"
2. Waits for messages from the MQTT broker.
3. When receiving "1" or "2", it connects to the robot at IP: 192.168.125.1, port: 1500.
4. Sends text commands ("aplicatia_1" or "aplicatia_2") to the robot controller.
5. Displays robot response in the terminal.

Broker used: broker.emqx.io (port 1883)
Robot IP: 192.168.125.1

Reference Video: https://youtu.be/E-Gvn6QCAYc

------------------------------------------------------------
PUBLISHER INTERFACE (PYTHON GUI)
------------------------------------------------------------
The Publisher GUI is a Python Tkinter application using the Paho MQTT library to send MQTT messages.

Features:
- Three image buttons to trigger robot actions.
- Each button sends a message to the MQTT topic when pressed.
- Displays real-time MQTT connection status ("Connected" / "Not Connected").
- Uses the public broker broker.emqx.io for quick testing.

Purpose:
This interface allows remote MQTT publishing through a simple GUI, simulating digital twin communication.

------------------------------------------------------------
TASK 2 - CONNECTION BETWEEN PHONE AND ESP8266
------------------------------------------------------------
This task demonstrates wireless MQTT communication between a smartphone (publisher)
and an ESP8266 microcontroller (subscriber).

Hardware Used:
- ESP8266 Wi-Fi microcontroller
- Onboard LED or external LED

Program Flow:
1. ESP8266 connects to Wi-Fi and MQTT broker.
2. Subscribes to topic: "abb/variables"
3. Receives JSON messages such as:
   { "variable1": "a", "variable2": 5 }
4. Parses the JSON message using ArduinoJson to control LED behavior:
   - "a" → Blink every 1 second
   - "r" → Blink every 2 seconds
   - "variable2" → number of blinks

Libraries Used:
- PubSubClient (for MQTT communication)
- ArduinoJson (for JSON message parsing)

------------------------------------------------------------
ESP8266 WORKFLOW
------------------------------------------------------------
1. Connect to Wi-Fi access point.
2. Connect to MQTT broker (broker.emqx.io:1883).
3. Subscribe to topic "abb/variables".
4. Parse JSON messages and execute LED actions based on variable values.
5. Automatically reconnect if Wi-Fi or MQTT connection is lost.

------------------------------------------------------------
SUMMARY
------------------------------------------------------------
- Python and ESP8266 demonstrate MQTT interoperability for IoT control and robot communication.
- MQTT ensures low-latency, reliable data exchange across devices.
- The laboratory integrates ABB IRB1600, Python applications, ESP8266, and mobile apps.
- Demonstrates Digital Twin principles using real-time MQTT data transmission.
------------------------------------------------------------
REPOSITORY STRUCTURE (SUGGESTED)
------------------------------------------------------------
Laboratory 2 - Mqtt - ABB IRB1600/
│
├── 2 Digital_Twin_MQTT_ABB IRB1600_Presentation - Balog Bogdan Gheorghe.pptx      (Presentation slides)
├── DOC Laboratory 2 - Mqtt - ABB IRB1600.docx  (Source lab description)
└── README_Laboratory_2_MQTT_ABB IRB 1600.txt                                  (This file)

------------------------------------------------------------
AUTHOR
------------------------------------------------------------
Balog Bogdan Gheorghe
Technical University of Cluj-Napoca
Laboratory: Digital Twin, MQTT Communication 
