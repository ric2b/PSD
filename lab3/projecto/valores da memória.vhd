	
	Antes da dilatação (passo 0)

    INIT_00 => X"0000000000000000000000000000000000000000000000000000000000000000",
    INIT_01 => X"000000000000000000000000000000E0000000000000000000000000000000FC",
    INIT_02 => X"00000000000000000000000000000030000000000000000000000000000000F8",
    INIT_03 => X"0000000000000000000000000000000000000000000000000000000000000000",

"
    00000000000000000000000000000000 -> 0
    00000000000000000000000000110000 -> 30
    00000000000000000000000011111000 -> F8
    00000000000000000000000011100000 -> E0
    00000000000000000000000011111100 -> FC
    00000000000000000000000000000000 -> 0
    00000000000000000000000000000000 -> 0
"
	Depois da dilatação (passo 1)

    INIT_00 => X"000000000000000000000000000001FE00000000000000000000000000000000",
    INIT_01 => X"000000000000000000000000000001FE000000000000000000000000000001FE",
    INIT_02 => X"000000000000000000000000000001FC000000000000000000000000000001FC",
    INIT_03 => X"0000000000000000000000000000000000000000000000000000000000000078",

"
    00000000000000000000000001111000 -> 78
    00000000000000000000000111111100 -> 1FC
    00000000000000000000000111111100 -> 1FC
    00000000000000000000000111111110 -> 1FE
    00000000000000000000000111111110 -> 1FE
    00000000000000000000000111111110 -> 1FE
    00000000000000000000000000000000 -> 0
"
    Depois da erosão (passo 2)

    INIT_00 => X"0000000000000000000000000000000000000000000000000000000000000000",
    INIT_01 => X"000000000000000000000000000000F8000000000000000000000000000000FC",
    INIT_02 => X"00000000000000000000000000000030000000000000000000000000000000F8",
    INIT_03 => X"0000000000000000000000000000000000000000000000000000000000000000",

"
    00000000000000000000000000000000 -> 0
    00000000000000000000000000110000 -> 30
    00000000000000000000000011111000 -> F8
    00000000000000000000000011111000 -> F8
    00000000000000000000000011111100 -> FC
    00000000000000000000000000000000 -> 0
    00000000000000000000000000000000 -> 0
"    

    