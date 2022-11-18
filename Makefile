build-binary:
	mkdir -p build
	nasm src/boot.asm -i src -f bin -o build/boot.bin
	gcc -ffreestanding -c src/kernel.c -o build/kernel.o
	ld -o build/kernel.bin -Ttext 0x1000 build/kernel.o --oformat binary
	cat build/boot.bin build/kernel.bin > build/os-image
	cp build/os-image /mnt/c/Program\ Files/qemu/
