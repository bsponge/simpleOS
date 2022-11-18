[org 0x7c00]

KERNEL_OFFSET equ 0x1000

	mov [BOOT_DRIVE], dl

	mov bp, 0x9000
	mov sp, bp

	mov bp, MSG_REAL_MODE
	call print_string

	call load_kernel

	call switch_to_pm

	jmp $

[bits 16]

load_kernel:
	mov bx, MSG_LOAD_KERNEL
	call print_string

	mov bx, KERNEL_OFFSET
	mov dh, 1
	mov dl, [BOOT_DRIVE]
	call disk_load

	ret

[bits 32]

BEGIN_PM:
	mov ebx, MSG_PROT_MODE
	call print_string_pm

	call KERNEL_OFFSET

	jmp $

BOOT_DRIVE	db 0
MSG_LOAD_KERNEL	db "Loading kernel into memory.", 0
MSG_REAL_MODE	db "Started in 16-bit Real mode", 0
MSG_PROT_MODE	db "Successfully landed in 32-bit Protected Mode", 0

%include "src/print/print_16bit.asm"
%include "src/print/print_32bit.asm"
%include "src/disk_load.asm"
%include "src/protected_mode/gdt.asm"
%include "src/protected_mode/switch_to_32bit.asm"

times 510-($-$$) db 0
dw 0xaa55

