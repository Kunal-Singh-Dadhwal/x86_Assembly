section .data
    prompt db "Enter a string:-  "
    answer db "The reversed string is ",0

section .bss
    enteredstring resb 128
    enteredlen resb 1

section .text
    global _start

_start:
    mov rax, 1
    mov rdi, 1
    mov rsi, prompt
    mov rdx, 18
    syscall

    mov rax, 0
    mov rdi, 0
    mov rsi, enteredstring
    mov rdx, 128
    syscall
    
    mov rbx, rax
    dec rbx
    mov byte[enteredlen], bl


    mov rsi, enteredstring
    mov rcx, rbx
    shr rcx, 1
    mov rdi, rsi
    add rdi, rbx
    dec rdi
    
reverse:
    cmp rcx, 0
    je done
    mov al, [rsi]
    mov bl, [rdi]
    mov [rsi], bl            
    mov [rdi], al            
    inc rsi                  
    dec rdi                  
    dec rcx                  
    jmp reverse
 
done:
    mov rax, 1
    mov rdi, 1
    mov rsi, answer
    mov rdx, 24
    syscall
    mov rax, 1
    mov rdi, 1
    mov rsi, enteredstring
    mov rdx, rbx
    syscall

    mov rax, 60
    mov rdi, 0
    syscall

