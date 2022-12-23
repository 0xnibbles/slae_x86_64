#!/bin/bash

filename="${1%%.*}" # remove .asm extension

echo
echo "[*] Compiling with NASM"
if [[ $file == *.asm ]]; then

	nasm -f elf64 -o ${filename}".o" ${filename}".asm"

else 
	nasm -f elf64 -o ${filename}".o" ${filename}".nasm"

fi

echo "[*] Linking"
ld ${filename}".o" -o ${filename}

echo "[*] Extracting opcodes"

echo "[*] Done"

echo

#opcodes=$(objdump -d ${filename} |grep '[0-9a-f]:'|grep -v 'file'|cut -f2 -d:|cut -f1-12 -d' '|tr -s ' '|tr '\t' ' '|sed 's/ $//g'|sed 's/ /\\x/g'|paste -d '' -s |sed 's/^/"/'|sed 's/$/"/g')

opcodes=$(for i in $(objdump -d ${filename} -M intel |grep "^ " |cut -f2); do echo -n '\x'$i; done;echo) # alternative way to get shellcode opcodes or mnemonics

size=$(echo -ne $opcodes | tr -d '"' | wc -c)

echo
echo "Shellcode size: $size"

echo
echo '"'$opcodes'"'

echo
echo "--------------------"
echo "[*] Hack the World!"
echo "--------------------"
echo



