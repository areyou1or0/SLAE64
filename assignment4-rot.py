def ror(val, rot):
	return ((val & 0xff) >> rot % 8 ) | (val << ( 8 - (rot % 8)) & 0xff)

def main():
	shellcode = (".....shellcode-here.....")
	encoded = ""

	i = len(bytearray(shellcode))
	for x in bytearray(shellcode):
		y = ror(((x+13)^i),2) 

		encoded += "0x"
		encoded += "%02x," % y
		i -= 1
	print "\t",encoded[:-1]

if __name__ == "__main__":
    main()
