[org 0x7c00]

mov bx, HELLO_MSG
call print_string

mov bx, SPACE
call print_string

mov bx, GOODBYE_MSG
call print_string

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

HELLO_MSG:
    db "Hello world", 0

GOODBYE_MSG:
    db "Goodbye world", 0

SPACE:
    db " ", 0

times 510-($-$$) db 0
dw 0xaa55