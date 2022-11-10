[org 0x7c00]

mov dx, 0xbeef
call print_hex_16bit

jmp $

%include "print.asm"

times 510-($-$$) db 0
dw 0xaa55