

global _start

section .text

	


_start:
	
	; print hello world on the screen


	;pop	rsi
	xor rax, rax
	mov al, 0x1
	mov rdi, rax
	push 0x0a646c72
	mov rbx, 0x6f576f6c6c6568
	push rbx
	
	mov rsi, rsp
	mov rdx, 0xc	; with does not need to zero the stack before pushing args
	syscall


	; exit the program gracefully

	xor rax, rax
	mov rax, 0x3c	; 60 - exit syscall
	xor rdi, rdi	; exit code
	syscall