#include "drivers/screen.h"
#include "kernel/low_level.h"
#include "kernel/idt.h"
#include "kernel/pic.h"

void main() {
	char *video_memory = (char *) 0xb8000;

	// clear screen
	for (int i = 0; i < 80*25; i+=2) {
		*(video_memory+i) = ' ';
	}


	char *msg = "Hello World!\n";
	
	set_cursor(0);

	print(msg);
	print(msg);
	char *template = "format: %d str: %s\n";
	printf(template, 123, "random string");

	//idt_init();

	print(msg);

	//init_pic();

	print(msg);

}
