#include <stdint.h>

struct interrupt_descriptor {
	uint16_t offset_low;
	uint16_t selector;
	uint8_t  zero;
	uint8_t  type_attr;
	uint16_t offset_high;
} __attribute__((packed));

static struct interrupt_descriptor idt[256];

struct interrupt_frame
{
	uint16_t ip;
	uint16_t cs;
	uint16_t flags;
	uint16_t sp;
	uint16_t ss;
} __attribute__((packed));

//void exception_handler(struct interrupt_frame *frame);
void exception_handler(struct interrupt_frame *);
void keyboard_handler();
void setup_idt_entry(struct interrupt_descriptor* entry, void (*isr_function)(), uint16_t selector, uint8_t type_attr);
void idt_set_descriptor(uint8_t vector, void* isr, uint8_t flags);
void init_idt();
