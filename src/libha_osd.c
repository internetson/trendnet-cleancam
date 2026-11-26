#include "ha_font.h"

#define NULL ((void *)0)
typedef unsigned int size_t;
typedef unsigned char uint8_t;
typedef unsigned short uint16_t;
typedef unsigned int uint32_t;

struct timeval {
    long tv_sec;
    long tv_usec;
};

static inline int sys_open(const char *pathname, int flags, int mode) {
    register long r0 __asm__("r0") = (long)pathname;
    register long r1 __asm__("r1") = flags;
    register long r2 __asm__("r2") = mode;
    register long res __asm__("r0");
    __asm__ __volatile__("swi 0x900005" : "=r"(res) : "r"(r0), "r"(r1), "r"(r2) : "memory");
    return (int)res;
}

static inline int sys_read(int fd, void *buf, size_t count) {
    register long r0 __asm__("r0") = fd;
    register long r1 __asm__("r1") = (long)buf;
    register long r2 __asm__("r2") = (long)count;
    register long res __asm__("r0");
    __asm__ __volatile__("swi 0x900003" : "=r"(res) : "r"(r0), "r"(r1), "r"(r2) : "memory");
    return (int)res;
}

static inline int sys_close(int fd) {
    register long r0 __asm__("r0") = fd;
    register long res __asm__("r0");
    __asm__ __volatile__("swi 0x900006" : "=r"(res) : "r"(r0) : "memory");
    return (int)res;
}

static inline int sys_msync(void *addr, size_t length, int flags) {
    register long r0 __asm__("r0") = (long)addr;
    register long r1 __asm__("r1") = (long)length;
    register long r2 __asm__("r2") = (long)flags;
    register long res __asm__("r0");
    __asm__ __volatile__("swi 0x900090" : "=r"(res) : "r"(r0), "r"(r1), "r"(r2) : "memory");
    return (int)res;
}

static inline int sys_gettimeofday(struct timeval *tv, void *tz) {
    register long r0 __asm__("r0") = (long)tv;
    register long r1 __asm__("r1") = (long)tz;
    register long res __asm__("r0");
    __asm__ __volatile__("swi 0x90004e" : "=r"(res) : "r"(r0), "r"(r1) : "memory");
    return (int)res;
}

#define MAX_LINES 4
#define MAX_COLS  64

static long g_last_sec = -1;
static int g_enable = 0;
static int g_corner = 2;
static int g_invert = 0;
static int g_offset_y = 0;
static int g_num_lines = 0;
static uint8_t g_lines[MAX_LINES][MAX_COLS];
static int g_line_lens[MAX_LINES];

static int utf8_to_glyph(const char *s, int *advance) {
    unsigned char c0 = (unsigned char)s[0];
    if (c0 < 0x80) {
        *advance = 1;
        if (c0 >= 0x20 && c0 <= 0x7E) return c0 - 0x20;
        return 0; /* space */
    }
    unsigned char c1 = (unsigned char)s[1];
    if ((c0 & 0xE0) == 0xC0 && c1 != 0) {
        *advance = 2;
        uint16_t cp = ((uint16_t)(c0 & 0x1F) << 6) | (c1 & 0x3F);
        if (cp == 0x00B0) return 95; /* degree symbol */
        if (cp == 0x0401) return 96; /* Yo */
        if (cp == 0x0451) return 97; /* yo */
        if (cp >= 0x0410 && cp <= 0x044F) return 98 + (cp - 0x0410);
        return '?' - 0x20;
    }
    if ((c0 & 0xF0) == 0xE0 && s[1] && s[2]) {
        *advance = 3;
        return '?' - 0x20;
    }
    if ((c0 & 0xF8) == 0xF0 && s[1] && s[2] && s[3]) {
        *advance = 4;
        return '?' - 0x20;
    }
    *advance = 1;
    return 0;
}

static int parse_int(const char **p) {
    int val = 0;
    while (**p == ' ' || **p == '\t') (*p)++;
    while (**p >= '0' && **p <= '9') {
        val = val * 10 + (**p - '0');
        (*p)++;
    }
    return val;
}

