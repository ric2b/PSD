#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <strings.h>
#include <math.h>
#include <stdint.h>

#define ROWSIZE	128
#define COLSIZE	128

int main(int argc, char *argv[]) 
{
	if(argc != 2)
	{
		puts("need 2 arguments");
		return -1;
	}

	//open input file
	FILE *fpIn = fopen(argv[1], "r");
	if(fpIn == NULL)
	{
		perror("input file");
		return -1;
	}

	//open output file
	FILE *fpOut = fopen("image.bmp", "w");

	char row[COLSIZE + 1];
	for(int i = 0; i < ROWSIZE; i++)
	{
		//read an intire row
		if(fgets(row, COLSIZE + 1, fpIn) == NULL)
		{
			puts("file is corrupted");
			return -2;
		}

		if(row[0] != '0' && row[0] != '1')
		{
			//ingore any '\n'
			i--;
			continue;
		}	

		//store each row as an array of 128 bits = 16 * 8
		char bitRow[COLSIZE/8];
		bzero(bitRow, sizeof(bitRow));
		for(int i = 0; i < COLSIZE; i++)
		{
			if(row[i] == '0')
			{
				char bit = pow(2, 7-(i%8));
				bitRow[i/8] &= ~bit;
			}
			else if(row[i] == '1')
			{
				char bit = pow(2, 7-(i%8));
				bitRow[i/8] = bitRow[i/8] | bit;
			}
			else
			{
				puts("file is corrupted");
				return -2;
			}
		}

		fwrite(bitRow, sizeof(char), COLSIZE/8, fpOut);
	}

	fclose(fpOut);
	fclose(fpIn);

	return 0;
}