import time, threading
from robodk import robolink

# Pastrezi clasa MiniMQTTClient din fisierul tau original

# --- Configurație Simulator ---
RDK = robolink.Robolink()
robot = RDK.Item('uFactory xArm 5', robolink.ITEM_TYPE_ROBOT)


def on_message(c, u, m):
    payload = m.payload.strip()
    print(f"Comandă primită prin MQTT: {payload}")

    if payload == "1":
        # Simulare ÎNCHIDERE gripper în RoboDK
        # Notă: Poți rula un program/macro numit 'Close' în RoboDK
        RDK.RunCode('CloseGripper', True)
        print("Simulator: Gripper ÎNCHIS")
    elif payload == "2":
        # Simulare DESCHIDERE gripper în RoboDK
        RDK.RunCode('OpenGripper', True)
        print("Simulator: Gripper DESCHIS")


# În main, înlocuiești inițializarea xArm cu verificarea RoboDK
if __name__ == "__main__":
    if not robot.Valid():
        print("Eroare: Nu am găsit robotul în RoboDK!")
    else:
        # Pornire MQTT conform codului tău [cite: 485]
        client = MiniMQTTClient()
        client.on_message = on_message
        client.connect("broker.emqx.io")
        threading.Thread(target=client.loop_forever, daemon=True).start()

        while True:
            time.sleep(1)