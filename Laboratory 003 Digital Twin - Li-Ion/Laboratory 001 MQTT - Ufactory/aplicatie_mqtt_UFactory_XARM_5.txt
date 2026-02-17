#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import time, threading, socket, struct
from xarm.wrapper import XArmAPI

# ---------------- Minimal MQTT Client (QoS0) ----------------
class MiniMQTTClient:
    class _Msg:
        def __init__(self, topic, payload):
            self.topic = topic
            self.payload = payload

    def __init__(self, client_id=None, keepalive=30):
        self.client_id = client_id or f"mini-{int(time.time())}"
        self.keepalive = keepalive
        self.sock = None
        self.on_connect = None
        self.on_message = None
        self.on_disconnect = None
        self._stop = False
        self._last_io = time.time()
        self._lock = threading.Lock()

    def connect(self, host, port=1883, keepalive=30):
        self.keepalive = keepalive
        self.sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        self.sock.settimeout(5.0)
        self.sock.connect((host, port))
        self.sock.settimeout(0.2)
        self._send_connect()
        # wait for CONNACK
        end = time.time() + 5
        while time.time() < end:
            pkt = self._recv_packet()
            if pkt and pkt[0] == 2:  # CONNACK
                if self.on_connect:
                    # rc is second byte of CONNACK payload
                    self.on_connect(self, None, {}, pkt[2][1])
                return pkt[2][1]
        return 1

    def subscribe(self, topic, qos=0):
        pid = struct.pack("!H", 1)
        payload = pid + self._encode_str(topic) + b"\x00"
        self._send(0x82, payload)

    def loop_forever(self):
        while not self._stop:
            # light keepalive: send PINGREQ if quiet
            if self.keepalive and (time.time() - self._last_io) > self.keepalive * 0.8:
                try:
                    with self._lock:
                        self.sock.sendall(b"\xC0\x00")  # PINGREQ
                    self._last_io = time.time()
                except:
                    break
            pkt = self._recv_packet()
            if pkt is None:
                continue
            ptype, flags, payload = pkt
            if ptype == 3:  # PUBLISH
                topic, msg_payload = self._parse_publish(payload)
                if self.on_message:
                    self.on_message(self, None, MiniMQTTClient._Msg(topic, msg_payload))

    # --- internals ---
    def _encode_str(self, s):
        b = s.encode()
        return struct.pack("!H", len(b)) + b

    def _encode_varint(self, n):
        out = bytearray()
        while True:
            d = n % 128
            n //= 128
            if n > 0: d |= 0x80
            out.append(d)
            if n == 0: break
        return bytes(out)

    def _send(self, header, payload):
        rl = self._encode_varint(len(payload))
        with self._lock:
            self.sock.sendall(bytes([header]) + rl + payload)
        self._last_io = time.time()

    def _send_connect(self):
        payload = (
            self._encode_str("MQTT") + b"\x04" + b"\x02" +
            struct.pack("!H", self.keepalive) + self._encode_str(self.client_id)
        )
        self._send(0x10, payload)

    def _recv_exact(self, n):
        buf = bytearray()
        try:
            while len(buf) < n:
                c = self.sock.recv(n - len(buf))
                if not c: return None
                buf.extend(c)
            return bytes(buf)
        except:
            return None

    def _recv_packet(self):
        try: b1 = self.sock.recv(1)
        except: return None
        if not b1: return None
        mult, val = 1, 0
        while True:
            try: b = self.sock.recv(1)
            except: return None
            if not b: return None
            enc = b[0]
            val += (enc & 127) * mult
            if (enc & 128) == 0: break
            mult *= 128
        payload = self._recv_exact(val)
        return (b1[0] >> 4, b1[0] & 0x0F, payload)

    def _parse_publish(self, payload):
        if not payload or len(payload) < 2: return "", ""
        tlen = struct.unpack("!H", payload[0:2])[0]
        topic = payload[2:2+tlen].decode(errors="replace")
        idx = 2 + tlen
        msg = payload[idx:]
        return topic, msg.decode(errors="replace")

# ---------------- Robot + MQTT Bridge ----------------
BROKER = "broker.emqx.io"
PORT   = 1883
TOPIC_GRIPPER = "xarm5/cmd/gripper"   # one topic only

def on_connect(c, u, f, rc):
    print("MQTT connected, rc =", rc)
    c.subscribe(TOPIC_GRIPPER)
    print("Subscribed to", TOPIC_GRIPPER)

def on_message(c, u, m):
    payload = m.payload.strip()
    print(f"MQTT {m.topic} {payload}")
    # "1" -> CLOSE, "2" -> OPEN
    if payload == "1":
        # CLOSE
        arm.set_gripper_position(70, wait=True, speed=1000, auto_enable=True)
        print("Gripper CLOSED")
    elif payload == "2":
        # OPEN
        arm.set_gripper_position(600, wait=True, speed=1000, auto_enable=True)
        print("Gripper OPENED")
    else:
        print("Ignored payload (expect '1' or '2')")

if __name__ == "__main__":
    # Connect to robot
    arm = XArmAPI("192.168.1.199", baud_checkset=False)
    arm.clean_warn(); arm.clean_error()
    arm.motion_enable(True); arm.set_mode(0); arm.set_state(0)
    time.sleep(1)

    # Connect to MQTT
    client = MiniMQTTClient()
    client.on_connect = on_connect
    client.on_message = on_message
    client.connect(BROKER, PORT, 30)

    threading.Thread(target=client.loop_forever, daemon=True).start()

    print("Ready. Send MQTT messages to:")
    print(" -", TOPIC_GRIPPER, 'with payload "1" → CLOSE, "2" → OPEN')

    try:
        while True:
            time.sleep(1)
    except KeyboardInterrupt:
        print("Stopped.")
