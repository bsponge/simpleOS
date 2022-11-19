C_SOURCES = $(wildcard kernel/*.c drivers/*.c)
HEADERS = $(wildcard kernel/*.h drviers/*.h)
OBJ = ${C_SOURCES:.c=.o}


.PHONY: build-binary
build-binary: build/kernel_entry.o build/kernel.o ${OBJ}
	mkdir -p build
	nasm src/boot/boot.asm -i src/boot -f bin -o build/boot.bin
	ld -m elf_i386 -o build/kernel.bin -Ttext 0x1000 $^ --oformat binary
	cat build/boot.bin build/kernel.bin > build/os-image
	cp build/os-image /mnt/c/Program\ Files/qemu/

.PHONY: build/kernel.o
build/kernel.o:
	gcc -m32 -fno-pie -ffreestanding -c src/kernel/kernel.c -o build/kernel.o

.PHONY: build/kernel_entry.o
build/kernel_entry.o:
	nasm src/boot/kernel_entry.asm -f elf32 -o build/kernel_entry.o

.PHONY: build/%.o
build/%.o : %.c
	gcc -m32 -fno-pie -ffreestanding -c $< -o $@

.PHONY: clear
clear:
	rm -rf build/*


