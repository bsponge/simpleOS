#include "drivers/screen.h"
#include "idt/idt.h"
#include "kernel/pic.h"

#include <stdint.h>
int counter = 0;

void exception_handler(struct interrupt_frame *frame) {
	/*
	char *msg = "INTERRUPT: %d!\n";
	printf(msg, counter);
	counter++;
	*/
}

__attribute__((interrupt)) void keyboard_handler(struct interrupt_frame *frame) {
	//printf("KEYBOARD PRESSED %d\n", counter);
	print("pressed\n");
	counter++;
	PIC_sendEOI();
}

/*
void exception_handler() {
	char *msg = "INTERRUPT: %d!\n";
	printf(msg, counter);
	counter++;
}
*/

void setup_idt_entry(struct interrupt_descriptor* entry, void (*isr_function)(), uint16_t selector, uint8_t type_attr) {
	uint32_t isr_address = (uint32_t)isr_function;
	entry->offset_low = isr_address & 0xFFFF;
	entry->selector = selector;
	entry->zero = 0;
	entry->type_attr = type_attr;
	entry->offset_high = (isr_address >> 16) & 0xFFFF;
}

void init_idt() {
	uint16_t size = 256;
	for (uint16_t i = 0; i < size; i++) {
		setup_idt_entry(&idt[i], exception_handler, 0x08, 0x8E);
	}

	//setup_idt_entry(&idt[32], keyboard_handler, 0x08, 0x8E);
	setup_idt_entry(&idt[33], keyboard_handler, 0x08, 0x8E);
	//setup_idt_entry(&idt[34], keyboard_handler, 0x08, 0x8E);

	struct {
		uint16_t limit;
		uint32_t base;
	} __attribute__((packed)) idt_descriptor;



	// Set the size and base address of the IDT
	idt_descriptor.limit = 8*(size - 1);
	idt_descriptor.base = (uint32_t)idt;

	__asm__ volatile ("lidt %0" : : "m"(idt_descriptor)); // load the new IDT
	__asm__ volatile ("sti"); // set the interrupt flag
}
