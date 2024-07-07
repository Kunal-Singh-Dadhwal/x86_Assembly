section .bss
    year resb 4
section .data
    prompt db "Enter a year:- ",0
    is_leap db " is a leap year.",10,0
    is_not_leap db " is not a leap year.",10,0
    buffer db 0
section .text
    global _start

_start:
    mov rax, 1
    mov rdi, 1
    mov rsi, prompt 
    mov rdx, 16
    syscall         ; Print the prompt
    
    mov rax, 0
    mov rdi, 0 
    mov rsi, year   ;Take in year
    mov rdx, 4
    syscall         
    
    movzx rax, byte [year]  
    sub rax, '0'
    movzx rbx, byte [year+1]
    sub rbx, '0'
    imul rax, rax, 10
    add rax, rbx
    movzx rbx, byte [year+2]
    sub rbx, '0'
    imul rax, rax, 10
    add rax, rbx
    movzx rbx, byte [year+3]
    sub rbx, '0'
    imul rax, rax, 10
    add rax, rbx     ;Convert to int

    mov rcx, rax
    mov rbx, 4
    xor rdx, rdx
    div rbx
    test rdx, rdx
    jnz _isnotleap   ;if not divisible by 4

    mov rcx, rax
    mov rbx, 100
    xor rdx, rdx
    div rbx
    test rdx, rdx
    jnz _isleap      ;if divisible by 4 and not divisible by 100

    mov rcx, rax
    mov rbx, 400
    xor rdx, rdx
    div rbx
    test rdx, rdx
    jnz _isnotleap   ;if not divisible by 400
    
    

_isleap:    
    mov rax, 1
    mov rdi, 1
    lea rsi, [year]
    mov rdx, 4
    syscall
    mov rax, 1
    mov rdi, 1 
    mov rsi, is_leap
    mov rdx, 18
    syscall
    mov rax, 60     
    mov rdi, 0
    syscall
_isnotleap:
    mov rax, 1
    mov rdi, 1
    lea rsi, [year]
    mov rdx, 4
    syscall
    mov rax, 1
    mov rdi, 1
    mov rsi, is_not_leap
    mov rdx, 22 
    syscall
    mov rax, 60
    mov rdi, 0
    syscall
