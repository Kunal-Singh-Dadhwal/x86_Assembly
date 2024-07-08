ORG 0x7C00
BITS 16

main:
    mov ax, 0
    mov ds, ax
    mov es, ax
    mov ss, ax

    mov sp, 0x7C00
    mov si, boot_msg
    call print

    hlt

halt:
    jmp halt

print:
    push si
    push ax
    push bx

print_loop:
    lodsb 
    or al, al
    jz done_print

    mov ah, 0x0E
    mov bh, 0
    int 0x10    ;video interrupt

    jmp print_loop

done_print:
    pop bx
    pop ax
    pop si
    ret

boot_msg: db "Our OS has booted!", 0x0D, 0x0A, 0
TIMES 510-($-$$) db 0
DW 0AA55h 
