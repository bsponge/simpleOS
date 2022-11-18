build-binary:
	mkdir -p build
	#
	nasm src/boot.asm -i src -f bin -o build/boot.bin
	nasm src/kernel_entry.asm -f elf32 -o build/kernel_entry.o
	#
	gcc -m32 -fno-pie -ffreestanding -c src/kernel.c -o build/kernel.o
	#
	ld -m elf_i386 -o build/kernel.bin -Ttext 0x1000 build/kernel_entry.o build/kernel.o --oformat binary
	#
	cat build/boot.bin build/kernel.bin > build/os-image
	cp build/os-image /mnt/c/Program\ Files/qemu/
