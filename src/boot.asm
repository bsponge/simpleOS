[org 0x7c00]

mov dx, 0xbeef
call print_hex_16bit

jmp $

print_string:
    mov al, [bx]
    cmp al, 0
    jne print_char
    ret

print_char:
    mov ah, 0x0e
    int 0x10

    add bx, 1
    jmp print_string

print_hex_16bit:
    pusha

    mov cx, 4
again:
    cmp cx, 0
    jne shift_and_write
    mov bx, HEX_OUT
    call print_string
    popa
    ret
shift_and_write:
    sub cx, 1
    mov ax, dx
    and ax, 0x000f
    cmp al, 9
    jle number
    jmp char
back:
    shr dx, 4
    mov bx, HEX_OUT
    add bx, 2
    add bx, cx
    mov [bx], al
    jmp again
number:
    add ax, 48
    jmp back
char:
    add ax, 55
    jmp back

HEX_OUT:
    db "0x0000", 0

times 510-($-$$) db 0
dw 0xaa55