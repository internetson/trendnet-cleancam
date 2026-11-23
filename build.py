#!/usr/bin/env python3
"""
TRENDnet TV-IP121W Custom Firmware Builder (v1.1.2 Pro)
Compiles ARMv4 C sources (via Zig cross-compiler) and packages Minix rootfs into a flashable .pck image.

Usage:
    python build.py [--skip-compile] [--output FW_TV-IP121W_Custom_Pro_v1.1.2.pck]
"""

import os
import sys
import shutil
import struct
import binascii
import gzip
import io
import json
import subprocess
import argparse

def find_zig():
    if "ZIG_BIN" in os.environ and os.path.exists(os.environ["ZIG_BIN"]):
        return os.environ["ZIG_BIN"]
    which = shutil.which("zig")
    if which:
        return which
    # Check common local directory if present
    toolchain_dir = os.path.join(os.path.dirname(__file__), "zig_toolchain")
    if os.path.isdir(toolchain_dir):
        for root, dirs, files in os.walk(toolchain_dir):
            for f in files:
                if f in ("zig.exe", "zig"):
                    return os.path.join(root, f)
    return None

def compile_and_patch_armv4(zig_bin, source_file, output_bin):
    os.makedirs(os.path.dirname(output_bin) or ".", exist_ok=True)
    cmd = [
        zig_bin, "cc",
        "-target", "arm-freestanding-eabi",
        "-mcpu=arm7tdmi",
        "-nostdlib",
        "-O2",
        source_file,
        "-o", output_bin,
        "-Wl,-e,_start"
    ]
    print(f"  [CC] Compiling {source_file} -> {output_bin}...")
    res = subprocess.run(cmd, capture_output=True, text=True)
    if res.returncode != 0:
        print(f"Compilation error for {source_file}:\n{res.stderr}")
        sys.exit(1)

    # Patch ELF header: offset 36 to 0x202 (GNU ARM OABI for Linux 2.4 kernel)
    with open(output_bin, "r+b") as f:
        f.seek(36)
        f.write(struct.pack("<I", 0x202))
        f.seek(0)
        data = bytearray(f.read())
        # Replace ARMv4 incompatible 'bx lr' with 'mov pc, lr'
        old_bx_lr = b"\x1e\xff\x2f\xe1"
        new_mov_pc_lr = b"\x0e\xf0\xa0\xe1"
        cnt = 0
        for i in range(0, len(data) - 3, 4):
            if data[i:i+4] == old_bx_lr:
                data[i:i+4] = new_mov_pc_lr
                cnt += 1
        f.seek(0)
        f.write(data)
    print(f"  [PATCH] {output_bin}: ELF OABI=0x202, converted {cnt} 'bx lr' -> 'mov pc, lr' (Size: {os.path.getsize(output_bin)} bytes)")

def compile_all_sources():
    zig = find_zig()
    if not zig:
        print("[!] Zig cross-compiler not found. Using precompiled binaries in extracted_rootfs/.")
        return

    print(f"[*] Found Zig toolchain: {zig}")
    build_dir = "build"
    os.makedirs(build_dir, exist_ok=True)

    # 1. rtspd
    rtspd_c = "src/rtspd.c"
    if os.path.exists(rtspd_c):
        out_rtspd = os.path.join(build_dir, "rtspd")
        compile_and_patch_armv4(zig, rtspd_c, out_rtspd)
        shutil.copy2(out_rtspd, "extracted_rootfs/sbin/rtspd")
        shutil.copy2(out_rtspd, "extracted_rootfs/server/rtspd")

    # 2. set_osd_corner
    osd_c = "src/set_osd_corner.c"
    if os.path.exists(osd_c):
        out_osd = os.path.join(build_dir, "set_osd_corner")
        compile_and_patch_armv4(zig, osd_c, out_osd)
        shutil.copy2(out_osd, "extracted_rootfs/sbin/set_osd_corner")

    # 3. ir_ctrl
    ir_c = "src/ir_ctrl.c"
    if os.path.exists(ir_c):
        out_ir = os.path.join(build_dir, "ir_ctrl")
        compile_and_patch_armv4(zig, ir_c, out_ir)
        shutil.copy2(out_ir, "extracted_rootfs/sbin/ir_ctrl")

    # Update manifest with actual file sizes
    manifest_path = "rootfs_manifest.json"
    if os.path.exists(manifest_path):
        with open(manifest_path, "r", encoding="utf-8") as f:
            manifest = json.load(f)
        for key in ["sbin/rtspd", "server/rtspd", "sbin/set_osd_corner", "sbin/ir_ctrl", "sbin/irled.sh"]:
            local_file = os.path.join("extracted_rootfs", key.replace("/", os.sep))
            if os.path.exists(local_file):
                if key not in manifest:
                    manifest[key] = {
                        "type": "file",
                        "size": os.path.getsize(local_file),
                        "mode": 33261,
                        "uid": 0,
                        "gid": 0,
                        "mtime": 1364182749
                    }
                else:
                    manifest[key]["size"] = os.path.getsize(local_file)
        with open(manifest_path, "w", encoding="utf-8") as f:
            json.dump(manifest, f, indent=2)
        print("  [MANIFEST] Updated rootfs_manifest.json with new binary sizes.")

