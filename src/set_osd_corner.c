#define NULL ((void*)0)

typedef unsigned int uint32_t;
typedef int ssize_t;
typedef unsigned int size_t;

static inline long sys_exit(int code) {
    register long r0 __asm__("r0") = code;
    __asm__ __volatile__("swi 0x900001" : : "r"(r0) : "memory");
    return 0;
}

static inline int sys_open(const char *pathname, int flags, int mode) {
    register long r0 __asm__("r0") = (long)pathname;
    register long r1 __asm__("r1") = flags;
    register long r2 __asm__("r2") = mode;
    register long res __asm__("r0");
    __asm__ __volatile__("swi 0x900005" : "=r"(res) : "r"(r0), "r"(r1), "r"(r2) : "memory");
    return (int)res;
}

static inline int sys_close(int fd) {
    register long r0 __asm__("r0") = fd;
    register long res __asm__("r0");
    __asm__ __volatile__("swi 0x900006" : "=r"(res) : "r"(r0) : "memory");
    return (int)res;
}

static inline long sys_lseek(int fd, long offset, int whence) {
    register long r0 __asm__("r0") = fd;
    register long r1 __asm__("r1") = offset;
    register long r2 __asm__("r2") = whence;
    register long res __asm__("r0");
    __asm__ __volatile__("swi 0x900013" : "=r"(res) : "r"(r0), "r"(r1), "r"(r2) : "memory");
    return res;
}

static inline ssize_t sys_write(int fd, const void *buf, size_t count) {
    register long r0 __asm__("r0") = fd;
    register long r1 __asm__("r1") = (long)buf;
    register long r2 __asm__("r2") = (long)count;
    register long res __asm__("r0");
    __asm__ __volatile__("swi 0x900004" : "=r"(res) : "r"(r0), "r"(r1), "r"(r2) : "memory");
    return (ssize_t)res;
}

__asm__(
".text\n"
".global _start\n"
"_start:\n"
"    mov r0, sp\n"
"    b main_entry\n"
);

void main_entry(unsigned long *sp) {
    int argc = (int)sp[0];
    char **argv = (char**)&sp[1];

    if (argc < 2) {
        char msg[] = "Usage: set_osd_corner <0..3>\n";
        sys_write(1, msg, sizeof(msg) - 1);
        sys_exit(1);
    }

    char c = argv[1][0];
    uint32_t opcode = 0xe1a01005; /* default: Top-Left (mov r1, r5) */

    if (c == '1') {
        opcode = 0xe2851f64; /* Top-Right (add r1, r5, #400) */
    } else if (c == '2') {
        opcode = 0xe2851a46; /* Bottom-Left (add r1, r5, #0x46000) */
    } else if (c == '3') {
        opcode = 0xe2851a45; /* Bottom-Right (add r1, r5, #0x45000) */
    }

    char path[] = "/tmp/camsvr";
    int fd = sys_open(path, 2, 0); /* O_RDWR = 2 */
    if (fd < 0) {
        char err[] = "Error: open /tmp/camsvr failed\n";
        sys_write(2, err, sizeof(err) - 1);
        sys_exit(2);
    }

    sys_lseek(fd, 0x5d3c, 0); /* SEEK_SET = 0 */
    sys_write(fd, &opcode, 4);
    sys_close(fd);

    char ok[] = "OSD opcode patched successfully\n";
    sys_write(1, ok, sizeof(ok) - 1);
    sys_exit(0);
}
