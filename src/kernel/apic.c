#include "kernel/apic.h"

#include <stdint.h>

uint64_t get_tsc_frequency() {
	uint32_t lo, hi;
	__asm__ __volatile__ (
			"xorl %%eax, %%eax\n"
			"cpuid\n"
			"rdtsc"
			: "=a" (lo), "=d" (hi)
			:
			: "%ebx", "%ecx");
	return (uint64_t)hi << 32 | lo;
}

