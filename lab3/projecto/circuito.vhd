library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity circuito is
	port( 
		start, rst, clk	: in std_logic;
		oper					: in std_logic_vector(1 downto 0);

		-- memorias --
		adrBMemRead_out : out std_logic_vector(8 downto 0);
		dataInBMemRead_out : out std_logic_vector (31 downto 0);

		-- saidas dos registos --
		regRead_out 		: out std_logic_vector(127 downto 0);
		regRiPrevious_out	: out std_logic_vector(127 downto 0);
		regRiCurrent_out	: out std_logic_vector(127 downto 0);
		regRiNext_out		: out std_logic_vector(127 downto 0);
		regResult_out			: out std_logic_vector(127 downto 0)
	);
end circuito;

architecture Structural of circuito is
	--------------------------------------------
	-- signals to interconnect the components --
	--------------------------------------------

	-- sinais de ligacao da datapath
	signal operSimple 		: std_logic := '0';
	signal datapathResult 	: std_logic_vector(31 downto 0); 

	-- sinais de ligacao da memoria de leitura --
	signal adrAMemRead 		 : std_logic_vector(10 downto 0) := (others => '0');	-- endereco porto A da memoria de leitura
	signal dataInAMemRead	 : std_logic_vector(7 downto 0) := (others => '0');		-- dados de entrada do porto A da memoria de leitura
	signal dataOutAMemRead	 : std_logic_vector(7 downto 0) := (others => '0');		-- dados de saida do porto A da memoria de leitura
	signal enAMemRead		 : std_logic := '0';									-- enable da memoria de leitura
	signal writeEnAMemRead	 : std_logic := '0';									-- write enable da memoria de leitura

	signal adrBMemRead 		 : std_logic_vector(8 downto 0) := (others => '0');		-- endereco porto B da memoria de leitura
	signal dataInBMemRead	 : std_logic_vector(31 downto 0) := (others => '0');	-- dados de entrada do porto B da memoria de leitura
	signal dataOutBMemRead	 : std_logic_vector(31 downto 0) := (others => '0');	-- dados de saida do porto B da memoria de leitura
	signal enBMemRead		 : std_logic := '0';									-- enable da memoria de leitura
	signal writeEnBMemRead	 : std_logic := '0';									-- write enable da memoria de leitura

	-- sinais de ligacao da memoria de escrita 0 --
	signal adrAMemWrite0	 : std_logic_vector(10 downto 0) := (others => '0');	-- endereco porto A da memoria de escrita 0
	signal dataInAMemWrite0	 : std_logic_vector(7 downto 0) := (others => '0');		-- dados de entrada do porto A da memoria de escrita 0
	signal dataOutAMemWrite0 : std_logic_vector(7 downto 0) := (others => '0');		-- dados de saida do porto A da memoria de escrita 0
	signal enAMemWrite0		 : std_logic := '0';									-- enable da memoria de escrita 0
	signal writeEnAMemWrite0 : std_logic := '0';									-- write enable da memoria de escrita 0

	signal adrBMemWrite0 	 : std_logic_vector(8 downto 0) := (others => '0');		-- endereco porto B da memoria de escrita 0
	signal dataInBMemWrite0	 : std_logic_vector(31 downto 0) := (others => '0');	-- dados de entrada do porto B da memoria de escrita 0
	signal dataOutBMemWrite0 : std_logic_vector(31 downto 0) := (others => '0');	-- dados de saida do porto B da memoria de escrita 0
	signal enBMemWrite0		 : std_logic := '0';									-- enable da memoria de escrita 0
	signal writeEnBMemWrite0 : std_logic := '0';									-- write enable da memoria de escrita 0

	-- sinais de ligacao da memoria de escrita 1 --
	signal adrAMemWrite1	 : std_logic_vector(10 downto 0) := (others => '0');	-- endereco porto A da memoria de escrita 1
	signal dataInAMemWrite1	 : std_logic_vector(7 downto 0) := (others => '0');		-- dados de entrada do porto A da memoria de escrita 1
	signal dataOutAMemWrite1 : std_logic_vector(7 downto 0) := (others => '0');		-- dados de saida do porto A da memoria de escrita 1
	signal enAMemWrite1		 : std_logic := '0';									-- enable da memoria de escrita 1
	signal writeEnAMemWrite1 : std_logic := '0';									-- write enable da memoria de escrita 1

	signal adrBMemWrite1 	 : std_logic_vector(8 downto 0) := (others => '0');		-- endereco porto B da memoria de escrita 1
	signal dataInBMemWrite1	 : std_logic_vector(31 downto 0) := (others => '0');	-- dados de entrada do porto B da memoria de escrita 1
	signal dataOutBMemWrite1 : std_logic_vector(31 downto 0) := (others => '0');	-- dados de saida do porto B da memoria de escrita 1
	signal enBMemWrite1		 : std_logic := '0';									-- enable da memoria de escrita 1
	signal writeEnBMemWrite1 : std_logic := '0';									-- write enable da memoria de escrita 1

	-- enables dos registos --
	signal enRegRead 		 : std_logic_vector(2 downto 0):= (others => '0');
	signal enRegRiPrevious	 : std_logic := '0';
	signal enRegRiCurrent	 : std_logic := '0';
	signal enRegRiNext		 : std_logic := '0';
	signal enRegResult		 : std_logic := '0';

	-- selects dos muxes--
	signal selectMuxOper	 : std_logic := '0';									-- select do mux que identifica a operacao a realizar 

	signal datapath_in		 : std_logic_vector (31 downto 0); 						-- entrada de dados da datapath
	signal adrWithDelay		 : std_logic_vector (8 downto 0);						-- endereco com delay
	------------------------------------------------------------
	-- signais para constituir alguns componenetes de ligacao --
	------------------------------------------------------------

	-- selects dos muxes --
	signal selectMuxDataIn		: std_logic := '0';									-- select do mux que seleciona a origem dos dados introduzidos na datapath
	signal selectMuxMemWriteAdr	: std_logic := '0';									-- select do mux que seleciona a origem do endereco da memoria de escrita 1

	-- registo de controlo entre a UC e a datapath --
	signal regControl : std_logic_vector(17 downto 0) := (others => '0');			-- registo de controlo entre a datapath e a UC
	
	----------------------------
	-- Component Declarations --
	----------------------------
	component BlockRam
		port( 
			ctlWeA : in    std_logic; 
			busDiA : in    std_logic_vector (7 downto 0); 
			busDoA : out   std_logic_vector (7 downto 0); 
			adrA   : in    std_logic_vector (10 downto 0); 
			ctlEnA : in    std_logic; 
			clkA   : in    std_logic; 
			ctlWeB : in    std_logic; 
			busDiB : in    std_logic_vector (31 downto 0); 
			busDoB : out   std_logic_vector (31 downto 0); 
			adrB   : in    std_logic_vector (8 downto 0); 
			ctlEnB : in    std_logic; 
			clkB   : in    std_logic
		);	
	end component;
	
	component datapath
		Port(
			rst, clk 			: in std_logic;
			oper				: in std_logic;
			enRegRead 			: in std_logic_vector(2 downto 0);
			enRegRiPrevious		: in std_logic;
			enRegRiCurrent		: in std_logic;
			enRegRiNext			: in std_logic;
			enRegResult			: in std_logic;
			selectMuxOper		: in std_logic;
			regRead_out 		: out std_logic_vector(127 downto 0); --APAGAR--
			regRiPrevious_out	: out std_logic_vector(127 downto 0); --APAGAR--
			regRiCurrent_out	: out std_logic_vector(127 downto 0); --APAGAR--
			regRiNext_out		: out std_logic_vector(127 downto 0); --APAGAR--
			regResult_out		: out std_logic_vector(127 downto 0); --APAGAR--
			adrBMemRead			: in std_logic_vector(8 downto 0);
			adrBMemWrite		: out std_logic_vector(8 downto 0);
			dataIn 				: in  std_logic_vector (31 downto 0);
			dataOut 			: out  std_logic_vector (31 downto 0)
		);
	end component;
	
	component controlo_level1
		Port (
			start, clk, rst			: in  std_logic;
			oper					: in std_logic_vector(1 downto 0);
			operSimple				: out std_logic;
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
	-- component instantiations
	Inst_BlockRam_Read : BlockRam port map (
		adrA   => adrAMemRead,
		adrB   => adrBMemRead,
		busDiA => dataInAMemRead,
		busDiB => dataInBMemRead,
		clkA   => clk,
		clkB   => clk,
		ctlEnA => enAMemRead,
		ctlEnB => enBMemRead,
		ctlWeA => writeEnAMemRead,
		ctlWeB => writeEnBMemRead,
		busDoA => open,
		busDoB => dataOutBMemRead
	);
	
	adrBMemWrite0 <= adrWithDelay;

	Inst_BlockRam_Write0 : BlockRam port map (
		adrA   => adrAMemWrite0,
		adrB   => adrBMemWrite0,
		busDiA => dataInAMemWrite0,
		busDiB => datapathResult,
		clkA   => clk,
		clkB   => clk,
		ctlEnA => enAMemWrite0,
		ctlEnB => enBMemWrite0,
		ctlWeA => writeEnAMemWrite0,
		ctlWeB => writeEnBMemWrite0,
		busDoA => open,
		busDoB => dataOutBMemWrite0
	);

	-- mux que seleciona a origem do endereco da memoria de escrita 1 --
	adrBMemWrite1 <= adrWithDelay when selectMuxMemWriteAdr='0' else adrBMemRead;

	Inst_BlockRam_Write1 : BlockRam port map (
		adrA   => adrAMemWrite1,
		adrB   => adrBMemWrite1,
		busDiA => dataInAMemWrite1,
		busDiB => datapathResult,
		clkA   => clk,
		clkB   => clk,
		ctlEnA => enAMemWrite1,
		ctlEnB => enBMemWrite1,
		ctlWeA => writeEnAMemWrite1,
		ctlWeB => writeEnBMemWrite1,
		busDoA => open,
		busDoB => dataOutBMemWrite1
	);

	-- mux de selecao de entrada de dados na datapath --
	datapath_in <= dataOutBMemRead when selectMuxDataIn='0' else dataOutBMemWrite1;

	Inst_datapath: datapath port map(
		clk => clk,
		rst => rst,
		oper => regControl(17),
		enRegRead => regControl(2 downto 0),
		enRegRiPrevious => regControl(3),
		enRegRiCurrent => regControl(4),
		enRegRiNext => regControl(5),
		selectMuxOper => regControl(6),
		enRegResult => regControl(7),
		regRead_out => regRead_out,
		regRiPrevious_out => regRiPrevious_out,
		regRiCurrent_out => regRiCurrent_out,
		regRiNext_out => regRiNext_out,
		regResult_out	=> regResult_out,
		adrBMemRead => regControl(16 downto 8),
		adrBMemWrite => adrWithDelay,
		datain => datapath_in,
		dataout => datapathResult
	);
	
	-- registo de controlo entre a UC e a datapath --
	process(clk)
	begin
		if clk'event and clk='1' then
			regControl <= operSimple & adrBMemRead & enRegResult & selectMuxOper & enRegRiNext & enRegRiCurrent & enRegRiPrevious & enRegRead;
		end if;
	end process;

	Inst_controlo_level1: controlo_level1 port map(
		start => start, 
		clk => clk, 
		rst => rst,
		oper => oper,
		operSimple => operSimple,
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
	
	adrBMemRead_out <= adrBMemRead;
	dataInBMemRead_out <= dataOutBMemRead;

end Structural;
