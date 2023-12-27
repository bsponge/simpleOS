#include <stdarg.h>

#define VIDEO_ADDRESS 0xb8000
#define MAX_ROWS 25
#define MAX_COLS 80
#define WHITE_ON_BLACK 0x0f

#define REG_SCREEN_CTRL 0x3d4
#define REG_SCREEN_DATA 0x3d5

int get_cursor();
int get_screen_offset(int col, int row);
void set_cursor(int offset);
int handle_scrolling(int offset);
void print_at(char *message, int col, int row);
void print(char *message);
void printf(char *format, ...);
