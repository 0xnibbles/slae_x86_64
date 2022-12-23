

global _start

section .data

	message: db "Hello World!"
	mlen:	equ $-message


_start:
	
	; print hello world on the screen

	mov rax, 0x1
	mov rdi, 0x1
	mov rsi, message
	mov rdx, mlen
	syscall


	; exit the program gracefully

	mov rax, 0x3c
	mov rdi, 0x5
	syscall


