build:
	mkdir -p build
	nasm src/boot.asm -f bin -o build/boot.bin
