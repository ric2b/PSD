Está aqui o ficheiro que utilizámos para instanciar o DCM. 

este ficheiro é a copia do que é gerado quando se cria um novo IPCore e se selecciona em FPGA Features and Design -> Clocking -> Spartan3E ->Single DCM_SP

Depois de finalizar o processo na nova janela Avançar (OK).

No Clocking Wizard seleccionar CLKFX, 50MHZ de Input Frequency, Next, Next, e em Use Output frequency colocar a freqência desejada (ter atenção que como é o resultado de divisão e multiplicação de 50MHZ por factores inteiros os valores são limitados) e carregar calculate. Quando afinado Next e Finish.

No project hierarchy seleccionar o ip criado e seleccionar View HDL Source. o VHDL gerado é idêntico ao que usámos, mas a frequência está ajustada. Instacia-se este VHDL (dica se carregaram em view HDL Instantiation Template está quase tudo feito, ou procurar no usb2bram.vhd que está no rar. 

Só ter atenção que o sinal que entra no clk_div passa a ser a saida CLK0_OUT do bloco gerado para que a frequência do display não se altere como aliás está no ficheiro usb2bram.vhd

Espero que ajude...