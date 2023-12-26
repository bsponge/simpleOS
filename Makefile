C_SOURCES = $(wildcard src/kernel/*.c src/drivers/*.c)
HEADERS = $(wildcard src/kernel/*.h src/drviers/*.h)
OBJ = $(patsubst src/%.c, build/%.o, $(C_SOURCES))

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
build/kernel.bin: build/kernel_entry.o ${OBJ}
	ld -m elf_i386 -o $@ -Ttext 0x1000 $^ --oformat binary

.PHONY: build/%.o
build/%.o : src/%.c ${HEADERS}
	gcc -m32 -fno-pie -ffreestanding -Isrc -c $< -o $@

.PHONY: build/%.o
build/%.o : src/boot/%.asm
	nasm $< -f elf32 -o $@

.PHONY: build/%.bin
build/%.bin : src/boot/%.asm
	nasm $< -i src/boot -f bin -o $@

.PHONY: clear
clear:
	rm -rf build/*

.PHONY: prepare-dirs
prepare-dirs:
	mkdir -p build/boot
	mkdir -p build/kernel
	mkdir -p build/drivers
