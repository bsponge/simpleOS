mov bx, 30

cmp bx, 4
jle first
cmp bx, 40
jl second
jmp third

first:
    mov al, 'A'
    jmp then

second:
    mov al, 'B'
    jmp then

third:
    mov al, 'C'
    jmp then

then:
    mov ah, 0x0e
    int 0x10

    jmp $

times 510-($-$$) db 0
dw 0xaa55