import sys
header = "P4\n128\n128\n"

def check_args():
	""" checks if a file was supplied to the script """
	if len(sys.argv) != 2:
		print "need the filename, dumb dumb"
		exit()
	else: 
		return sys.argv[1]


filename = check_args()

try:
	f = open(filename, 'r')
except IOError:
	print "Failed to open '" + filename
	exit()

bytes_read = open(filename, "rb").read()
newFile = open(filename + ".pbm", "wb")
newFile.write((header).encode('ascii'))
newFile.write(bytes_read)
newFile.close()

print filename + " was converted. (WOLOLO)"
