#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>

#if _WIN32
#include <windows.h>
#else
#include <pthread.h>
#include <unistd.h>
#endif

#if _WIN32
#define FFI_PLUGIN_EXPORT __declspec(dllexport)
#else
#define FFI_PLUGIN_EXPORT
#endif

void connect_to_tv();
void increment_volume();
void decrease_volume();
void set_mute(bool mute);
void debug_mode();

enum ButtonFFI {
    home,
    back,
    up,
    down,
    left,
    right,
    enter,
};
void move_control(ButtonFFI b);
