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

		-- enables e selects --
		regRin_en 		: in std_logic_vector(2 downto 0);	-- enables dos registos de entrada
		regRiprev_en	: in std_logic; 						-- enable do registo Ri-1
		regRicurr_en	: in std_logic;						-- enable do registo Ri
		regRinext_en	: in std_logic;						-- enable do registo Ri+1
		mux1_select		: in std_logic;						-- select do mux 1 que seleciona a entrada de Ri+1
		regRres_en		: in std_logic;						-- enable do registo que guarda o resultado
		
		-- saidas dos registos --
		regRin_out 		: out std_logic_vector(127 downto 0);
		regRiprev_out	: out std_logic_vector(127 downto 0);
		regRicurr_out	: out std_logic_vector(127 downto 0);
		regRinext_out	: out std_logic_vector(127 downto 0);
		regRres_out		: out std_logic_vector(127 downto 0);
		
		-- enderecos da memoria de escrita --
		adrB_in			: in std_logic_vector(8 downto 0);
		adrB_out			: out std_logic_vector(8 downto 0);

		-- entradas e saidas das memorias --
		datain 			: in  std_logic_vector (31 downto 0);
		dataout 			: out  std_logic_vector (31 downto 0)
	);
end datapath;

architecture Behavioral of datapath is
	
	-- registos de entrada --
	signal regR0		: std_logic_vector(31 downto 0):= (others => '0');
	signal regR1		: std_logic_vector(31 downto 0):= (others => '0');
	signal regR2		: std_logic_vector(31 downto 0):= (others => '0');
	signal regRin 		: std_logic_vector(127 downto 0):= (others => '0');

	-- registos Ris --
	signal regRiprev 	: std_logic_vector(127 downto 0):= (others => '0');
	signal regRicurr	: std_logic_vector(127 downto 0):= (others => '0');
	signal regRinext	: std_logic_vector(127 downto 0):= (others => '0');
	signal regRres		: std_logic_vector(127 downto 0):= (others => '0');
	
	-- logica --
	signal oper_extend	: std_logic_vector(127 downto 0);
	signal logic_out_dil: std_logic_vector(127 downto 0);
	signal logic_out_ero: std_logic_vector(127 downto 0);

	-- entradas --
	signal regRinext_in	: std_logic_vector(127 downto 0);
	signal regRres_in	: std_logic_vector(127 downto 0);
	
	-- registos de atraso do contador --
	type  delayArray is array (0 to 12) of std_logic_vector(8 downto 0); 
	signal counterDelay : delayArray;
	
	signal selectMuxOut 	:  std_logic_vector(1 downto 0);	-- select do mux de saida do resultado

begin
	
	-- registos de delay do contador --
	process(clk)
	begin
		if clk'event and clk='1' then
			counterDelay(0) <= adrB_in;
		end if;
	end process;
	
	delay: for k in 0 to 11 generate
	begin
		process(clk)
		begin
			if clk'event and clk='1' then
				counterDelay(k+1) <= counterDelay(k);
			end if;
		end process;
	end generate delay;
	
	adrB_out <= counterDelay(12);
	
	-----------------------
	--Registos de Entrada--
	-----------------------

	-- registo R0 --
	process(clk)
	begin
		if clk'event and clk='1' then
			if regRin_en="100" then
				regR0 <= datain;
			end if;
		end if;
	end process;

	-- registo R1 --
	process(clk)
	begin
		if clk'event and clk='1' then
			if regRin_en="101" then
				regR1 <= datain;
			end if;
		end if;
	end process;

	-- registo R2 --
	process(clk)
	begin
		if clk'event and clk='1' then
			if regRin_en="110" then
				regR2 <= datain;
			end if;
		end if;
	end process;

	-- registo de entrada --
	process(clk)
	begin
		if clk'event and clk='1' then
			if regRin_en="111" then
				regRin <= regR0 & regR1 & regR2 & datain;
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
			if regRiprev_en='1' then
				regRiprev <= regRicurr;
			end if;
		end if;
	end process;
	
	-- registo Ri --
	process(clk)
	begin
		if clk'event and clk='1' then
			if regRicurr_en='1' then
				regRicurr <= regRinext;
			end if;
		end if;
	end process;

	-- registo Ri+1 --
	process(clk)
	begin
		if clk'event and clk='1' then
			if regRinext_en='1' then
				regRinext <= regRinext_in;
			end if;
		end if;
	end process;

	-- extensao do sinal oper --
	oper_extend <= X"FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF" when oper='0' else X"00000000000000000000000000000000";
	-- Mux 1 --
	regRinext_in <= oper_extend when mux1_select = '1' else regRin;

	------------------------
	--Logica de cada Linha--
	------------------------

	-- logica para obter linha processada --
	logic: for k in 0 to 127 generate
	begin
		left: if (k = 0) generate
		begin
			logic_out_dil(k) <= regRiprev(k) or regRiprev(k+1) or 
							 	regRicurr(k+1) or regRicurr(k) or 
							 	regRinext(k) or regRinext(k+1);
			
			logic_out_ero(k) <= regRiprev(k) and regRiprev(k+1) and 
							 	regRicurr(k+1) and regRicurr(k) and 
							 	regRinext(k) and regRinext(k+1);
		end generate left;

		middle: if (k > 0) and (k < 127) generate
		begin
			logic_out_dil(k) <= regRiprev(k-1) or regRiprev(k) or regRiprev(k+1) or 
							 	regRicurr(k-1) or regRicurr(k) or regRicurr(k+1) or
							 	regRinext(k-1) or regRinext(k) or regRinext(k+1);
			
			logic_out_ero(k) <= regRiprev(k-1) and regRiprev(k) and regRiprev(k+1) and 
							 	regRicurr(k-1) and regRicurr(k) and regRicurr(k+1) and
							 	regRinext(k-1) and regRinext(k) and regRinext(k+1);
		end generate middle;

		right: if (k = 127) generate
		begin
			logic_out_dil(k) <= regRiprev(k-1) or regRiprev(k) or 
							 	regRicurr(k-1) or regRicurr(k) or 
							 	regRinext(k-1) or regRinext(k);
			
			logic_out_ero(k) <= regRiprev(k-1) and regRiprev(k) and 
							 	regRicurr(k-1) and regRicurr(k) and 
							 	regRinext(k-1) and regRinext(k);
		end generate right;
	end generate logic;

	with oper select
		regRres_in <= logic_out_dil when '1',
					  logic_out_ero when '0',
					  X"00000000000000000000000000000000" when others;


	-- registo com o resultado --
	process(clk)
	begin
		if clk'event and clk='1' then
			if regRres_en='1' then
				regRres <= regRres_in;
			end if;
		end if;
	end process;

	regRin_out 	  <= regRin;
	regRiprev_out <= regRiprev;
	regRicurr_out <= regRicurr;
	regRinext_out <= regRinext;
	regRres_out	  <= regRres;
	
	-- mux para o dataout
	selectMuxOut <= counterDelay(8)(1 downto 0);
	with selectMuxOut select
		dataout <=  regRres(127 downto 96) when "00",
						regRres(95 downto 64) when "01",
						regRres(63 downto 32) when "10",
						regRres(31 downto 0) when "11",
						X"00000000" when others;
	
end Behavioral;

