/*
 * Home Assistant Sensor OSD Poller for TRENDnet TV-IP121W
 * Target: ARMv4 Linux 2.4 OABI (Zero external dependencies, -nostdlib)
 */

#define NULL ((void*)0)

typedef unsigned char uint8_t;
typedef unsigned short uint16_t;
typedef unsigned int uint32_t;
typedef int ssize_t;
typedef unsigned int size_t;

/* Syscalls (Linux 2.4 ARM OABI) */
static inline long sys_exit(int code) {
    register long r0 __asm__("r0") = code;
    __asm__ __volatile__("swi 0x900001" : : "r"(r0) : "memory");
    return 0;
}

static inline ssize_t sys_read(int fd, void *buf, size_t count) {
    register long r0 __asm__("r0") = fd;
    register long r1 __asm__("r1") = (long)buf;
    register long r2 __asm__("r2") = (long)count;
    register long res __asm__("r0");
    __asm__ __volatile__("swi 0x900003" : "=r"(res) : "r"(r0), "r"(r1), "r"(r2) : "memory");
    return (ssize_t)res;
}

static inline ssize_t sys_write(int fd, const void *buf, size_t count) {
    register long r0 __asm__("r0") = fd;
    register long r1 __asm__("r1") = (long)buf;
    register long r2 __asm__("r2") = (long)count;
    register long res __asm__("r0");
    __asm__ __volatile__("swi 0x900004" : "=r"(res) : "r"(r0), "r"(r1), "r"(r2) : "memory");
    return (ssize_t)res;
}

