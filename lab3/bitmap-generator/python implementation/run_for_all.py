import os
import shutil
import sys
import glob
import filecmp

originFolder = "pbm"
destinationFolder = "bit"
program_name = "python converter.py"
arguments = ""

# files ending on .bit or .exclude are ignored
files = list(set(glob.glob(originFolder + "/*")) - set(glob.glob(originFolder + "/*.bit")) - set(glob.glob(originFolder + "/*.exclude")))
prefix_lenght = len(originFolder + "/")

for i, val in enumerate(files):
	files[i] = files[i][prefix_lenght:]

for filename in files:
	os.system(program_name + " " + originFolder + "/" + filename + arguments)
	shutil.move(originFolder + "/" + filename + ".bit", destinationFolder + "/" + filename + ".bit")

print
print program_name + " was run for all files in the directory " + originFolder		
