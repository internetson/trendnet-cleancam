#!/usr/bin/env python3
"""
Telnet command runner for TRENDnet TV-IP121W
Usage:
    python tools/telnet_cmd.py "command to run"
    CAMERA_IP=10.10.11.135 python tools/telnet_cmd.py "ps"
"""

import socket
import sys
import os
import time

def run_cmd(cmd, ip=None, timeout=10):
    camera_ip = ip or os.environ.get("CAMERA_IP", "10.10.11.135")
    s = socket.create_connection((camera_ip, 23), timeout=timeout)
    
    # 1. Drain initial banner until prompt "/ # "
    init_buf = b""
    s.settimeout(2.0)
    try:
        while b"/ # " not in init_buf:
            c = s.recv(1024)
            if not c:
                break
            init_buf += c
    except Exception:
        pass
    
    # 2. Send command with newline
    s.sendall(cmd.encode('utf-8') + b"\n")
    
    # 3. Read output until prompt "/ # " appears after our command
    out = b""
    s.settimeout(timeout)
    try:
        while True:
            chunk = s.recv(1024)
            if not chunk:
                break
            out += chunk
            if b"/ # " in out[-8:]:
                break
    except Exception:
        pass
    s.close()
    
    # Strip echoed command line and trailing prompt if present
    text = out.decode('utf-8', errors='replace')
    lines = text.splitlines()
    if lines and cmd in lines[0]:
        lines = lines[1:]
    if lines and lines[-1].strip() == "/ #":
        lines = lines[:-1]
    return "\n".join(lines).strip()

if __name__ == "__main__":
    cmd = " ".join(sys.argv[1:]) if len(sys.argv) > 1 else "uname -a; ps"
    res = run_cmd(cmd)
    print(res)
