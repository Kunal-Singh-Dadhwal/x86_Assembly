ORG 0x7C00
BITS 16

jmp short main
nop

bdb_oem: db "MSWIN4.1"          ;Disk Headers
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

;extended boot record
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

    mov [ebr_drive_number], dl      ;Reading disk sector
    mov al, 1
    mov cl, 1
    mov bx, 0x7E00
    call disk_read

    mov si, boot_msg
    call print

    hlt

halt:
    jmp halt

;input LBA index in ax
;cx [bits 0 - 5]: sector number
;cx [bits 6 - 15]: cylinder
;dh: head

lba_to_chs:
    push ax
    push dx
    xor dx, dx
    div word [bdb_sector_per_track]     ;(LBA % sector_per_track) + 1 = sector 
    inc dx
    mov cx, dx

    xor dx, dx
    div word [bdb_heads]
    
    mov dh, dl      ;head: (LBA/ sector per track) % number of heads
    mov cl, al
    shl ah, 6
    or cl, ah       ;cylinder: (LBA/ sector per track)/ number of heads
    
    pop ax
    mov dl, al
    pop ax
    ret
disk_read:
    push ax
    push bx
    push cx
    push dx
    push di

    call lba_to_chs
    mov ah, 2

    mov dl, 3       ;counter

retry:
    stc
    int 13h
    jnc done_read
    
    call disk_reset
    dec di
    test di, di
    jnz retry

fail_disk_read:
    mov si, read_failure
    call print
    hlt
    jmp halt

disk_reset:
    pusha
    mov ah, 0
    stc
    int 13h
    jc fail_disk_read
    popa
    ret

done_read:
    pop di
    pop dx
    pop cx
    pop bx 
    pop ax
    ret
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
read_failure db "Failed to read disk", 0x0D, 0x0A, 0
DW 0AA55h 
