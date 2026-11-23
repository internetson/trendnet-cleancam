/*
 * Standalone RTSP Streaming Server for Trendnet TV-IP121W
 * Target: ARMv4 Linux 2.4 OABI (Zero external dependencies)
 * Video: RFC 2435 MJPEG (PT 26)
 * Audio: RFC 3551 PCMU 8kHz Mono (PT 0)
 * Auth: RTSP Basic Authentication (admin / admin)
 * Transports: TCP Interleaved (RTP/AVP/TCP) & UDP Unicast (RTP/AVP)
 */

#define NULL ((void*)0)

typedef unsigned char uint8_t;
typedef short int16_t;
typedef unsigned short uint16_t;
typedef unsigned int uint32_t;
typedef int ssize_t;
typedef unsigned int size_t;

/* Linux 2.4 ARM OABI system calls */
static inline long sys_exit(int code) {
    register long r0 __asm__("r0") = code;
    __asm__ __volatile__("swi 0x900001" : : "r"(r0) : "memory");
    return 0;
}

static inline int sys_fork(void) {
    register long res __asm__("r0");
    __asm__ __volatile__("swi 0x900002" : "=r"(res) : : "memory");
    return (int)res;
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

static inline int sys_close(int fd) {
    register long r0 __asm__("r0") = fd;
    register long res __asm__("r0");
    __asm__ __volatile__("swi 0x900006" : "=r"(res) : "r"(r0) : "memory");
    return (int)res;
}

struct timespec {
    long tv_sec;
    long tv_nsec;
};

static inline int sys_nanosleep(const struct timespec *req, struct timespec *rem) {
    register long r0 __asm__("r0") = (long)req;
    register long r1 __asm__("r1") = (long)rem;
    register long res __asm__("r0");
    __asm__ __volatile__("swi 0x9000a2" : "=r"(res) : "r"(r0), "r"(r1) : "memory");
    return (int)res;
}

/* Linux 2.4 ARM sys_wait4 (swi 0x900072) */
static inline int sys_wait4(int pid, int *status, int options, void *rusage) {
    register long r0 __asm__("r0") = pid;
    register long r1 __asm__("r1") = (long)status;
    register long r2 __asm__("r2") = options;
    register long r3 __asm__("r3") = (long)rusage;
    register long res __asm__("r0");
    __asm__ __volatile__("swi 0x900072" : "=r"(res) : "r"(r0), "r"(r1), "r"(r2), "r"(r3) : "memory");
    return (int)res;
}

/* Linux 2.4 ARM OABI sys_socketcall (SWI 0x900066) */
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
#define SO_REUSEADDR 2
#define MSG_DONTWAIT 0x40

struct sockaddr_in {
    uint16_t sin_family;
    uint16_t sin_port;
    uint32_t sin_addr;
    uint8_t sin_zero[8];
};

static inline int sock_create(void) {
    unsigned long a[3] = { AF_INET, SOCK_STREAM, 0 };
    return (int)sys_socketcall(1, a);
}

static inline int sock_create_udp(void) {
    unsigned long a[3] = { AF_INET, SOCK_DGRAM, 0 };
    return (int)sys_socketcall(1, a);
}

static inline int sock_bind(int fd, struct sockaddr_in *addr) {
    unsigned long a[3] = { (unsigned long)fd, (unsigned long)addr, sizeof(struct sockaddr_in) };
    return (int)sys_socketcall(2, a);
}

static inline int sock_connect(int fd, struct sockaddr_in *addr) {
    unsigned long a[3] = { (unsigned long)fd, (unsigned long)addr, sizeof(struct sockaddr_in) };
    return (int)sys_socketcall(3, a);
}

static inline int sock_listen(int fd, int backlog) {
    unsigned long a[2] = { (unsigned long)fd, (unsigned long)backlog };
    return (int)sys_socketcall(4, a);
}

static inline int sock_accept(int fd, struct sockaddr_in *addr, int *addrlen) {
    unsigned long a[3] = { (unsigned long)fd, (unsigned long)addr, (unsigned long)addrlen };
    return (int)sys_socketcall(5, a);
}

static inline ssize_t sock_recv(int fd, void *buf, size_t len, int flags) {
    unsigned long a[4] = { (unsigned long)fd, (unsigned long)buf, (unsigned long)len, (unsigned long)flags };
    return (ssize_t)sys_socketcall(10, a);
}

static inline ssize_t sock_sendto(int fd, const void *buf, size_t len, int flags, struct sockaddr_in *addr) {
    unsigned long a[6] = {
        (unsigned long)fd,
        (unsigned long)buf,
        (unsigned long)len,
        (unsigned long)flags,
        (unsigned long)addr,
        sizeof(struct sockaddr_in)
    };
    return (ssize_t)sys_socketcall(11, a);
}

static inline int sock_setsockopt(int fd, int level, int optname, const void *optval, int optlen) {
    unsigned long a[5] = { (unsigned long)fd, (unsigned long)level, (unsigned long)optname, (unsigned long)optval, (unsigned long)optlen };
    return (int)sys_socketcall(14, a);
}

/* String & Memory operations */
static void *my_memset(void *s, int c, size_t n) {
    uint8_t *p = (uint8_t*)s;
    while (n--) *p++ = (uint8_t)c;
    return s;
}

static void *my_memcpy(void *dest, const void *src, size_t n) {
    uint8_t *d = (uint8_t*)dest;
    const uint8_t *s = (const uint8_t*)src;
    while (n--) *d++ = *s++;
    return dest;
}

static size_t my_strlen(const char *s) {
    size_t len = 0;
    while (*s++) len++;
    return len;
}

static int my_strncmp(const char *s1, const char *s2, size_t n) {
    while (n && *s1 && (*s1 == *s2)) {
        s1++; s2++; n--;
    }
    if (n == 0) return 0;
    return *(const unsigned char*)s1 - *(const unsigned char*)s2;
}

static char *my_strstr(const char *haystack, const char *needle) {
    if (!*needle) return (char*)haystack;
    for (; *haystack; haystack++) {
        if (*haystack == *needle) {
            const char *h = haystack;
            const char *n = needle;
            while (*h && *n && *h == *n) { h++; n++; }
            if (!*n) return (char*)haystack;
        }
    }
    return NULL;
}

static void *my_memmem(const void *haystack, size_t haystacklen, const void *needle, size_t needlelen) {
    if (needlelen == 0 || haystacklen < needlelen) return NULL;
    const uint8_t *h = (const uint8_t*)haystack;
    const uint8_t *n = (const uint8_t*)needle;
    size_t limit = haystacklen - needlelen;
    for (size_t i = 0; i <= limit; i++) {
        if (h[i] == n[0]) {
            size_t k = 1;
            while (k < needlelen && h[i + k] == n[k]) k++;
            if (k == needlelen) return (void*)(h + i);
        }
    }
    return NULL;
}

static void my_sleep_ms(int ms) {
    struct timespec ts;
    ts.tv_sec = ms / 1000;
    ts.tv_nsec = (ms % 1000) * 1000000L;
    sys_nanosleep(&ts, NULL);
}

static inline uint16_t htons(uint16_t v) {
    return (uint16_t)((v << 8) | (v >> 8));
}

static inline uint32_t htonl(uint32_t v) {
    return ((v >> 24) & 0xff) | ((v >> 8) & 0xff00) | ((v << 8) & 0xff0000) | ((v << 24) & 0xff000000);
}

/* Linear PCM to G.711 u-law */
static uint8_t linear2ulaw(int16_t sample) {
    const int BIAS = 0x84;
    const int CLIP = 32635;
    int sign = 0;
    if (sample < 0) {
        sample = -sample;
        sign = 0x80;
    }
    if (sample > CLIP) sample = CLIP;
    sample += BIAS;

    int exp = 7;
    for (int i = 0; i < 7; i++) {
        if (sample < (0x100 << i)) {
            exp = i;
            break;
        }
    }
    int mantissa = (sample >> (exp + 3)) & 0x0F;
    return (uint8_t)(~(sign | (exp << 4) | mantissa));
}

/* Connect to local web server on 127.0.0.1:80 */
static int connect_local_stream(const char *path) {
    int fd = sock_create();
    if (fd < 0) return -1;
    
    struct sockaddr_in addr;
    my_memset(&addr, 0, sizeof(addr));
    addr.sin_family = AF_INET;
    addr.sin_port = htons(80);
    addr.sin_addr = htonl(0x7F000001); // 127.0.0.1
    
    if (sock_connect(fd, &addr) < 0) {
        sys_close(fd);
        return -1;
    }
    
    char req[256];
    char *p = req;
    const char *p1 = "GET ";
    while (*p1) *p++ = *p1++;
    while (*path) *p++ = *path++;
    const char *p2 = " HTTP/1.0\r\nAuthorization: Basic YWRtaW46YWRtaW4=\r\n\r\n";
    while (*p2) *p++ = *p2++;
    
    sys_write(fd, req, p - req);
    return fd;
}

/* RTP packet buffer */
static uint8_t rtp_pkt[2048];

static void send_rtp_interleaved(int rtsp_fd, uint8_t channel, const uint8_t *payload, size_t payload_len) {
    uint8_t hdr[4];
    hdr[0] = '$';
    hdr[1] = channel;
    hdr[2] = (uint8_t)((payload_len >> 8) & 0xff);
    hdr[3] = (uint8_t)(payload_len & 0xff);
    sys_write(rtsp_fd, hdr, 4);
    sys_write(rtsp_fd, payload, payload_len);
}

static void send_packet(int is_audio, int rtsp_fd, int udp_fd, int transport_mode,
                        struct sockaddr_in *v_dst, struct sockaddr_in *a_dst,
                        int v_ch, int a_ch, const uint8_t *payload, size_t payload_len) {
    if (transport_mode == 1) { // TCP interleaved
        send_rtp_interleaved(rtsp_fd, is_audio ? a_ch : v_ch, payload, payload_len);
    } else { // UDP unicast
        if (udp_fd >= 0) {
            sock_sendto(udp_fd, payload, payload_len, 0, is_audio ? a_dst : v_dst);
        }
    }
}

static void run_stream_session(int rtsp_fd, struct sockaddr_in *peer_addr, int transport_mode,
                               int v_cport, int a_cport, int v_ch, int a_ch) {
    int v_fd = connect_local_stream("/cgi/mjpg.cgi");
    int a_fd = connect_local_stream("/cgi/audio/audio.cgi");
    
    if (v_fd < 0) {
        return;
    }
    
    int udp_fd = -1;
    struct sockaddr_in v_dst, a_dst;
    if (transport_mode == 2) { // UDP
        udp_fd = sock_create_udp();
        my_memset(&v_dst, 0, sizeof(v_dst));
        v_dst.sin_family = AF_INET;
        v_dst.sin_addr = peer_addr->sin_addr;
        v_dst.sin_port = htons(v_cport);
        
        my_memset(&a_dst, 0, sizeof(a_dst));
        a_dst.sin_family = AF_INET;
        a_dst.sin_addr = peer_addr->sin_addr;
        a_dst.sin_port = htons(a_cport);
    }
    
    uint16_t v_seq = 100;
    uint32_t v_ts = 1000;
    uint16_t a_seq = 200;
    uint32_t a_ts = 2000;
    
    static uint8_t vbuf[128 * 1024];
    size_t vbuf_len = 0;
    static uint8_t abuf[16384];
    size_t abuf_len = 0;
    
    const uint8_t soi[2] = { 0xFF, 0xD8 };
    const uint8_t eoi[2] = { 0xFF, 0xD9 };
    const uint8_t sof0[2] = { 0xFF, 0xC0 };
    const uint8_t sos[2] = { 0xFF, 0xDA };
    
    int audio_tick = 0;
    
    while (1) {
        /* Check if RTSP TCP control connection closed */
        char probe[16];
        ssize_t pr = sock_recv(rtsp_fd, probe, sizeof(probe), MSG_DONTWAIT);
        if (pr == 0) {
            break; // Client closed RTSP session
        }
        
        /* 1. Read Video non-blocking */
        ssize_t vn = sock_recv(v_fd, vbuf + vbuf_len, sizeof(vbuf) - vbuf_len - 1, MSG_DONTWAIT);
        if (vn > 0) {
            vbuf_len += vn;
            
            /* Search for complete JPEG frame */
            uint8_t *start = (uint8_t*)my_memmem(vbuf, vbuf_len, soi, 2);
            if (start) {
                size_t offset_from_start = start - vbuf;
                uint8_t *end = (uint8_t*)my_memmem(start, vbuf_len - offset_from_start, eoi, 2);
                if (end) {
                    end += 2; // include EOI
                    size_t frame_total = end - start;
                    
                    /* Parse dimensions from SOF0 */
                    int width = 640, height = 480;
                    uint8_t *sof = (uint8_t*)my_memmem(start, frame_total, sof0, 2);
                    if (sof && (sof + 9 < end)) {
                        height = (sof[5] << 8) | sof[6];
                        width = (sof[7] << 8) | sof[8];
                    }

                    /* Extract Quantization Tables (DQT) */
                    uint8_t qtables[128];
                    int has_qtables = 0;
                    const uint8_t dqt_sig[2] = { 0xFF, 0xDB };
                    uint8_t *dqt_ptr = (uint8_t*)my_memmem(start, frame_total, dqt_sig, 2);
                    if (dqt_ptr && (dqt_ptr + 4 < end)) {
                        int dqt_len = (dqt_ptr[2] << 8) | dqt_ptr[3];
                        if (dqt_len >= 132 && (dqt_ptr + 2 + dqt_len <= end)) {
                            my_memcpy(qtables, dqt_ptr + 5, 64);
                            my_memcpy(qtables + 64, dqt_ptr + 70, 64);
                            has_qtables = 1;
                        }
                    }
                    
                    /* Locate Start of Scan (SOS) marker */
                    uint8_t *sos_ptr = (uint8_t*)my_memmem(start, frame_total, sos, 2);
                    if (sos_ptr && (sos_ptr + 4 < end)) {
                        int sos_len = (sos_ptr[2] << 8) | sos_ptr[3];
                        uint8_t *scan_data = sos_ptr + 2 + sos_len;
                        uint8_t *scan_end = end - 2; // exclude trailing EOI for RFC 2435
                        
                        if (scan_end > scan_data) {
                            size_t total_scan = scan_end - scan_data;
                            size_t offset = 0;
                            size_t max_chunk = 1200;
                            
                            while (offset < total_scan) {
                                size_t chunk = total_scan - offset;
                                int is_first = (offset == 0);
                                size_t extra_hdr = (is_first && has_qtables) ? 132 : 0;
                                if (chunk > max_chunk - extra_hdr) chunk = max_chunk - extra_hdr;
                                int is_last = (offset + chunk >= total_scan);
                                
                                uint8_t *p = rtp_pkt;
                                p[0] = 0x80;
                                p[1] = 26 | (is_last ? 0x80 : 0x00);
                                p[2] = (uint8_t)((v_seq >> 8) & 0xff);
                                p[3] = (uint8_t)(v_seq & 0xff);
                                v_seq++;
                                p[4] = (uint8_t)((v_ts >> 24) & 0xff);
                                p[5] = (uint8_t)((v_ts >> 16) & 0xff);
                                p[6] = (uint8_t)((v_ts >> 8) & 0xff);
                                p[7] = (uint8_t)(v_ts & 0xff);
                                p[8] = 0x12; p[9] = 0x34; p[10] = 0x56; p[11] = 0x78;
                                
                                /* RFC 2435 Main JPEG header (8 bytes) */
                                p[12] = 0;                                  /* Type-specific */
                                p[13] = (uint8_t)((offset >> 16) & 0xff);   /* Fragment offset */
                                p[14] = (uint8_t)((offset >> 8) & 0xff);
                                p[15] = (uint8_t)(offset & 0xff);
                                p[16] = 1;                                  /* Type: 1 = JPEG 4:2:0 */
                                p[17] = has_qtables ? 128 : 80;             /* Q: 128 = in-band custom DQT */
                                p[18] = (uint8_t)(width / 8);               /* Width in 8-pixel blocks */
                                p[19] = (uint8_t)(height / 8);              /* Height in 8-pixel blocks */
                                
                                uint8_t *dst = p + 20;
                                if (is_first && has_qtables) {
                                    /* RFC 2435 Quantization Table header (4 bytes) */
                                    dst[0] = 0;                             /* MBZ */
                                    dst[1] = 0;                             /* Precision: 8-bit */
                                    dst[2] = 0;                             /* Length MSB */
                                    dst[3] = 128;                           /* Length LSB: 128 bytes */
                                    my_memcpy(dst + 4, qtables, 128);
                                    dst += 132;
                                }
                                
                                my_memcpy(dst, scan_data + offset, chunk);
                                size_t total_len = (size_t)(dst + chunk - p);
                                send_packet(0, rtsp_fd, udp_fd, transport_mode, &v_dst, &a_dst, v_ch, a_ch, rtp_pkt, total_len);
                                offset += chunk;
                            }
                            v_ts += 3000; /* ~30 fps (90000 / 30) */
                        }
                    }
                    
                    size_t consumed = (end - vbuf);
                    if (vbuf_len > consumed) {
                        my_memcpy(vbuf, end, vbuf_len - consumed);
                        vbuf_len -= consumed;
                    } else {
                        vbuf_len = 0;
                    }
                }
            } else if (vbuf_len > 64 * 1024) {
                vbuf_len = 0;
            }
        } else if (vn == 0) {
            break;
        }
        
        /* 2. Audio: PCMU 8000Hz (160 samples per 20ms) */
        if (a_fd >= 0 && sizeof(abuf) > abuf_len) {
            ssize_t an = sock_recv(a_fd, abuf + abuf_len, sizeof(abuf) - abuf_len, MSG_DONTWAIT);
            if (an > 0) {
                abuf_len += an;
            }
        }
        
        /* Parse complete multipart frames from abuf */
        while (1) {
            uint8_t *hdr_end = (uint8_t*)my_memmem(abuf, abuf_len, "\r\n\r\n", 4);
            if (!hdr_end) {
                if (abuf_len > 12000) abuf_len = 0;
                break;
            }
            size_t body_offset = (hdr_end + 4) - abuf;
            if (abuf_len < body_offset + 28) {
                break; // wait for more data
            }
            
            uint8_t *frame_hdr = abuf + body_offset;
            // Check if this is the initial HTTP header response:
            if (!my_strncmp((char*)frame_hdr, "--myboundary", 12)) {
                size_t skip = body_offset;
                if (abuf_len > skip) {
                    my_memcpy(abuf, abuf + skip, abuf_len - skip);
                    abuf_len -= skip;
                } else {
                    abuf_len = 0;
                }
                continue;
            }
            
            uint32_t pcm_len = frame_hdr[4] | (frame_hdr[5] << 8) | (frame_hdr[6] << 16) | (frame_hdr[7] << 24);
            if (pcm_len == 0 || pcm_len > 4000) {
                pcm_len = 3840;
            }
            
            size_t total_frame = 28 + pcm_len;
            if (abuf_len < body_offset + total_frame) {
                break; // incomplete frame, wait for more bytes
            }
            
            int16_t *pcm_in = (int16_t*)(frame_hdr + 28);
            size_t samples_in = pcm_len / 2;
            
            /* Immediately packetize and send all samples in 160-sample (20ms) RTP packets */
            for (size_t offset = 0; offset < samples_in; offset += 160) {
                size_t chunk = samples_in - offset;
                if (chunk > 160) chunk = 160;
                
                uint8_t *ap = rtp_pkt;
                ap[0] = 0x80;
                ap[1] = 0x00; // PT=0 (PCMU)
                ap[2] = (uint8_t)((a_seq >> 8) & 0xff);
                ap[3] = (uint8_t)(a_seq & 0xff);
                a_seq++;
                ap[4] = (uint8_t)((a_ts >> 24) & 0xff);
                ap[5] = (uint8_t)((a_ts >> 16) & 0xff);
                ap[6] = (uint8_t)((a_ts >> 8) & 0xff);
                ap[7] = (uint8_t)(a_ts & 0xff);
                ap[8] = 0x99; ap[9] = 0x88; ap[10] = 0x77; ap[11] = 0x66;
                
                for (size_t s = 0; s < chunk; s++) {
                    ap[12 + s] = linear2ulaw(pcm_in[offset + s]);
                }
                
                send_packet(1, rtsp_fd, udp_fd, transport_mode, &v_dst, &a_dst, v_ch, a_ch, rtp_pkt, 12 + chunk);
                a_ts += chunk;
            }
            
            size_t consumed = body_offset + total_frame;
            if (abuf_len > consumed) {
                my_memcpy(abuf, abuf + consumed, abuf_len - consumed);
                abuf_len -= consumed;
            } else {
                abuf_len = 0;
            }
        }
        
        /* Yield CPU: sleep briefly if no video data arrived */
        if (vn <= 0) {
            my_sleep_ms(5);
        } else {
            my_sleep_ms(1);
        }
    }
    
    if (v_fd >= 0) sys_close(v_fd);
    if (a_fd >= 0) sys_close(a_fd);
    if (udp_fd >= 0) sys_close(udp_fd);
}

/* Authentication check */
static int is_authorized(const char *req) {
    const char *auth = my_strstr(req, "Authorization: Basic ");
    if (!auth) auth = my_strstr(req, "authorization: basic ");
    if (!auth) auth = my_strstr(req, "Authorization: basic ");
    if (!auth) return 0;
    auth += 21;
    /* Compare with "YWRtaW46YWRtaW4=" (admin:admin) */
    if (!my_strncmp(auth, "YWRtaW46YWRtaW4=", 16)) {
        return 1;
    }
    return 0;
}

static void handle_client(int fd, struct sockaddr_in *peer_addr) {
    char req[2048];
    char resp[2048];
    
    int transport_mode = 1; // 1 = TCP, 2 = UDP
    int video_client_port = 5000;
    int audio_client_port = 5002;
    int video_interleaved_ch = 0;
    int audio_interleaved_ch = 2;
    
    while (1) {
        ssize_t n = sys_read(fd, req, sizeof(req) - 1);
        if (n <= 0) break;
        req[n] = 0;
        
        char cseq_str[16] = "1";
        char *cs = my_strstr(req, "CSeq: ");
        if (cs) {
            cs += 6;
            int idx = 0;
            while (*cs >= '0' && *cs <= '9' && idx < 15) {
                cseq_str[idx++] = *cs++;
            }
            cseq_str[idx] = 0;
        }
        
        if (!my_strncmp(req, "OPTIONS", 7)) {
            char *r = resp;
            const char *h1 = "RTSP/1.0 200 OK\r\nCSeq: ";
            while (*h1) *r++ = *h1++;
            char *c = cseq_str;
            while (*c) *r++ = *c++;
            const char *tail = "\r\nPublic: OPTIONS, DESCRIBE, SETUP, TEARDOWN, PLAY\r\n\r\n";
            while (*tail) *r++ = *tail++;
            sys_write(fd, resp, r - resp);
        }
        else {
            /* Require authentication for DESCRIBE, SETUP, PLAY */
            if (!is_authorized(req)) {
                char *r = resp;
                const char *h1 = "RTSP/1.0 401 Unauthorized\r\nCSeq: ";
                while (*h1) *r++ = *h1++;
                char *c = cseq_str;
                while (*c) *r++ = *c++;
                const char *tail = "\r\nWWW-Authenticate: Basic realm=\"TV-IP121W RTSP\"\r\n\r\n";
                while (*tail) *r++ = *tail++;
                sys_write(fd, resp, r - resp);
                continue;
            }
            
            if (!my_strncmp(req, "DESCRIBE", 8)) {
                const char *sdp = 
                    "v=0\r\n"
                    "o=- 100 1 IN IP4 0.0.0.0\r\n"
                    "s=Trendnet TV-IP121W RTSP\r\n"
                    "t=0 0\r\n"
                    "m=video 0 RTP/AVP 26\r\n"
                    "c=IN IP4 0.0.0.0\r\n"
                    "a=control:track1\r\n"
                    "a=rtpmap:26 JPEG/90000\r\n"
                    "m=audio 0 RTP/AVP 0\r\n"
                    "c=IN IP4 0.0.0.0\r\n"
                    "a=control:track2\r\n"
                    "a=rtpmap:0 PCMU/8000/1\r\n";
                
                int sdp_len = my_strlen(sdp);
                char *r = resp;
                const char *h1 = "RTSP/1.0 200 OK\r\nCSeq: ";
                while (*h1) *r++ = *h1++;
                char *c = cseq_str;
                while (*c) *r++ = *c++;
                const char *h2 = "\r\nContent-Type: application/sdp\r\nContent-Length: ";
                while (*h2) *r++ = *h2++;
                
                char lstr[16];
                int lidx = 0;
                int temp = sdp_len;
                if (temp == 0) lstr[lidx++] = '0';
                else {
                    char rev[16];
                    int ridx = 0;
                    while (temp > 0) {
                        rev[ridx++] = '0' + (temp % 10);
                        temp /= 10;
                    }
                    while (ridx > 0) lstr[lidx++] = rev[--ridx];
                }
                lstr[lidx] = 0;
                c = lstr;
                while (*c) *r++ = *c++;
                *r++ = '\r'; *r++ = '\n'; *r++ = '\r'; *r++ = '\n';
                
                const char *s = sdp;
                while (*s) *r++ = *s++;
                sys_write(fd, resp, r - resp);
            }
            else if (!my_strncmp(req, "SETUP", 5)) {
                int is_audio = (my_strstr(req, "track2") != NULL);
                int is_tcp = (my_strstr(req, "interleaved") != NULL) ||
                             (my_strstr(req, "TCP") != NULL) ||
                             (my_strstr(req, "tcp") != NULL);
                
                char *r = resp;
                const char *h1 = "RTSP/1.0 200 OK\r\nCSeq: ";
                while (*h1) *r++ = *h1++;
                char *c = cseq_str;
                while (*c) *r++ = *c++;
                const char *h2 = "\r\nSession: 87654321\r\nTransport: ";
                while (*h2) *r++ = *h2++;
                
                if (is_tcp) {
                    transport_mode = 1;
                    char *int_ptr = my_strstr(req, "interleaved=");
                    int ch = is_audio ? 2 : 0;
                    if (int_ptr) {
                        int_ptr += 12;
                        ch = *int_ptr - '0';
                    }
                    if (is_audio) audio_interleaved_ch = ch;
                    else video_interleaved_ch = ch;
                    
                    const char *t_str = is_audio ?
                        "RTP/AVP/TCP;unicast;interleaved=2-3\r\n\r\n" :
                        "RTP/AVP/TCP;unicast;interleaved=0-1\r\n\r\n";
                    while (*t_str) *r++ = *t_str++;
                } else {
                    transport_mode = 2; // UDP unicast
                    char port_buf[32] = "5000-5001";
                    char *cp = my_strstr(req, "client_port=");
                    int p_val = is_audio ? 5002 : 5000;
                    if (cp) {
                        cp += 12;
                        char *end_p = cp;
                        while (*end_p && *end_p != ';' && *end_p != '\r' && *end_p != '\n') end_p++;
                        size_t plen = end_p - cp;
                        if (plen > 0 && plen < 30) {
                            my_memcpy(port_buf, cp, plen);
                            port_buf[plen] = 0;
                        }
                        int p = 0;
                        char *np = cp;
                        while (*np >= '0' && *np <= '9') {
                            p = p * 10 + (*np - '0');
                            np++;
                        }
                        if (p > 0) p_val = p;
                    }
                    if (is_audio) audio_client_port = p_val;
                    else video_client_port = p_val;
                    
                    const char *t1 = "RTP/AVP;unicast;client_port=";
                    while (*t1) *r++ = *t1++;
                    char *pb = port_buf;
                    while (*pb) *r++ = *pb++;
                    const char *t2 = is_audio ?
                        ";server_port=50002-50003\r\n\r\n" :
                        ";server_port=50000-50001\r\n\r\n";
                    while (*t2) *r++ = *t2++;
                }
                
                sys_write(fd, resp, r - resp);
            }
            else if (!my_strncmp(req, "PLAY", 4)) {
                char *r = resp;
                const char *h1 = "RTSP/1.0 200 OK\r\nCSeq: ";
                while (*h1) *r++ = *h1++;
                char *c = cseq_str;
                while (*c) *r++ = *c++;
                const char *h2 = "\r\nSession: 87654321\r\nRange: npt=0.000-\r\n\r\n";
                while (*h2) *r++ = *h2++;
                sys_write(fd, resp, r - resp);
                
                run_stream_session(fd, peer_addr, transport_mode,
                                   video_client_port, audio_client_port,
                                   video_interleaved_ch, audio_interleaved_ch);
                break;
            }
            else if (!my_strncmp(req, "TEARDOWN", 8)) {
                char *r = resp;
                const char *h1 = "RTSP/1.0 200 OK\r\nCSeq: ";
                while (*h1) *r++ = *h1++;
                char *c = cseq_str;
                while (*c) *r++ = *c++;
                const char *h2 = "\r\n\r\n";
                while (*h2) *r++ = *h2++;
                sys_write(fd, resp, r - resp);
                break;
            }
            else {
                sys_write(fd, "RTSP/1.0 400 Bad Request\r\n\r\n", 28);
                break;
            }
        }
    }
    sys_close(fd);
    sys_exit(0);
}

void _start(void) {
    int listen_fd = sock_create();
    if (listen_fd < 0) sys_exit(1);
    
    int opt = 1;
    sock_setsockopt(listen_fd, SOL_SOCKET, SO_REUSEADDR, &opt, sizeof(opt));
    
    struct sockaddr_in srv_addr;
    my_memset(&srv_addr, 0, sizeof(srv_addr));
    srv_addr.sin_family = AF_INET;
    srv_addr.sin_port = htons(554);
    srv_addr.sin_addr = 0;
    
    if (sock_bind(listen_fd, &srv_addr) < 0) {
        sys_exit(2);
    }
    
    if (sock_listen(listen_fd, 5) < 0) {
        sys_exit(3);
    }
    
    while (1) {
        /* Reap any zombie children */
        while (sys_wait4(-1, NULL, 1 /* WNOHANG */, NULL) > 0) {}
        
        struct sockaddr_in client_addr;
        int addrlen = sizeof(client_addr);
        int client_fd = sock_accept(listen_fd, &client_addr, &addrlen);
        if (client_fd >= 0) {
            int pid = sys_fork();
            if (pid == 0) {
                sys_close(listen_fd);
                handle_client(client_fd, &client_addr);
            } else {
                sys_close(client_fd);
            }
        }
    }
}
