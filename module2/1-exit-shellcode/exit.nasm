

global _start

section .text

	


_start:
	
	; print hello world on the screen

	mov rax, 0x1
	mov rdi, 0x1
	mov rsi, message
	mov rdx, mlen
	syscall


	; exit the program gracefully

	mov rax, 0x3c	; 60 - exit syscall
	mov rdi, 0x5	; exit code
	syscall

	message: db "Hello World!"
	mlen:	equ $-message

