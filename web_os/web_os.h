#include <stdarg.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdlib.h>

typedef enum LaunchAppFFI {
  YouTube,
  Netflix,
  AmazonPrimeVideo,
} LaunchAppFFI;

typedef enum MediaPlayerButtonFFI {
  PLAY,
  PAUSE,
} MediaPlayerButtonFFI;

typedef enum MotionButtonKeyFFI {
  HOME,
  BACK,
  UP,
  DOWN,
  LEFT,
  RIGHT,
  ENTER,
  GUIDE,
  QMENU,
} MotionButtonKeyFFI;

typedef struct WebOsNetworkInfoFFI {
  const char *name;
  const char *ip;
  const char *mac;
} WebOsNetworkInfoFFI;

void debug_mode(void);

void connect_to_tv(struct WebOsNetworkInfoFFI network_info, int64_t isolate_port);

void load_last_tv_info(int64_t isolate_port);

void turn_on(struct WebOsNetworkInfoFFI info, int64_t isolate_port);

void discovery_tv(int64_t isolate_port);

void turn_off(int64_t isolate_port);

void increment_volume(int64_t isolate_port);

void decrease_volume(int64_t isolate_port);

void set_mute(bool mute, int64_t isolate_port);

void increment_channel(int64_t isolate_port);

void decrease_channel(int64_t isolate_port);

void pressed_button(enum MotionButtonKeyFFI key, int64_t isolate_port);

void pressed_media_player_button(enum MediaPlayerButtonFFI key, int64_t isolate_port);

void launch_app(enum LaunchAppFFI app, int64_t isolate_port);

void pointer_move_it(float dx, float dy, bool drag, int64_t isolate_port);

void pointer_scroll(float dx, float dy, int64_t isolate_port);

void pointer_click(int64_t isolate_port);
