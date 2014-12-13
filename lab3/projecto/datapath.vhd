library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity datapath is
	Port ( 
		rst, clk 		: in std_logic;
		oper				: in std_logic;						-- (dilatacao = 1 / erosao = 0)

		-- enables --
		enRegRead 		: in std_logic_vector(2 downto 0);	-- enables dos registos de entrada
		enRegRiPrevious	: in std_logic; 					-- enable do registo Ri-1 (contem linha anterior)
		enRegRiCurrent	: in std_logic;						-- enable do registo Ri (contem linha actual)
		enRegRiNext		: in std_logic;						-- enable do registo Ri+1 (contem linha a seguir)
		enRegResult		: in std_logic;						-- enable do registo que guarda o resultado

		-- selects --
		selectMuxOper	: in std_logic;						-- select do mux que identifica a operacao a realizar

		-- saidas dos registos --
		regRead_out 		: out std_logic_vector(127 downto 0); --APAGAR--
		regRiPrevious_out	: out std_logic_vector(127 downto 0); --APAGAR--
		regRiCurrent_out	: out std_logic_vector(127 downto 0); --APAGAR--
		regRiNext_out		: out std_logic_vector(127 downto 0); --APAGAR--
		regResult_out		: out std_logic_vector(127 downto 0); --APAGAR--
		
		-- enderecos da memoria de escrita --
		adrBMemRead		: in std_logic_vector(8 downto 0);
		adrBMemWrite	: out std_logic_vector(8 downto 0);

		-- entradas e saidas de dados --
		dataIn 			: in  std_logic_vector (31 downto 0);	-- dados da memoria de leitura
		dataOut 		: out  std_logic_vector (31 downto 0)	-- dados a enviar para a memoria de escrita
	);
end datapath;

architecture Behavioral of datapath is
	
	-- registos de entrada --
	signal regR0		: std_logic_vector(31 downto 0):= (others => '0');	-- registo de leitura com os bits 127-96 da linha a ser lida
	signal regR1		: std_logic_vector(31 downto 0):= (others => '0');	-- registo de leitura com os bits 95-64 da linha a ser lida
	signal regR2		: std_logic_vector(31 downto 0):= (others => '0');	-- registo de leitura com os bits 63-32 da linha a ser lida
	signal regRead 		: std_logic_vector(127 downto 0):= (others => '0'); -- registo de leitura com os 128 bits da linha lida

	-- registos Ris --
	signal regRiPrevious 	: std_logic_vector(127 downto 0):= (others => '0');	-- registo com a linha anterior
	signal regRiCurrent		: std_logic_vector(127 downto 0):= (others => '0');	-- registo com a linha actual
	signal regRiNext		: std_logic_vector(127 downto 0):= (others => '0');	-- registo com a linha a seguir
	signal regResult		: std_logic_vector(127 downto 0):= (others => '0'); -- registo com o resultado da linha actual
	
	-- logica --
	signal operExtended			: std_logic_vector(127 downto 0); -- sinal de operao extendido
	signal expansionLogic_out	: std_logic_vector(127 downto 0); -- saida da logica para a dilatacao (expansion)
	signal contractionLogic_out : std_logic_vector(127 downto 0); -- saida da logica para a erosao (contraction)

	-- entradas de registos--
	signal regRiNext_in	: std_logic_vector(127 downto 0);
	signal regResult_in	: std_logic_vector(127 downto 0);
	
	-- registos de atraso do contador --
	type  delayArray is array (0 to 9) of std_logic_vector(8 downto 0); 
	signal counterDelay : delayArray;
	
	signal selectMuxOut :  std_logic_vector(1 downto 0); -- select do mux de saida do resultado

