library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- esta unidade de controlo (UC) está um nível acima da level0 e controla-a
-- a UC level0 permite executar 2 operações: dilatação e erosão
-- esta UC (level1) permite executar as operações abertura e fecho, compostas pelas operações dilatação e erosão, "chamando" a UC level0 2 vezes seguidas

entity controlo_level1 is
	Port (
		start, clk, rst : in  std_logic;
		oper : in std_logic_vector(1 downto 0);

		-- bits de controlo derivados do oper
		operSimple : out std_logic;
		operType : out std_logic;

		-- bits de controlo_level1 da memoria de leitura --
		adrBMemRead		: out std_logic_vector(8 downto 0);
		enBMemRead 		: out std_logic;
		writeEnBMemRead : out std_logic;
		
		-- bits de controlo_level1 do porto B das memorias de escrita 0 e 1
		enBMemWrite0 		: out std_logic;
		writeEnBMemWrite0	: out std_logic;
		enBMemWrite1 		: out std_logic;
		writeEnBMemWrite1	: out std_logic;

		-- enables e selects --
		enRegRead 				: out std_logic_vector(2 downto 0);		-- enables dos registos de leitura
		enRegRiPrevious			: out std_logic; 						-- enable do registo Ri-1
		enRegRiCurrent			: out std_logic;						-- enable do registo Ri
		enRegRiNext				: out std_logic;						-- enable do registo Ri+1
		selectMuxOper			: out std_logic;						-- select do mux que identifica a operacao a realizar
		enRegResult				: out std_logic;						-- enable do registo que guarda o resultado
		selectMuxDataIn			: out std_logic;						-- select do mux que seleciona a origem dos dados introduzidos na datapath
		selectMuxMemWriteAdr	: out std_logic							-- select do mux que seleciona a origem do endereco da memoria de escrita 1
	);
end controlo_level1;

architecture Behavioral of controlo_level1 is
	
	-- instanciação da UC level0
	component controlo_level0 
		Port (
			start, clk, rst			: in  std_logic;
			adrBMemRead				: out std_logic_vector(8 downto 0);
			enBMemRead 				: out std_logic;
			writeEnBMemRead 		: out std_logic;
			enBMemWrite0 			: out std_logic;
			writeEnBMemWrite0		: out std_logic;
			enBMemWrite1 			: out std_logic;
			writeEnBMemWrite1		: out std_logic;
			enRegRead 				: out std_logic_vector(2 downto 0);
			enRegRiPrevious			: out std_logic;
			enRegRiCurrent			: out std_logic;
			enRegRiNext				: out std_logic;
			selectMuxOper			: out std_logic;
			enRegResult				: out std_logic;
			selectMuxDataIn			: out std_logic;
			selectMuxMemWriteAdr	: out std_logic
		);
	end component;

begin

	Inst_controlo_level0: controlo_level0 port map(
		start => start, 
		clk => clk, 
		rst => rst,
		adrBMemRead => adrBMemRead,
		enBMemRead => enBMemRead,
		writeEnBMemRead => writeEnBMemRead,
		enBMemWrite0 => enBMemWrite0,
		writeEnBMemWrite0 => writeEnBMemWrite0,
		enBMemWrite1 => enBMemWrite1, 
		writeEnBMemWrite1 => writeEnBMemWrite1,
		enRegRead => enRegRead,
		enRegRiPrevious =>	enRegRiPrevious,
		enRegRiCurrent => enRegRiCurrent,
		enRegRiNext => enRegRiNext,
		selectMuxOper	=> selectMuxOper,
		enRegResult => enRegResult,
		selectMuxDataIn => selectMuxDataIn,
		selectMuxMemWriteAdr => selectMuxMemWriteAdr
	);
	
end Behavioral;

