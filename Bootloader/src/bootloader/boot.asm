ORG 0x7C00
BITS 16

jmp short main
nop

bdb_oem: db 'MSWIN4.1'          ;Disk Headers
bdb_byte_per_sector: dw 512
bdb_sectors_per_cluster: db 1
bdb_reserved_sectors: dw 1
bdb_fat_count: db 2
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
ebr_volume_id: db 12h, 34h, 56h, 78h
ebr_volume_label: db ' UwUntu '
ebr_system_id: db 'FAT12  '
main:
    mov ax, 0
    mov ds, ax
    mov es, ax
    mov ss, ax

    mov sp, 0x7C00

    mov si, boot_msg
    call print


    mov [ebr_drive_number], dl      ;Reading disk sector
    mov al, 1
    mov cl, 1
    mov bx, 0x7E00
    call disk_read

    mov si, boot_msg
    call print
    
    ;4 segments
    ;reserved_sector: 1
    ;FAT 18 sectors
    ;root dir
    ;Data

    mov ax, [bdb_sectors_per_fat]
    mov bl, [bdb_fat_count]
    xor bh, bh
    mul bx
    add ax, [bdb_reserved_sectors]  ;LBA of root
    push ax

    mov ax, [bdb_dir_entries_count]
    shl ax, 5
    xor dx, dx
    div word [bdb_byte_per_sector]  ;(32*num of entries)/bytes per sector
    test dx, dx
    jz root_dir_after
    inc ax


root_dir_after:
    mov cl, al
    pop ax
    mov dl, [ebr_drive_number]
    mov bx, buffer
    call disk_read

    xor bx, bx
    mov di, buffer
    
search_kernel:
    mov si, file_kernel_bin
    mov cx, 11
    push di
    repe cmpsb
    pop di
    je foundkernel
    
    add di, 32
    inc bx
    cmp bx, [bdb_dir_entries_count]
    jl search_kernel

    jmp kernelnotfound

kernelnotfound: 
    mov si, msg_kernel_not_found
    call print
    hlt 
    jmp halt

foundkernel:
    mov ax, [di+26]
    mov [kernel_cluster], ax
    
    mov ax, [bdb_reserved_sectors]
    mov bx, buffer
    mov cl, [bdb_sectors_per_fat]
    mov dl, [ebr_drive_number]
    call disk_read
    mov bx, kernel_load_segment
    mov es, bx
    mov bx, kernel_load_offset

loadkernelloop:
    mov ax, [kernel_cluster]
    add ax, 31
    mov cl, 1
    mov dl, [ebr_drive_number]
    call disk_read
    add bx, [bdb_byte_per_sector]

    mov ax, [kernel_cluster]    ;(kernel_cluster * 3)/2
    mov cx, 3
    mul cx 
    mov cx, 2
    div cx

    mov si, buffer
    add si, ax
    mov ax, [ds:si]

    or dx, dx
    jz even

odd: 
    shr ax, 4
    jmp nextclusterafter

even:
    and ax, 0x0FFF

nextclusterafter:
    cmp ax, 0x0FF8
    jae readFinish

    mov [kernel_cluster], ax
    jmp loadkernelloop

readFinish:
    mov dl, [ebr_drive_number]
    mov ax, kernel_load_segment
    mov ds, ax
    mov es, ax

    jmp kernel_load_segment:kernel_load_offset

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

boot_msg: db 'Our OS has booted!', 0x0D, 0x0A, 0
read_failure db 'Failed to read disk', 0x0D, 0x0A, 0
file_kernel_bin db 'KERNEL  BIN'
msg_kernel_not_found db 'KERNEL.BIN not found!'
kernel_cluster dw 0

kernel_load_segment equ 0x2000
kernel_load_offset equ 0


TIMES 510-($-$$) db 0
DW 0AA55h 

buffer: 
    