begin
	
	-- registos de delay do contador --
	process(clk)
	begin
		if clk'event and clk='1' then
			counterDelay(0) <= adrBMemRead;
		end if;
	end process;
	
	delay: for k in 0 to 8 generate
	begin
		process(clk)
		begin
			if clk'event and clk='1' then
				counterDelay(k+1) <= counterDelay(k);
			end if;
		end process;
	end generate delay;
	
	adrBMemWrite <= counterDelay(9);
	
	-----------------------
	--Registos de Leitura--
	-----------------------
	-- registo R0 --
	process(clk)
	begin
		if clk'event and clk='1' then
			if enRegRead="100" then
				regR0 <= datain;
			end if;
		end if;
	end process;

	-- registo R1 --
	process(clk)
	begin
		if clk'event and clk='1' then
			if enRegRead="101" then
				regR1 <= datain;
			end if;
		end if;
	end process;

	-- registo R2 --
	process(clk)
	begin
		if clk'event and clk='1' then
			if enRegRead="110" then
				regR2 <= datain;
			end if;
		end if;
	end process;

	-- registo de entrada --
	process(clk)
	begin
		if clk'event and clk='1' then
			if enRegRead="111" then
				regRead <= regR0 & regR1 & regR2 & datain;
			end if;
		end if;
	end process;

	----------------
	--Registos Ris--
	----------------

	-- registo Ri-1 --
	process(clk)
	begin
		if clk'event and clk='1' then
			if enRegRiPrevious='1' then
				regRiPrevious <= regRiCurrent;
			end if;
		end if;
	end process;
	
	-- registo Ri --
	process(clk)
	begin
		if clk'event and clk='1' then
			if enRegRiCurrent='1' then
				regRiCurrent <= regRiNext;
			end if;
		end if;
	end process;

	-- registo Ri+1 --
	process(clk)
	begin
		if clk'event and clk='1' then
			if enRegRiNext='1' then
				regRiNext <= regRiNext_in;
			end if;
		end if;
	end process;

	-- extensao do sinal oper --
	operExtended <= X"FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF" when oper='0' else X"00000000000000000000000000000000";
	-- Mux 1 --
	regRiNext_in <= operExtended when selectMuxOper = '1' else regRead;

	------------------------
	--Logica de cada Linha--
	------------------------

	-- logica para obter linha processada --
	logic: for k in 0 to 127 generate
	begin
		left: if (k = 0) generate
		begin
			expansionLogic_out(k) <= regRiPrevious(k) or regRiPrevious(k+1) or 
							 		 regRiCurrent(k+1) or regRiCurrent(k) or 
							 		 regRiNext(k) or regRiNext(k+1);
			
			contractionLogic_out(k) <= regRiPrevious(k) and regRiPrevious(k+1) and 
							 		   regRiCurrent(k+1) and regRiCurrent(k) and 
							 		   regRiNext(k) and regRiNext(k+1);
		end generate left;

		middle: if (k > 0) and (k < 127) generate
		begin
			expansionLogic_out(k) <= regRiPrevious(k-1) or regRiPrevious(k) or regRiPrevious(k+1) or 
							 		 regRiCurrent(k-1) or regRiCurrent(k) or regRiCurrent(k+1) or
							 		 regRiNext(k-1) or regRiNext(k) or regRiNext(k+1);
			
			contractionLogic_out(k) <= regRiPrevious(k-1) and regRiPrevious(k) and regRiPrevious(k+1) and 
							 		   regRiCurrent(k-1) and regRiCurrent(k) and regRiCurrent(k+1) and
							 		   regRiNext(k-1) and regRiNext(k) and regRiNext(k+1);
		end generate middle;

		right: if (k = 127) generate
		begin
			expansionLogic_out(k) <= regRiPrevious(k-1) or regRiPrevious(k) or 
							 		 regRiCurrent(k-1) or regRiCurrent(k) or 
							 		 regRiNext(k-1) or regRiNext(k);
			
			contractionLogic_out(k) <= regRiPrevious(k-1) and regRiPrevious(k) and 
							 		   regRiCurrent(k-1) and regRiCurrent(k) and 
							 		   regRiNext(k-1) and regRiNext(k);
		end generate right;
	end generate logic;

	-- mux de selecao de qual dos resultados a guardar no registo de resultado --
	with oper select
		regResult_in <= expansionLogic_out when '1',
					  contractionLogic_out when '0',
					  X"00000000000000000000000000000000" when others;


	-- registo com o resultado --
	process(clk)
	begin
		if clk'event and clk='1' then
			if enRegResult='1' then
				regResult <= regResult_in;
			end if;
		end if;
	end process;

	regRead_out <= regRead;
	regRiPrevious_out <= regRiPrevious;
	regRiCurrent_out <= regRiCurrent;
	regRiNext_out <= regRiNext;
	regResult_out	<= regResult;
	
	-- mux para o dataout
	selectMuxOut <= counterDelay(9)(1 downto 0);
	with selectMuxOut select
		dataout <=  regResult(127 downto 96) when "00",
					regResult(95 downto 64) when "01",
					regResult(63 downto 32) when "10",
					regResult(31 downto 0) when "11",
					X"00000000" when others;
	
end Behavioral;