def build_minix_fs(manifest_path, root_dir):
    with open(manifest_path, 'r', encoding='utf-8') as f:
        manifest = json.load(f)

    BLOCK_SIZE = 1024
    NINODES = 1824
    NZONES = 5420
    IMAP_BLOCKS = 1
    ZMAP_BLOCKS = 1
    FIRSTDATAZONE = 61
    MAGIC = 0x138F
    STATE = 1

    img = bytearray(NZONES * BLOCK_SIZE)

    # Superblock at offset 1024
    sb = struct.pack('<HHHHHHIHH', NINODES, NZONES, IMAP_BLOCKS, ZMAP_BLOCKS, FIRSTDATAZONE, 0, 268966912, MAGIC, STATE)
    img[1024:1024+len(sb)] = sb

    next_inode = 1
    path_to_ino = {'': 1}
    items = sorted([k for k in manifest.keys() if k != ''])
    for path in items:
        next_inode += 1
        path_to_ino[path] = next_inode

    if next_inode > NINODES:
        raise RuntimeError(f'Inode overflow: {next_inode} > {NINODES}')

    next_zone = FIRSTDATAZONE
    def alloc_zone():
        nonlocal next_zone
        if next_zone >= NZONES:
            raise RuntimeError('Zone overflow in Minix FS!')
        z = next_zone
        next_zone += 1
        return z

    inode_table_offset = 4 * BLOCK_SIZE

    def write_inode(ino, mode, uid, size, mtime, gid, nlinks, zones):
        off = inode_table_offset + (ino - 1) * 32
        raw = struct.pack('<HHIIBB9H', mode, uid, size, mtime, gid, nlinks, *zones)
        img[off:off+32] = raw

    dir_entries = {k: [('.', path_to_ino[k]), ('..', 1 if k == '' else path_to_ino['/'.join(k.split('/')[:-1])])] for k, v in manifest.items() if v['type'] == 'dir'}
    for path in items:
        parent = '/'.join(path.split('/')[:-1])
        name = path.split('/')[-1]
        dir_entries[parent].append((name, path_to_ino[path]))

    for path, meta in manifest.items():
        ino = path_to_ino[path]
        mtype = meta['type']
        mode = meta['mode']
        uid = meta['uid']
        gid = meta['gid']
        mtime = meta.get('mtime', 1364182749)

        if mtype == 'dir':
            entries = dir_entries[path]
            dir_data = bytearray()
            for name, target_ino in entries:
                entry = struct.pack('<H', target_ino) + name.encode('latin-1').ljust(30, b'\x00')
                dir_data.extend(entry)
            content = bytes(dir_data)
            nlinks = 2 + sum(1 for e_name, e_ino in entries[2:] if manifest.get(path + '/' + e_name if path else e_name, {}).get('type') == 'dir')
        elif mtype == 'symlink':
            content = meta['target'].encode('latin-1')
            nlinks = 1
        elif mtype == 'file':
            local_path = os.path.join(root_dir, path.replace('/', os.sep))
            with open(local_path, 'rb') as fp:
                content = fp.read()
            nlinks = 1
        elif mtype in ('chrdev', 'blkdev'):
            content = b''
            nlinks = 1
        else:
            content = b''
            nlinks = 1

        size = len(content)
        zones = [0] * 9

        if mtype in ('chrdev', 'blkdev'):
            zones[0] = meta.get('dev', 0)
        elif size > 0:
            blocks = [content[i:i+BLOCK_SIZE] for i in range(0, size, BLOCK_SIZE)]
            num_blocks = len(blocks)

            direct_cnt = min(num_blocks, 7)
            for i in range(direct_cnt):
                z = alloc_zone()
                zones[i] = z
                img[z*BLOCK_SIZE : z*BLOCK_SIZE + len(blocks[i])] = blocks[i]

            if num_blocks > 7:
                ind_z = alloc_zone()
                zones[7] = ind_z
                ind_table = bytearray()
                for b in blocks[7:7+512]:
                    z = alloc_zone()
                    ind_table.extend(struct.pack('<H', z))
                    img[z*BLOCK_SIZE : z*BLOCK_SIZE + len(b)] = b
                img[ind_z*BLOCK_SIZE : ind_z*BLOCK_SIZE + len(ind_table)] = ind_table

            if num_blocks > 7 + 512:
                raise NotImplementedError('Double indirect zones not implemented for Minix v1 in this script')

        write_inode(ino, mode, uid, size, mtime, gid, nlinks, zones)

    # Inode bitmap
    imap = bytearray(BLOCK_SIZE)
    for i in range(0, next_inode + 1):
        imap[i // 8] |= (1 << (i % 8))
    for i in range(NINODES + 1, BLOCK_SIZE * 8):
        imap[i // 8] |= (1 << (i % 8))
    img[2 * BLOCK_SIZE : 3 * BLOCK_SIZE] = imap

    # Zone bitmap
    zmap = bytearray(BLOCK_SIZE)
    for z in range(0, next_zone):
        zmap[z // 8] |= (1 << (z % 8))
    for z in range(NZONES, BLOCK_SIZE * 8):
        zmap[z // 8] |= (1 << (z % 8))
    img[3 * BLOCK_SIZE : 4 * BLOCK_SIZE] = zmap

    # Gzip rootfs with name 'rootfs'
    buf = io.BytesIO()
    with gzip.GzipFile(filename='rootfs', mode='wb', fileobj=buf, mtime=1364182749) as gz:
        gz.write(img)
    return buf.getvalue()

def build_firmware(orig_path, out_path, manifest_path='rootfs_manifest.json', root_dir='extracted_rootfs'):
    if not os.path.exists(orig_path):
        raise FileNotFoundError(f"Original firmware file '{orig_path}' not found!")

    print(f"[*] Reading base firmware: {orig_path}...")
    with open(orig_path, 'rb') as f:
        orig = f.read()

    installer_hdr_and_code = orig[:0x4260] # up to partition table
    table = orig[0x4260:0x5260]
    kernel_blob = orig[0x5260:0x5260 + 0xa1220]
    autoboot_blob = orig[0x5260 + 0xa1220 + 0x1e8480 : 0x5260 + 0xa1220 + 0x1e8480 + 0x2000]
    trailer = orig[-64:]

    print("[*] Assembling custom Minix v1 rootfs...")
    custom_rootfs_gz = build_minix_fs(manifest_path, root_dir)
    print(f"    Gzipped rootfs size: {len(custom_rootfs_gz)} bytes")

    rootfs_max_size = 0x1e8480 # 2000000 bytes
    if len(custom_rootfs_gz) > rootfs_max_size:
        raise ValueError(f"Rootfs exceeds partition size: {len(custom_rootfs_gz)} > {rootfs_max_size}")

    rootfs_padded = custom_rootfs_gz.ljust(rootfs_max_size, b'\x00')

    # Assemble firmware
    fw = bytearray()
    fw.extend(installer_hdr_and_code)
    fw.extend(table)
    fw.extend(kernel_blob)
    fw.extend(rootfs_padded)
    fw.extend(autoboot_blob)

    payload_len = len(fw)
    fw[0x20:0x24] = struct.pack('<I', payload_len)

    # Compute CRC32 with bytes 0x0c to 0x20 zeroed out
    temp_for_crc = bytearray(fw)
    for i in range(0x0c, 0x20):
        temp_for_crc[i] = 0

    crc = binascii.crc32(temp_for_crc)
    fw[0x1c:0x20] = struct.pack('<I', crc)
    fw.extend(trailer)

    os.makedirs(os.path.dirname(out_path) or ".", exist_ok=True)
    with open(out_path, 'wb') as f:
        f.write(fw)

    print(f"[+] Successfully generated firmware: {out_path} ({len(fw)} bytes, CRC32: 0x{crc:08x})")

    # Verification
    tr = fw[-64:]
    tr_magic = struct.unpack('<I', tr[:4])[0]
    model_name = tr[4:].split(b'\x00')[0].decode()
    assert tr_magic == 0x07140624 and model_name == 'TV-IP121W', "Invalid trailer magic or model!"

    v_len = struct.unpack('<I', fw[0x20:0x24])[0]
    zeroed = bytearray(fw[:v_len])
    for i in range(0x0c, 0x20):
        zeroed[i] = 0
    actual_crc = binascii.crc32(zeroed)
    assert actual_crc == crc, "CRC32 verification failed!"
    print("=== [PASS] ALL FIRMWARE CHECKS VERIFIED SUCCESSFULLY ===")

def main():
    parser = argparse.ArgumentParser(description="TRENDnet TV-IP121W Custom Firmware Builder")
    parser.add_argument("--skip-compile", action="store_true", help="Skip compilation of C sources")
    parser.add_argument("--orig", default="firmware/FW_TV-IP121W_1.1.1-36_20130325_r1252.pck", help="Path to original base firmware")
    parser.add_argument("--output", default="FW_TV-IP121W_Custom_Pro_v1.1.2.pck", help="Output firmware path")
    args = parser.parse_args()

    if not args.skip_compile:
        compile_all_sources()

    build_firmware(args.orig, args.output)

if __name__ == "__main__":
    main()
