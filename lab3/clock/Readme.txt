Est� aqui o ficheiro que utiliz�mos para instanciar o DCM. 

este ficheiro � a copia do que � gerado quando se cria um novo IPCore e se selecciona em FPGA Features and Design -> Clocking -> Spartan3E ->Single DCM_SP

Depois de finalizar o processo na nova janela Avan�ar (OK).

No Clocking Wizard seleccionar CLKFX, 50MHZ de Input Frequency, Next, Next, e em Use Output frequency colocar a freq�ncia desejada (ter aten��o que como � o resultado de divis�o e multiplica��o de 50MHZ por factores inteiros os valores s�o limitados) e carregar calculate. Quando afinado Next e Finish.

No project hierarchy seleccionar o ip criado e seleccionar View HDL Source. o VHDL gerado � id�ntico ao que us�mos, mas a frequ�ncia est� ajustada. Instacia-se este VHDL (dica se carregaram em view HDL Instantiation Template est� quase tudo feito, ou procurar no usb2bram.vhd que est� no rar. 

S� ter aten��o que o sinal que entra no clk_div passa a ser a saida CLK0_OUT do bloco gerado para que a frequ�ncia do display n�o se altere como ali�s est� no ficheiro usb2bram.vhd

Espero que ajude...