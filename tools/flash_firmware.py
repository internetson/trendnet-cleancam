#!/usr/bin/env python3
"""
Firmware flasher for TRENDnet TV-IP121W via /admin/updatefree.cgi
Usage:
    python tools/flash_firmware.py [CAMERA_IP] [FIRMWARE_PATH]
Example:
    python tools/flash_firmware.py 10.10.11.135 FW_TV-IP121W_Custom_Pro_v1.1.2.pck
"""

import sys
import socket
import base64
import os
import time

def flash(camera_ip="10.10.11.135", fw_path="FW_TV-IP121W_Custom_Pro_v1.1.2.pck", username="admin", password="admin"):
    if not os.path.exists(fw_path):
        # Look in parent or root directory if not found
        alt_path = os.path.join(os.path.dirname(__file__), "..", fw_path)
        if os.path.exists(alt_path):
            fw_path = os.path.abspath(alt_path)
        else:
            print(f"Error: Firmware file '{fw_path}' does not exist!")
            return False

    fw_size = os.path.getsize(fw_path)
    print(f"Preparing to flash firmware: {fw_path} ({fw_size} bytes) to {camera_ip}...")

    with open(fw_path, 'rb') as f:
        fw_data = f.read()

    boundary = "----TrendnetCustomFirmwareUpgradeBoundary987654321"

    body_header = (
        f"--{boundary}\r\n"
        f'Content-Disposition: form-data; name="file"; filename="{os.path.basename(fw_path)}"\r\n'
        f"Content-Type: application/octet-stream\r\n\r\n"
    ).encode('latin1')

    body_tail = f"\r\n--{boundary}--\r\n".encode('latin1')

    total_len = len(body_header) + len(fw_data) + len(body_tail)
    auth = base64.b64encode(f"{username}:{password}".encode()).decode('ascii')

    req_header = (
        f"POST /admin/updatefree.cgi HTTP/1.1\r\n"
        f"Host: {camera_ip}\r\n"
        f"Authorization: Basic {auth}\r\n"
        f"Content-Type: multipart/form-data; boundary={boundary}\r\n"
        f"Content-Length: {total_len}\r\n"
        f"Connection: close\r\n\r\n"
    ).encode('latin1')

    print(f"Connecting to camera on {camera_ip}:80...")
    s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    s.settimeout(180)
    try:
        s.connect((camera_ip, 80))
    except Exception as e:
        print(f"Failed to connect to {camera_ip}:80 -> {e}")
        return False

    print("Sending HTTP POST headers...")
    s.sendall(req_header)
    s.sendall(body_header)

    print("Uploading firmware payload...")
    chunk_size = 32768
    sent = 0
    t0 = time.time()
    while sent < len(fw_data):
        chunk = fw_data[sent:sent+chunk_size]
        s.sendall(chunk)
        sent += len(chunk)
        pct = int(sent * 100 / len(fw_data))
        speed = sent / (time.time() - t0 + 0.001) / 1024
        print(f"Uploaded {sent}/{len(fw_data)} bytes ({pct}%) - {speed:.1f} KB/s", end='\r')

    print("\nSending multipart trailer...")
    s.sendall(body_tail)

    print("Firmware uploaded! Waiting for camera flash response (do NOT power off!)...")
    resp = b""
    try:
        while True:
            chunk = s.recv(4096)
            if not chunk:
                break
            resp += chunk
    except Exception as e:
        print(f"\nConnection closed by camera: {e} (Normal during reboot after flash!)")
    finally:
        s.close()

    resp_str = resp.decode('latin1', errors='ignore')
    if "Update Success" in resp_str or "200 OK" in resp_str:
        print("\n=== Firmware Update SUCCESSFUL! ===")
        print("Camera is writing to Flash and rebooting... (~30-40 seconds)")
        return True
    else:
        print("\n=== Camera Response ===")
        print(resp_str[:500])
        return False

if __name__ == '__main__':
    ip = sys.argv[1] if len(sys.argv) > 1 else "10.10.11.135"
    fw = sys.argv[2] if len(sys.argv) > 2 else "FW_TV-IP121W_Custom_Pro_v1.1.2.pck"
    flash(ip, fw)
