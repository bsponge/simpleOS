[org 0x7c00]

	mov bp, 0x9000
	mov sp, bp

	mov bx, MSG_REAL_MODE
	call print_string

	call switch_to_pm

	jmp $

%include "src/print/print_16bit.asm"
%include "src/print/print_32bit.asm"
%include "src/protected_mode/gdt.asm"
%include "src/protected_mode/switch_to_32bit.asm"

[bits 32]

BEGIN_PM:
	mov ebx, MSG_PROT_MODE
	call print_string_pm

	jmp $

MSG_REAL_MODE db "Started in 16-bit Real mode", 0
MSG_PROT_MODE db "Successfully landed in 32-bit Protected Mode", 0


times 510-($-$$) db 0
dw 0xaa55

