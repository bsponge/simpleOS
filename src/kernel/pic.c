#include "kernel/pic.h"
#include "utils/utils.h"

#include <stdint.h>

// PIC initialization command words
#define PIC1_COMMAND 0x20
#define PIC2_COMMAND 0xA0
#define PIC1_DATA    0x21
#define PIC2_DATA    0xA1

void init_pic() {
	// Initialize master PIC
	outb(PIC1_COMMAND, 0x11);  // Start initialization sequence
	outb(PIC1_DATA, 0x20);     // Set master PIC base IRQ offset to 0x20
	outb(PIC1_DATA, 0x04);     // Tell master PIC that there is a slave PIC at IRQ2
	outb(PIC1_DATA, 0x01);     // Set PIC in 8086 mode

	// Initialize slave PIC
	outb(PIC2_COMMAND, 0x11);  // Start initialization sequence
	outb(PIC2_DATA, 0x28);     // Set slave PIC base IRQ offset to 0x28
	outb(PIC2_DATA, 0x02);     // Tell slave PIC its cascade identity
	outb(PIC2_DATA, 0x01);     // Set PIC in 8086 mode

	// Enable IRQs by unmasking interrupts
	outb(PIC1_DATA, 0x0);  // Unmask all interrupts on master PIC
	outb(PIC2_DATA, 0x0);  // Unmask all interrupts on slave PIC
}
