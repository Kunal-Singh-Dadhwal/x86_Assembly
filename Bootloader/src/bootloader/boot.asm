ORG 0x7C00
BITS 16

jmp short main
nop

bdb_oem: db "MSWIN4.1"
bdb_byte_per_sector: dw 512
bdb_sectors_per_cluster: db 1
bdb_reserved_sectors: dw 1
bdb_fat_count: db 1
bdb_dir_entries_count: dw 0E0h
bdb_total_sectors: dw 2880
bdb_media_descriptor_type: db 0F0h
bdb_sectors_per_fat: dw 9
bdb_sector_per_track: dw 18
bdb_heads: dw 2
bdb_hidden_sectors: dd 0
bdb_large_secotr_count: dd 0

ebr_drive_number:   db 0
                    db 0
ebr_signature: db 29h
ebr_volume_id: db 12h,34h,56h,78h
ebr_volume_label: db "UwUntu"
ebr_system_id: db "FAT12"
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
