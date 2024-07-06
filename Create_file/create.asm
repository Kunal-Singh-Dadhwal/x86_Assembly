section .data
    filename db './output.txt', 0     
    msg db "This was from asm!",0AH,0DH

section .bss
    fd resq 1                       

section .text
    global _start

_start:
    mov rax, 2                       
    mov rdi, filename              
    mov rsi, 0x241                      
    mov rdx, 700o 
    syscall                        
    mov [fd], rax                   

    mov rax, 1                           
    mov rdi, [fd]                      
    mov rsi, msg                       
    mov rdx, 21 
    syscall                            

    mov rax, 3                           
    mov rdi, [fd]                      
    syscall                            

    mov rax, 60                          
    mov rdi, 0
    syscall                            

