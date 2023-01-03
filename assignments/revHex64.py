#!usr/bin/python3
'''
Author: Eduardo Silva aka 0xnibbles
Date: 09/2022
Version: 1.0
'''

import argparse
import binascii

parser = argparse.ArgumentParser(description='[*] Reverting ascii strings into Intel 64-bit hex format.')
parser.add_argument('string', metavar='string', type=ascii, help='The string to be converted')

args = parser.parse_args()


# --- Functions ---

def find_slashes(string):

    if string.find('/') > -1:
        ocurrences_index = [i for i in range(len(string)) if string.startswith('/',i)]
        for i in range(len(ocurrences_index)):
            if i != len(ocurrences_index)-1:
                bytes_size = ocurrences_index[i+1] - ocurrences_index[i]
                if bytes_size < 8: # if there is not 8 bytes between slashes
                    print(ocurrences_index)
                    return ocurrences_index[i]
            else: # if reaches the last slash. must align in this index
                return ocurrences_index[i]
 
    return -1 # no slashes in the string


# -------------------------

# banner with  Ascii Art

print('''
_____________________________________________
< The x86_64 "Little-Hexdian" String Converter >
---------------------------------------------
	\   ^__^
	 \  (oo)\_______
	    (__)\       )\/\\
		||----w |
		||     ||	
    ''')

#----------------------------

string = args.string[1:-1].decode('string_escape')



#---------------------
'''
Checking if the string size will be memory aligned. This will prevent any further unintended behaviour.
'''

print("Input String length: {}".format(len(string)))

input_remainder = len(string) % 8

if input_remainder > 0:
    print("\nStack needs to be aligned!")
    alignment_bytes = (8 - input_remainder) + len(string)
    print("\n[*] Aligned string size is: {}".format(alignment_bytes))
else:
    print("\n[*] Stack is aligned")

# ---------------------------------

# Find if the string ahs slashes and append it if needs to align it
# if finds a slash appends in that idnex position. if not adds to the beginning of the string

'''
if input_remainder > 0:
        index = find_slashes(string)
        if index  > -1:
            string = string[:index] + (8-input_remainder)*'/' + string[index:]
        else:
            string = string + ((8-input_remainder)*'/')
'''
print("[*] Final String: {}\n".format(string))

print("[*] Converting it ...\n")

stringList= [string[index:index+8] for index in range(0,len(string),8)]

# revert and output string in qword groups with hex values

print("* * * * * * * * * *\n") 

for qword in stringList[::-1]:
  
    print(qword[::-1]+ ' : 0x'+ str(binascii.hexlify(qword[::-1].encode('utf-8')),'ascii'))

print("\n* * * * * * * * * *")

print("\n--------------------")
print("[*] Hack the World!")
print("--------------------")
print()