static void reload_osd_text(void) {
    char path[] = "/tmp/ha_osd.txt";
    char buf[768];
    int fd = sys_open(path, 0, 0);
    if (fd < 0) {
        g_enable = 0;
        g_num_lines = 0;
        return;
    }
    int n = sys_read(fd, buf, sizeof(buf) - 1);
    sys_close(fd);
    if (n <= 0) {
        g_enable = 0;
        g_num_lines = 0;
        return;
    }
    buf[n] = '\0';

    const char *p = buf;
    g_enable = parse_int(&p);
    g_corner = parse_int(&p);
    g_invert = parse_int(&p);
    g_offset_y = parse_int(&p);

    while (*p && *p != '\n') p++;
    if (*p == '\n') p++;

    g_num_lines = 0;
    while (*p && g_num_lines < MAX_LINES) {
        int col = 0;
        while (*p && *p != '\n' && *p != '\r' && col < MAX_COLS) {
            int adv = 1;
            int g = utf8_to_glyph(p, &adv);
            g_lines[g_num_lines][col++] = (uint8_t)g;
            p += adv;
        }
        while (*p && *p != '\n') p++;
        if (*p == '\n') p++;
        if (col > 0) {
            g_line_lens[g_num_lines] = col;
            g_num_lines++;
        }
    }
}

static void draw_osd(uint8_t *y_plane, int w, int h) {
    if (!g_enable || g_num_lines <= 0) return;

    int max_cols = 0;
    for (int i = 0; i < g_num_lines; i++) {
        if (g_line_lens[i] > max_cols) max_cols = g_line_lens[i];
    }
    if (max_cols <= 0) return;

    int box_w = max_cols * 8 + 8;
    int box_h = g_num_lines * 16 + 6;
    if (box_w > w) box_w = w;
    if (box_h > h) box_h = h;

    int bx = 4;
    int by = 4;
    if (g_corner == 0) {
        bx = 4;
        by = 4 + g_offset_y;
    } else if (g_corner == 1) {
        bx = w - box_w - 4;
        by = 4 + g_offset_y;
    } else if (g_corner == 2) {
        bx = 4;
        by = h - box_h - 4 - g_offset_y;
    } else {
        bx = w - box_w - 4;
        by = h - box_h - 4 - g_offset_y;
    }

    if (bx < 0) bx = 0;
    if (by < 0) by = 0;
    if (bx + box_w > w) bx = w - box_w;
    if (by + box_h > h) by = h - box_h;

    /* Background box */
    for (int ry = 0; ry < box_h; ry++) {
        uint8_t *row = y_plane + (by + ry) * w + bx;
        if (g_invert) {
            for (int rx = 0; rx < box_w; rx++) {
                row[rx] = (uint8_t)(192 + (row[rx] >> 2));
            }
        } else {
            for (int rx = 0; rx < box_w; rx++) {
                row[rx] = (uint8_t)(row[rx] >> 2);
            }
        }
    }

    /* Glyphs */
    uint8_t fg = g_invert ? 16 : 240;
    for (int line = 0; line < g_num_lines; line++) {
        int len = g_line_lens[line];
        int gy0 = by + 3 + line * 16;
        for (int c = 0; c < len; c++) {
            int gx0 = bx + 4 + c * 8;
            if (gx0 + 8 > w) break;
            const uint8_t *glyph = ha_font8x16[g_lines[line][c]];
            for (int row_i = 0; row_i < 16; row_i++) {
                if (gy0 + row_i >= h) break;
                uint8_t bits = glyph[row_i];
                if (!bits) continue;
                uint8_t *dst = y_plane + (gy0 + row_i) * w + gx0;
                for (int bit = 0; bit < 8; bit++) {
                    if (bits & (0x80 >> bit)) {
                        dst[bit] = fg;
                    }
                }
            }
        }
    }
}

int msync(void *addr, size_t length, int flags) {
    if (flags == 4 && addr != NULL) {
        int w = 0, h = 0;
        if (length >= 460800 && length <= 614400) {
            w = 640; h = 480;
        } else if (length >= 115200 && length <= 153600) {
            w = 320; h = 240;
        } else if (length >= 28800 && length <= 38400) {
            w = 160; h = 120;
        }
        if (w > 0) {
            struct timeval tv;
            if (sys_gettimeofday(&tv, NULL) == 0 && tv.tv_sec != g_last_sec) {
                g_last_sec = tv.tv_sec;
                reload_osd_text();
            }
            draw_osd((uint8_t *)addr, w, h);
        }
    }
    return sys_msync(addr, length, flags);
}
