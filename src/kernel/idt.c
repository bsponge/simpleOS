#include "drivers/screen.h"
#include "kernel/idt.h"

#include <stdint.h>

extern void* isr_stub_table[];

void exception_handler() {
	char *msg = "INTERRUPT!\n";
	print(msg);
}

void idt_set_descriptor(uint8_t vector, void* isr, uint8_t flags) {
    idt_entry_t* descriptor = &idt[vector];
 
    descriptor->isr_low        = (uint32_t)isr & 0xFFFF;
    descriptor->kernel_cs      = 0x08; // this value can be whatever offset your kernel code selector is in your GDT
    descriptor->attributes     = flags;
    descriptor->isr_high       = (uint32_t)isr >> 16;
    descriptor->reserved       = 0;
}

void idt_init() {
    idtr.base = (uintptr_t)&idt[0];
    idtr.limit = (uint16_t)sizeof(idt_entry_t) * 256 - 1;

    char *msg = "before loop!\n";
    print(msg);

    for (uint8_t vector = 0; vector < 32; vector++) {
	    idt_set_descriptor(vector, isr_stub_table[vector], 0x8E);
    }

    char *msg1 = "after loop!\n";
    print(msg1);

    __asm__ volatile ("lidt %0" : : "m"(idtr)); // load the new IDT
    __asm__ volatile ("sti"); // set the interrupt flag
}
