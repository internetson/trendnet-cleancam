/*
 * ir_ctrl.c - Hardware controller for IR LEDs and Light Sensor
 * TRENDnet TV-IP121W (ARMv4 OABI, Linux 2.4.20)
 *
 * Controls PL1029 GPIO register at 0xd94c0056:
 *   - Bit 10 (0x0400): IR LED control (1 = ON, 0 = OFF)
 * Reads PL1029 GPIO register at 0xd94c005c:
 *   - Bit 9  (0x0200): Light sensor / CDS photocell (1 = Light, 0 = Dark)
 * Sets /dev/hwmon IR_state = 0 via ioctl 0x8004483d to prevent kernel driver conflict.
 */

#define NULL ((void*)0)

typedef unsigned int uint32_t;
typedef unsigned short uint16_t;

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

static inline int sys_write(int fd, const void *buf, int count) {
    register long r0 __asm__("r0") = fd;
    register long r1 __asm__("r1") = (long)buf;
    register long r2 __asm__("r2") = count;
    register long res __asm__("r0");
    __asm__ __volatile__("swi 0x900004" : "=r"(res) : "r"(r0), "r"(r1), "r"(r2) : "memory");
    return (int)res;
}

static inline int sys_ioctl(int fd, unsigned int cmd, unsigned long arg) {
    register long r0 __asm__("r0") = fd;
    register long r1 __asm__("r1") = cmd;
    register long r2 __asm__("r2") = arg;
    register long res __asm__("r0");
    __asm__ __volatile__("swi 0x900036" : "=r"(res) : "r"(r0), "r"(r1), "r"(r2) : "memory");
    return (int)res;
}

struct mmap_arg_struct {
    unsigned long addr;
    unsigned long len;
    unsigned long prot;
    unsigned long flags;
    unsigned long fd;
    unsigned long offset;
};

static inline void *sys_mmap(struct mmap_arg_struct *arg) {
    register long r0 __asm__("r0") = (long)arg;
    register long res __asm__("r0");
    __asm__ __volatile__("swi 0x90005a" : "=r"(res) : "r"(r0) : "memory");
    return (void *)res;
}

static int str_eq(const char *a, const char *b) {
    while (*a && (*a == *b)) { a++; b++; }
    return (*a == *b);
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
    char **argv = (char **)&sp[1];

    if (argc < 2) {
        const char msg[] = "Usage: ir_ctrl on|off|status\n";
        sys_write(1, msg, sizeof(msg) - 1);
        sys_exit(1);
    }

    const char *cmd = argv[1];

    // Tell kernel hwmon to not manage IR (IR_state = 0) when manually controlling
    if (str_eq(cmd, "on") || str_eq(cmd, "off")) {
        int h_fd = sys_open("/dev/hwmon", 2, 0); // O_RDWR
        if (h_fd >= 0) {
            int zero = 0;
            sys_ioctl(h_fd, 0x8004483d, (unsigned long)&zero);
            sys_close(h_fd);
        }
    }

    // Open /dev/plio to access Faraday PL1029 I/O space (0xd8000000 - 0xdfffffff)
    int m_fd = sys_open("/dev/plio", 2, 0); // O_RDWR
    if (m_fd < 0) {
        const char err[] = "ERR: open /dev/plio failed\n";
        sys_write(2, err, sizeof(err) - 1);
        sys_exit(2);
    }

    struct mmap_arg_struct margs;
    margs.addr = 0;
    margs.len = 0x08000000; // 128 MB
    margs.prot = 3;         // PROT_READ | PROT_WRITE
    margs.flags = 1;        // MAP_SHARED
    margs.fd = m_fd;
    margs.offset = 0;

    char *base = (char *)sys_mmap(&margs);
    if ((long)base < 0 && (long)base > -4096) {
        const char err[] = "ERR: mmap failed\n";
        sys_write(2, err, sizeof(err) - 1);
        sys_close(m_fd);
        sys_exit(3);
    }

    // Faraday GPIO register 0xd94c0056 -> offset 0x014c0056 in /dev/plio
    // Faraday GPIO register 0xd94c005c -> offset 0x014c005c in /dev/plio
    volatile uint16_t *reg_out = (volatile uint16_t *)(base + 0x014c0056);
    volatile uint16_t *reg_in  = (volatile uint16_t *)(base + 0x014c005c);

    if (str_eq(cmd, "on")) {
        *reg_out |= (uint16_t)0x0400; // Set bit 10
    } else if (str_eq(cmd, "off")) {
        *reg_out &= (uint16_t)~0x0400; // Clear bit 10
    } else if (str_eq(cmd, "status")) {
        uint16_t out_val = *reg_out;
        uint16_t in_val  = *reg_in;

        int led_on = (out_val & 0x0400) ? 1 : 0;
        int sensor_light = (in_val & 0x0200) ? 1 : 0;

        char buf[32];
        buf[0] = 'L'; buf[1] = 'E'; buf[2] = 'D'; buf[3] = '=';
        buf[4] = led_on ? '1' : '0';
        buf[5] = ' ';
        buf[6] = 'S'; buf[7] = 'E'; buf[8] = 'N'; buf[9] = 'S'; buf[10] = 'O'; buf[11] = 'R'; buf[12] = '=';
        buf[13] = sensor_light ? '1' : '0'; // 1=light, 0=dark
        buf[14] = '\n';
        sys_write(1, buf, 15);
    } else {
        const char msg[] = "ERR: unknown command\n";
        sys_write(2, msg, sizeof(msg) - 1);
        sys_close(m_fd);
        sys_exit(4);
    }

    sys_close(m_fd);
    sys_exit(0);
}
