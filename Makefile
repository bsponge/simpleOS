build-binary:
	mkdir -p build
	nasm src/boot.asm -f bin -o build/boot.bin
	cp build/boot.bin /mnt/c/Program\ Files/qemu/
