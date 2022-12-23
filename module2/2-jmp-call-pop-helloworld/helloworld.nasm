

global _start

section .text

	


_start:
	
	; print hello world on the screen


	jmp call_shellcode


shellcode:
	pop	rsi

	xor rax, rax
	mov al, 0x1
	mov rdi, rax
	mov rdx, mlen
	syscall


	; exit the program gracefully

	xor rax, rax
	mov rax, 0x3c	; 60 - exit syscall
	xor rdi, rdi	; exit code
	syscall

call_shellcode:
	call shellcode
	message: db "Hello World!"
	mlen:	equ $-message

