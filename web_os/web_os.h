#include <stdarg.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdlib.h>

typedef enum LaunchAppFFI {
  YouTube,
  Netflix,
  AmazonPrimeVideo,
} LaunchAppFFI;

typedef enum MidiaPlayerButtonFFI {
  PLAY,
  PAUSE,
} MidiaPlayerButtonFFI;

typedef enum MotionButtonKeyFFI {
  HOME,
  BACK,
  UP,
  DOWN,
  LEFT,
  RIGHT,
  ENTER,
} MotionButtonKeyFFI;

void debug_mode(void);

void connect_to_tv(const char *address, const char *key);

void increment_volume(void);

void decrease_volume(void);

void set_mute(bool mute);

void pressed_button(enum MotionButtonKeyFFI key);

void pressed_midia_player_button(enum MidiaPlayerButtonFFI key);

void launch_app(enum LaunchAppFFI app);

void pointer_move_it(float dx, float dy, bool drag);

void pointer_scroll(float dx, float dy);

void pointer_click(void);
