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

void turn_off(void);

void increment_volume(void);

void decrease_volume(void);

void set_mute(bool mute);

void increment_channel(void);

void decrease_channel(void);

void pressed_button(enum MotionButtonKeyFFI key);

void pressed_media_player_button(enum MediaPlayerButtonFFI key);

void launch_app(enum LaunchAppFFI app);

void pointer_move_it(float dx, float dy, bool drag);

void pointer_scroll(float dx, float dy);

void pointer_click(void);
