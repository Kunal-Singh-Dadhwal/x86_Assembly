BITS 16

section _text class=CODE

global _x86_Video_WriteCharTeletype
_x86_Video_WriteCharTeletype:
    push bp
    mov bp, sp

    push bx
    mov ah, 0EH
    mov al, [bp+4]
    mov bh, [bp+6]
    int 10h
    pop bx
    mov sp, bp
    pop bp 
    ret
