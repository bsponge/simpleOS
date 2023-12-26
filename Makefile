C_SOURCES = $(wildcard src/kernel/*.c src/drivers/*.c src/utils/*.c)
ASM_SOURCES = $(wildcard src/kernel/*.asm)
C_OBJ = $(patsubst src/%.c, build/%.o, $(C_SOURCES))
ASM_OBJ = $(patsubst src/%.asm, build/%.o, $(ASM_SOURCES))

.PHONY: build-docker-image
build-docker-image:
	docker build -t builder .

.PHONY: build-os-image
build-os-image: clear build-docker-image
	mkdir -p build
	docker run -v ./build:/output builder

.PHONY: build
build: prepare-dirs os-image

.PHONY: os-image
os-image: build/boot.bin build/kernel.bin
	cat $^ > build/os-image

.PHONY: build/boot.bin
build/boot.bin:
	nasm src/boot/boot.asm -i src/boot -f bin -o build/boot.bin

.PHONY: build/kernel.bin
build/kernel.bin: build/kernel_entry.o ${C_OBJ} ${ASM_OBJ}
	ld -m elf_i386 -o $@ -Ttext 0x1000 $^ --oformat binary

.PHONY: build/%.o
build/%.o : src/%.c
	gcc -m32 -fno-pie -ffreestanding -Isrc -c $< -o $@

.PHONY: build/%.o
build/%.o : src/%.asm
	nasm $< -f elf32 -o $@

.PHONY: build/kernel_entry.o
build/kernel_entry.o:
	nasm src/boot/kernel_entry.asm -f elf32 -o build/kernel_entry.o

.PHONY: clear
clear:
	rm -rf build/*

.PHONY: prepare-dirs
prepare-dirs:
	mkdir -p build/boot
	mkdir -p build/kernel
	mkdir -p build/drivers
	mkdir -p build/utils
