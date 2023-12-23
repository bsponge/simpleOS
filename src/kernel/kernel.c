#include "drivers/screen.h"
#include "kernel/low_level.h"

void main() {
	char *video_memory = (char *) 0xb8000;

	for (int i = 0; i < 80*25; i+=2) {
		*(video_memory+i) = ' ';
	}


	char *msg = "Hello World!\n";
	/*
	for (int i = 0; msg[i/2] ; i+=2) {
		*(video_memory+i) = msg[i/2];
		*(video_memory+i+1) = WHITE_ON_BLACK;
	}
	*/
	set_cursor(0);

	print(msg);
	print(msg);
}