static inline int sys_open(const char *path, int flags, int mode) {
    register long r0 __asm__("r0") = (long)path;
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

static inline int sys_rename(const char *oldpath, const char *newpath) {
    register long r0 __asm__("r0") = (long)oldpath;
    register long r1 __asm__("r1") = (long)newpath;
    register long res __asm__("r0");
    __asm__ __volatile__("swi 0x900026" : "=r"(res) : "r"(r0), "r"(r1) : "memory");
    return (int)res;
}

static inline int sys_fcntl(int fd, int cmd, long arg) {
    register long r0 __asm__("r0") = fd;
    register long r1 __asm__("r1") = cmd;
    register long r2 __asm__("r2") = arg;
    register long res __asm__("r0");
    __asm__ __volatile__("swi 0x900037" : "=r"(res) : "r"(r0), "r"(r1), "r"(r2) : "memory");
    return (int)res;
}

struct timeval { long tv_sec; long tv_usec; };
struct timespec { long tv_sec; long tv_nsec; };

static inline int sys_nanosleep(const struct timespec *req, struct timespec *rem) {
    register long r0 __asm__("r0") = (long)req;
    register long r1 __asm__("r1") = (long)rem;
    register long res __asm__("r0");
    __asm__ __volatile__("swi 0x9000a2" : "=r"(res) : "r"(r0), "r"(r1) : "memory");
    return (int)res;
}

typedef struct { uint32_t fds_bits[32]; } fd_set;

static inline int sys_select(int n, fd_set *rfds, fd_set *wfds, fd_set *efds, struct timeval *tv) {
    register long r0 __asm__("r0") = n;
    register long r1 __asm__("r1") = (long)rfds;
    register long r2 __asm__("r2") = (long)wfds;
    register long r3 __asm__("r3") = (long)efds;
    register long r4 __asm__("r4") = (long)tv;
    register long res __asm__("r0");
    __asm__ __volatile__("swi 0x90008e" : "=r"(res) : "r"(r0), "r"(r1), "r"(r2), "r"(r3), "r"(r4) : "memory");
    return (int)res;
}

static inline long sys_socketcall(int call, unsigned long *args) {
    register long r0 __asm__("r0") = call;
    register long r1 __asm__("r1") = (long)args;
    register long res __asm__("r0");
    __asm__ __volatile__("swi 0x900066" : "=r"(res) : "r"(r0), "r"(r1) : "memory");
    return res;
}

#define AF_INET 2
#define SOCK_STREAM 1
#define SOCK_DGRAM 2
#define SOL_SOCKET 1
#define SO_ERROR 4
#define O_RDONLY 0
#define O_WRONLY 1
#define O_CREAT 0100
#define O_TRUNC 01000
#define F_GETFL 3
#define F_SETFL 4
#define O_NONBLOCK 04000

struct sockaddr_in {
    uint16_t sin_family;
    uint16_t sin_port;
    uint32_t sin_addr;
    uint8_t sin_zero[8];
};

static inline uint16_t htons16(uint16_t v) { return (uint16_t)((v >> 8) | (v << 8)); }

static int sock_create(int type) {
    unsigned long a[3] = { AF_INET, (unsigned long)type, 0 };
    return (int)sys_socketcall(1, a);
}
static int sock_connect(int fd, struct sockaddr_in *addr) {
    unsigned long a[3] = { (unsigned long)fd, (unsigned long)addr, sizeof(struct sockaddr_in) };
    return (int)sys_socketcall(3, a);
}
static ssize_t sock_send(int fd, const void *buf, size_t len) {
    unsigned long a[4] = { (unsigned long)fd, (unsigned long)buf, (unsigned long)len, 0 };
    return (ssize_t)sys_socketcall(9, a);
}
static ssize_t sock_recv(int fd, void *buf, size_t len) {
    unsigned long a[4] = { (unsigned long)fd, (unsigned long)buf, (unsigned long)len, 0 };
    return (ssize_t)sys_socketcall(10, a);
}
static int sock_getsockopt(int fd, int level, int optname, void *optval, int *optlen) {
    unsigned long a[5] = { (unsigned long)fd, (unsigned long)level, (unsigned long)optname, (unsigned long)optval, (unsigned long)optlen };
    return (int)sys_socketcall(15, a);
}

/* Minimal string helpers */
static int s_len(const char *s) { int n = 0; while (s[n]) n++; return n; }
static int s_cmp(const char *a, const char *b) {
    while (*a && *a == *b) { a++; b++; }
    return (unsigned char)*a - (unsigned char)*b;
}
static int s_ncmp(const char *a, const char *b, int n) {
    for (int i = 0; i < n; i++) {
        if (a[i] != b[i]) return (unsigned char)a[i] - (unsigned char)b[i];
        if (!a[i]) return 0;
    }
    return 0;
}
static void s_copy(char *dst, const char *src, int max) {
    int i = 0;
    while (src[i] && i < max - 1) { dst[i] = src[i]; i++; }
    dst[i] = '\0';
}
static void s_cat(char *dst, const char *src, int max) {
    int d = s_len(dst), i = 0;
    while (src[i] && d < max - 1) dst[d++] = src[i++];
    dst[d] = '\0';
}
static const char *s_find(const char *hay, const char *needle) {
    int nlen = s_len(needle);
    if (!nlen) return hay;
    for (; *hay; hay++) {
        if (*hay == *needle && s_ncmp(hay, needle, nlen) == 0) return hay;
    }
    return NULL;
}
static void m_zero(void *p, size_t n) {
    uint8_t *b = (uint8_t *)p;
    for (size_t i = 0; i < n; i++) b[i] = 0;
}
static int parse_int(const char *s) {
    int v = 0, neg = 0;
    while (*s == ' ' || *s == '\t') s++;
    if (*s == '-') { neg = 1; s++; }
    while (*s >= '0' && *s <= '9') { v = v * 10 + (*s - '0'); s++; }
    return neg ? -v : v;
}
static void int_to_str(int v, char *buf) {
    char tmp[16];
    int i = 0, j = 0;
    if (v == 0) { buf[0] = '0'; buf[1] = '\0'; return; }
    if (v < 0) { buf[j++] = '-'; v = -v; }
    while (v > 0) { tmp[i++] = (char)('0' + (v % 10)); v /= 10; }
    while (i > 0) buf[j++] = tmp[--i];
    buf[j] = '\0';
}

static int parse_ipv4(const char *s, uint32_t *out_be) {
    uint32_t b[4] = {0,0,0,0};
    int idx = 0;
    while (*s) {
        if (*s < '0' || *s > '9') return -1;
        uint32_t val = 0;
        while (*s >= '0' && *s <= '9') {
            val = val * 10 + (*s - '0');
            if (val > 255) return -1;
            s++;
        }
        b[idx++] = val;
        if (idx == 4) {
            if (*s != '\0') return -1;
            *out_be = b[0] | (b[1] << 8) | (b[2] << 16) | (b[3] << 24);
            return 0;
        }
        if (*s != '.') return -1;
        s++;
    }
    return -1;
}

static int resolve_host(const char *host, uint32_t *out_be) {
    if (parse_ipv4(host, out_be) == 0) return 0;

    /* Read first nameserver from /etc/resolv.conf */
    uint32_t dns_ip = 0x08080808; /* 8.8.8.8 fallback */
    char rbuf[256];
    int rfd = sys_open("/etc/resolv.conf", O_RDONLY, 0);
    if (rfd >= 0) {
        int rn = sys_read(rfd, rbuf, sizeof(rbuf) - 1);
        sys_close(rfd);
        if (rn > 0) {
            rbuf[rn] = '\0';
            const char *ns = s_find(rbuf, "nameserver");
            if (ns) {
                ns += 10;
                while (*ns == ' ' || *ns == '\t') ns++;
                char ipbuf[32];
                int k = 0;
                while (*ns && *ns != '\n' && *ns != '\r' && *ns != ' ' && k < 31) ipbuf[k++] = *ns++;
                ipbuf[k] = '\0';
                parse_ipv4(ipbuf, &dns_ip);
            }
        }
    }

    int fd = sock_create(SOCK_DGRAM);
    if (fd < 0) return -1;
    struct sockaddr_in sa;
    m_zero(&sa, sizeof(sa));
    sa.sin_family = AF_INET;
    sa.sin_port = htons16(53);
    sa.sin_addr = dns_ip;
    if (sock_connect(fd, &sa) < 0) { sys_close(fd); return -1; }

    uint8_t pkt[256];
    m_zero(pkt, sizeof(pkt));
    pkt[0] = 0x12; pkt[1] = 0x34; /* ID */
    pkt[2] = 0x01; pkt[3] = 0x00; /* RD=1 */
    pkt[5] = 0x01;                /* QDCOUNT=1 */
    int pos = 12;
    const char *p = host;
    while (*p && pos < 200) {
        int len_pos = pos++;
        int l = 0;
        while (*p && *p != '.' && pos < 240) { pkt[pos++] = (uint8_t)*p++; l++; }
        pkt[len_pos] = (uint8_t)l;
        if (*p == '.') p++;
    }
    pkt[pos++] = 0;
    pkt[pos++] = 0; pkt[pos++] = 1; /* QTYPE A */
    pkt[pos++] = 0; pkt[pos++] = 1; /* QCLASS IN */

    sock_send(fd, pkt, pos);

    fd_set rfds;
    m_zero(&rfds, sizeof(rfds));
    rfds.fds_bits[fd >> 5] |= (1U << (fd & 31));
    struct timeval tv = { 3, 0 };
    if (sys_select(fd + 1, &rfds, NULL, NULL, &tv) <= 0) {
        sys_close(fd);
        return -1;
    }

    uint8_t resp[512];
    int n = (int)sock_recv(fd, resp, sizeof(resp));
    sys_close(fd);
    if (n < 12) return -1;

    int ancount = (resp[6] << 8) | resp[7];
    int rpos = pos;
    for (int a = 0; a < ancount && rpos + 12 <= n; a++) {
        if ((resp[rpos] & 0xC0) == 0xC0) {
            rpos += 2;
        } else {
            while (rpos < n && resp[rpos]) rpos += resp[rpos] + 1;
            rpos++;
        }
        if (rpos + 10 > n) break;
        uint16_t rtype = (uint16_t)((resp[rpos] << 8) | resp[rpos + 1]);
        uint16_t rdlen = (uint16_t)((resp[rpos + 8] << 8) | resp[rpos + 9]);
        rpos += 10;
        if (rtype == 1 && rdlen == 4 && rpos + 4 <= n) {
            *out_be = resp[rpos] | (resp[rpos+1] << 8) | (resp[rpos+2] << 16) | (resp[rpos+3] << 24);
            return 0;
        }
        rpos += rdlen;
    }
    return -1;
}

static int tcp_connect_timeout(uint32_t ip_be, uint16_t port, int timeout_sec) {
    int fd = sock_create(SOCK_STREAM);
    if (fd < 0) return -1;
    int fl = sys_fcntl(fd, F_GETFL, 0);
    sys_fcntl(fd, F_SETFL, fl | O_NONBLOCK);

    struct sockaddr_in sa;
    m_zero(&sa, sizeof(sa));
    sa.sin_family = AF_INET;
    sa.sin_port = htons16(port);
    sa.sin_addr = ip_be;

    int rc = sock_connect(fd, &sa);
    if (rc < 0) {
        fd_set wfds;
        m_zero(&wfds, sizeof(wfds));
        wfds.fds_bits[fd >> 5] |= (1U << (fd & 31));
        struct timeval tv = { timeout_sec, 0 };
        if (sys_select(fd + 1, NULL, &wfds, NULL, &tv) <= 0) {
            sys_close(fd);
            return -1;
        }
        int err = 0, elen = sizeof(err);
        sock_getsockopt(fd, SOL_SOCKET, SO_ERROR, &err, &elen);
        if (err != 0) {
            sys_close(fd);
            return -1;
        }
    }
    sys_fcntl(fd, F_SETFL, fl); /* restore blocking */
    return fd;
}

/* Extract JSON string value for key like "state":"23.4" */
static int extract_json_str(const char *json, const char *key, char *out, int max) {
    char pat[64];
    s_copy(pat, "\"", sizeof(pat));
    s_cat(pat, key, sizeof(pat));
    s_cat(pat, "\"", sizeof(pat));

    const char *p = s_find(json, pat);
    if (!p) { out[0] = '\0'; return -1; }
    p += s_len(pat);
    while (*p == ' ' || *p == '\t' || *p == ':') p++;
    if (*p != '"') { out[0] = '\0'; return -1; }
    p++;

    int i = 0;
    while (*p && *p != '"' && i < max - 3) {
        if (p[0] == '\\' && p[1] == 'u' &&
            p[2] == '0' && p[3] == '0' &&
            (p[4] == 'b' || p[4] == 'B') && p[5] == '0') {
            /* \u00b0 -> UTF-8 degree symbol 0xC2 0xB0 */
            out[i++] = (char)0xC2;
            out[i++] = (char)0xB0;
            p += 6;
        } else if (p[0] == '\\' && p[1]) {
            p++;
            out[i++] = *p++;
        } else {
            out[i++] = *p++;
        }
    }
    out[i] = '\0';
    return 0;
}

static int fetch_ha_sensor(uint32_t ip_be, uint16_t port, const char *host_hdr,
                           const char *token, const char *entity_id,
                           char *state_out, int state_max,
                           char *unit_out, int unit_max, char *err_out) {
    int fd = tcp_connect_timeout(ip_be, port, 4);
    if (fd < 0) {
        s_copy(err_out, "TCP connect failed", 64);
        return -1;
    }

    char req[768];
    s_copy(req, "GET /api/states/", sizeof(req));
    s_cat(req, entity_id, sizeof(req));
    s_cat(req, " HTTP/1.0\r\nHost: ", sizeof(req));
    s_cat(req, host_hdr, sizeof(req));
    s_cat(req, "\r\nAuthorization: Bearer ", sizeof(req));
    s_cat(req, token, sizeof(req));
    s_cat(req, "\r\nConnection: close\r\n\r\n", sizeof(req));

    sock_send(fd, req, s_len(req));

    char resp[4096];
    int total = 0;
    while (total < (int)sizeof(resp) - 1) {
        fd_set rfds;
        m_zero(&rfds, sizeof(rfds));
        rfds.fds_bits[fd >> 5] |= (1U << (fd & 31));
        struct timeval tv = { 4, 0 };
        if (sys_select(fd + 1, &rfds, NULL, NULL, &tv) <= 0) break;
        int n = (int)sock_recv(fd, resp + total, sizeof(resp) - 1 - total);
        if (n <= 0) break;
        total += n;
    }
    sys_close(fd);
    resp[total] = '\0';

    if (total == 0) {
        s_copy(err_out, "Empty HTTP response", 64);
        return -1;
    }

    if (s_ncmp(resp, "HTTP/1.", 7) != 0) {
        s_copy(err_out, "Invalid HTTP response", 64);
        return -1;
    }
    const char *sp = s_find(resp, " ");
    int code = sp ? parse_int(sp + 1) : 0;
    if (code != 200) {
        char cbuf[16];
        int_to_str(code, cbuf);
        s_copy(err_out, "HTTP ", 64);
        s_cat(err_out, cbuf, 64);
        return -1;
    }

    const char *body = s_find(resp, "\r\n\r\n");
    if (!body) body = resp; else body += 4;

    if (extract_json_str(body, "state", state_out, state_max) != 0) {
        s_copy(err_out, "No state in JSON", 64);
        return -1;
    }
    extract_json_str(body, "unit_of_measurement", unit_out, unit_max);
    return 0;
}

typedef struct {
    int enable;
    char url[128];
    char token[320];
    int corner;
    int invert;
    int interval;
    int layout;
    char sensors[256];
} ha_config_t;

static void load_config(ha_config_t *cfg) {
    m_zero(cfg, sizeof(*cfg));
    cfg->corner = 2;
    cfg->interval = 30;

    char buf[1024];
    int fd = sys_open("/tmp/config/ha_osd.conf", O_RDONLY, 0);
    if (fd < 0) return;
    int n = sys_read(fd, buf, sizeof(buf) - 1);
    sys_close(fd);
    if (n <= 0) return;
    buf[n] = '\0';

    const char *p = buf;
    while (*p) {
        char line[512];
        int i = 0;
        while (*p && *p != '\n' && *p != '\r' && i < (int)sizeof(line) - 1) line[i++] = *p++;
        line[i] = '\0';
        while (*p == '\n' || *p == '\r') p++;

        const char *eq = s_find(line, "=");
        if (!eq) continue;
        int klen = (int)(eq - line);
        const char *val = eq + 1;
        if (klen == 6 && s_ncmp(line, "enable", 6) == 0) cfg->enable = parse_int(val);
        else if (klen == 3 && s_ncmp(line, "url", 3) == 0) s_copy(cfg->url, val, sizeof(cfg->url));
        else if (klen == 5 && s_ncmp(line, "token", 5) == 0) s_copy(cfg->token, val, sizeof(cfg->token));
        else if (klen == 6 && s_ncmp(line, "corner", 6) == 0) cfg->corner = parse_int(val);
        else if (klen == 6 && s_ncmp(line, "invert", 6) == 0) cfg->invert = parse_int(val);
        else if (klen == 8 && s_ncmp(line, "interval", 8) == 0) cfg->interval = parse_int(val);
        else if (klen == 6 && s_ncmp(line, "layout", 6) == 0) cfg->layout = parse_int(val);
        else if (klen == 7 && s_ncmp(line, "sensors", 7) == 0) s_copy(cfg->sensors, val, sizeof(cfg->sensors));
    }
    if (cfg->interval < 5) cfg->interval = 5;
    if (cfg->interval > 3600) cfg->interval = 3600;
}

static void get_video_osd_info(int *osd_en, int *osd_corner) {
    *osd_en = 0; *osd_corner = 0;
    char buf[512];
    int fd = sys_open("/server/video.ini", O_RDONLY, 0);
    if (fd < 0) return;
    int n = sys_read(fd, buf, sizeof(buf) - 1);
    sys_close(fd);
    if (n <= 0) return;
    buf[n] = '\0';

    const char *osd_sec = s_find(buf, "[osd]");
    if (!osd_sec) return;
    const char *en = s_find(osd_sec, "enable=");
    if (en) *osd_en = parse_int(en + 7);
    const char *cor = s_find(osd_sec, "corner=");
    if (cor) *osd_corner = parse_int(cor + 7);
}

static int parse_url(const char *url, char *host, int hmax, uint16_t *port, char *err) {
    const char *p = url;
    if (s_ncmp(p, "https://", 8) == 0) {
        s_copy(err, "HTTPS not supported; use http://LAN_IP:8123", 64);
        return -1;
    }
    if (s_ncmp(p, "http://", 7) == 0) p += 7;
    int i = 0;
    while (*p && *p != ':' && *p != '/' && i < hmax - 1) host[i++] = *p++;
    host[i] = '\0';
    if (i == 0) {
        s_copy(err, "Empty HA URL", 64);
        return -1;
    }
    if (*p == ':') {
        *port = (uint16_t)parse_int(p + 1);
        if (*port == 0) *port = 8123;
    } else {
        *port = 80;
    }
    return 0;
}

static int run_once(int print_json) {
    ha_config_t cfg;
    load_config(&cfg);

    if (!cfg.enable || !cfg.url[0] || !cfg.sensors[0]) {
        /* Disable overlay */
        int fd = sys_open("/tmp/ha_osd.tmp", O_WRONLY | O_CREAT | O_TRUNC, 0644);
        if (fd >= 0) {
            sys_write(fd, "0 2 0 0\n", 8);
            sys_close(fd);
            sys_rename("/tmp/ha_osd.tmp", "/tmp/ha_osd.txt");
        }
        if (print_json) {
            const char *msg = "{\"status\":\"ok\",\"enabled\":false,\"lines\":[]}\n";
            sys_write(1, msg, s_len(msg));
        }
        return 0;
    }

    char host[96], err[64];
    uint16_t port = 8123;
    err[0] = '\0';
    if (parse_url(cfg.url, host, sizeof(host), &port, err) != 0) {
        if (print_json) {
            char j[160];
            s_copy(j, "{\"status\":\"error\",\"message\":\"", sizeof(j));
            s_cat(j, err, sizeof(j));
            s_cat(j, "\"}\n", sizeof(j));
            sys_write(1, j, s_len(j));
        }
        return -1;
    }

    uint32_t ip_be = 0;
    if (resolve_host(host, &ip_be) != 0) {
        if (print_json) {
            const char *msg = "{\"status\":\"error\",\"message\":\"DNS resolve failed\"}\n";
            sys_write(1, msg, s_len(msg));
        }
        return -1;
    }

    char host_hdr[112];
    char pbuf[16];
    int_to_str(port, pbuf);
    s_copy(host_hdr, host, sizeof(host_hdr));
    s_cat(host_hdr, ":", sizeof(host_hdr));
    s_cat(host_hdr, pbuf, sizeof(host_hdr));

    char lines[4][128];
    int num_lines = 0;
    char combined[256];
    combined[0] = '\0';

    const char *sp = cfg.sensors;
    int s_idx = 0;
    while (*sp && s_idx < 4) {
        char item[128];
        int k = 0;
        while (*sp && *sp != ';' && k < (int)sizeof(item) - 1) item[k++] = *sp++;
        item[k] = '\0';
        if (*sp == ';') sp++;
        if (k == 0) continue;

        /* Parse entity_id|label|unit */
        char entity[64], label[48], unit_ovr[16];
        entity[0] = label[0] = unit_ovr[0] = '\0';
        const char *ip = item;
        int j = 0;
        while (*ip && *ip != '|' && j < 63) entity[j++] = *ip++;
        entity[j] = '\0';
        if (*ip == '|') {
            ip++; j = 0;
            while (*ip && *ip != '|' && j < 47) label[j++] = *ip++;
            label[j] = '\0';
        }
        if (*ip == '|') {
            ip++; j = 0;
            while (*ip && *ip != '|' && j < 15) unit_ovr[j++] = *ip++;
            unit_ovr[j] = '\0';
        }
        if (!entity[0]) continue;

        char state[48], unit_ha[24], serr[64];
        state[0] = unit_ha[0] = serr[0] = '\0';
        int rc = fetch_ha_sensor(ip_be, port, host_hdr, cfg.token, entity,
                                 state, sizeof(state), unit_ha, sizeof(unit_ha), serr);

        char entry[128];
        entry[0] = '\0';
        if (label[0]) {
            s_cat(entry, label, sizeof(entry));
            s_cat(entry, " ", sizeof(entry));
        }
        if (rc == 0) {
            s_cat(entry, state, sizeof(entry));
            const char *u = unit_ovr[0] ? unit_ovr : unit_ha;
            if (u[0]) s_cat(entry, u, sizeof(entry));
        } else {
            s_cat(entry, "ERR", sizeof(entry));
        }

        if (cfg.layout == 1) {
            if (combined[0]) s_cat(combined, " | ", sizeof(combined));
            s_cat(combined, entry, sizeof(combined));
        } else {
            s_copy(lines[num_lines++], entry, 128);
        }
        s_idx++;
    }

    if (cfg.layout == 1 && combined[0]) {
        s_copy(lines[0], combined, 128);
        num_lines = 1;
    }

    int osd_en = 0, osd_corner = 0;
    get_video_osd_info(&osd_en, &osd_corner);
    int offset_y = (osd_en && osd_corner == cfg.corner) ? 28 : 0;

    char out[768];
    char b1[16], b2[16], b3[16], b4[16];
    int_to_str(num_lines > 0 ? 1 : 0, b1);
    int_to_str(cfg.corner, b2);
    int_to_str(cfg.invert, b3);
    int_to_str(offset_y, b4);

    s_copy(out, b1, sizeof(out));
    s_cat(out, " ", sizeof(out));
    s_cat(out, b2, sizeof(out));
    s_cat(out, " ", sizeof(out));
    s_cat(out, b3, sizeof(out));
    s_cat(out, " ", sizeof(out));
    s_cat(out, b4, sizeof(out));
    s_cat(out, "\n", sizeof(out));

    for (int i = 0; i < num_lines; i++) {
        s_cat(out, lines[i], sizeof(out));
        s_cat(out, "\n", sizeof(out));
    }

    int fd = sys_open("/tmp/ha_osd.tmp", O_WRONLY | O_CREAT | O_TRUNC, 0644);
    if (fd >= 0) {
        sys_write(fd, out, s_len(out));
        sys_close(fd);
        sys_rename("/tmp/ha_osd.tmp", "/tmp/ha_osd.txt");
    }

    if (print_json) {
        char json[768];
        s_copy(json, "{\"status\":\"ok\",\"enabled\":true,\"lines\":[", sizeof(json));
        for (int i = 0; i < num_lines; i++) {
            if (i > 0) s_cat(json, ",", sizeof(json));
            s_cat(json, "\"", sizeof(json));
            s_cat(json, lines[i], sizeof(json));
            s_cat(json, "\"", sizeof(json));
        }
        s_cat(json, "]}\n", sizeof(json));
        sys_write(1, json, s_len(json));
    }
    return 0;
}

__asm__(
".text\n"
".global _start\n"
"_start:\n"
"    mov r0, sp\n"
"    b main_entry\n"
);

static int hex_val(char c) {
    if (c >= '0' && c <= '9') return c - '0';
    if (c >= 'a' && c <= 'f') return c - 'a' + 10;
    if (c >= 'A' && c <= 'F') return c - 'A' + 10;
    return -1;
}

static void url_decode_print(const char *s) {
    char out[1024];
    int i = 0;
    while (*s && i < (int)sizeof(out) - 1) {
        if (*s == '+') {
            out[i++] = ' ';
            s++;
        } else if (*s == '%' && s[1] && s[2]) {
            int hi = hex_val(s[1]), lo = hex_val(s[2]);
            if (hi >= 0 && lo >= 0) {
                out[i++] = (char)((hi << 4) | lo);
                s += 3;
                continue;
            }
            out[i++] = *s++;
        } else {
            out[i++] = *s++;
        }
    }
    sys_write(1, out, i);
}

void main_entry(unsigned long *sp) {
    int argc = (int)sp[0];
    char **argv = (char **)&sp[1];

    if (argc >= 3 && s_cmp(argv[1], "--urldecode") == 0) {
        url_decode_print(argv[2]);
        sys_exit(0);
    }

    if (argc >= 2 && s_cmp(argv[1], "--once") == 0) {
        int rc = run_once(1);
        sys_exit(rc == 0 ? 0 : 1);
    }

    while (1) {
        ha_config_t cfg;
        load_config(&cfg);
        run_once(0);
        struct timespec ts = { cfg.interval, 0 };
        sys_nanosleep(&ts, NULL);
    }
}
