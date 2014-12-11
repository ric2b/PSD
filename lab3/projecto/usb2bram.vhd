library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity usb2bram is
	port( 
		start, rst, clk, oper : in std_logic;

		-- memorias --
		addrin_out : out std_logic_vector(8 downto 0);
		datain_out : out std_logic_vector (31 downto 0);

		-- saidas dos registos --
		regRin_out 		: out std_logic_vector(127 downto 0);
		regRiprev_out	: out std_logic_vector(127 downto 0);
		regRicurr_out	: out std_logic_vector(127 downto 0);
		regRinext_out	: out std_logic_vector(127 downto 0);
		regRres_out		: out std_logic_vector(127 downto 0)
	);
end usb2bram;

architecture Structural of usb2bram is

	-- signals to interconnect the components
	signal adrA_in : std_logic_vector(10 downto 0) := (others => '0');
	signal busDiA_in : std_logic_vector(7 downto 0) := (others => '0');
	signal ctlEnA_in, ctlWeA_in : std_logic := '0';
	signal adrA_out : std_logic_vector(10 downto 0) := (others => '0');
	signal busDiA_out : std_logic_vector(7 downto 0) := (others => '0');
	signal ctlEnA_out, ctlWeA_out : std_logic := '0';

	-- bits de controlo do porto B de M_in
	signal adrB_in 		: std_logic_vector(8 downto 0) := (others => '0');
	signal busDiB_in, busDoB_in 	: std_logic_vector(31 downto 0) := (others => '0');
	signal ctlEnB_in	: std_logic := '0';
	signal ctlWeB_in 	: std_logic := '0';

	-- bits de controlo do porto B de M_out
	signal adrB_out 	: std_logic_vector(8 downto 0) := (others => '0');
	signal busDiB_out, busDoB_out 	: std_logic_vector(31 downto 0) := (others => '0');
	signal ctlEnB_out	: std_logic := '0';
	signal ctlWeB_out 	: std_logic := '0';

	-- enables e selects --
	signal regRin_en 	: std_logic_vector(2 downto 0):= (others => '0');
	signal regRiprev_en	: std_logic := '0';
	signal regRicurr_en	: std_logic := '0';
	signal regRinext_en	: std_logic := '0';
	signal mux1_select	: std_logic := '0';
	signal regRres_en	: std_logic := '0';
		
	signal regControl : std_logic_vector(16 downto 0) := (others => '0');
	
	-- component declarations  
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
			rst, clk 		: in std_logic;
			oper			: in std_logic;						-- (dilatacao = 0 / erosao = 1)
			regRin_en 		: in std_logic_vector(2 downto 0);	-- enables dos registos de entrada
			regRiprev_en	: in std_logic; 					-- enable do registo Ri-1
			regRicurr_en	: in std_logic;						-- enable do registo Ri
			regRinext_en	: in std_logic;						-- enable do registo Ri+1
			mux1_select		: in std_logic;						-- select do mux 1 que seleciona a entrada de Ri+1
			regRres_en		: in std_logic;						-- enable do registo que guarda o resultado
			regRin_out 		: out std_logic_vector(127 downto 0);
			regRiprev_out	: out std_logic_vector(127 downto 0);
			regRicurr_out	: out std_logic_vector(127 downto 0);
			regRinext_out	: out std_logic_vector(127 downto 0);
			regRres_out		: out std_logic_vector(127 downto 0);
			adrB_in			: in std_logic_vector(8 downto 0);
			adrB_out			: out std_logic_vector(8 downto 0);
			datain 			: in  std_logic_vector (31 downto 0);
			dataout 			: out  std_logic_vector (31 downto 0)
		);
	end component;
	
	component controlo
		Port ( 
			start, clk, rst : in  std_logic;
			adrB_in 		: out std_logic_vector(8 downto 0);
			ctlEnB_in 		: out std_logic;
			ctlWeB_in 		: out std_logic;
			ctlEnB_out 		: out std_logic;
			ctlWeB_out 		: out std_logic;
			regRin_en 		: out std_logic_vector(2 downto 0);		-- enables dos registos de entrada
			regRiprev_en	: out std_logic; 						-- enable do registo Ri-1
			regRicurr_en	: out std_logic;						-- enable do registo Ri
			regRinext_en	: out std_logic;						-- enable do registo Ri+1
			mux1_select		: out std_logic;						-- select do mux 1 que seleciona a entrada de Ri+1
			regRres_en		: out std_logic	
		);
	end component;
	
begin
	-- component instantiations
	Inst_BlockRam_In : BlockRam port map (
		adrA   => adrA_in,
		adrB   => adrB_in,
		busDiA => busDiA_in,
		busDiB => busDiB_in,
		clkA   => clk,
		clkB   => clk,
		ctlEnA => ctlEnA_in,
		ctlEnB => ctlEnB_in,
		ctlWeA => ctlWeA_in,
		ctlWeB => ctlWeB_in,
		busDoA => open,
		busDoB => busDoB_in
	);
	
	Inst_BlockRam_Out : BlockRam port map (
		adrA   => adrA_out,
		adrB   => adrB_out,
		busDiA => busDiA_out,
		busDiB => busDiB_out,
		clkA   => clk,
		clkB   => clk,
		ctlEnA => ctlEnA_out,
		ctlEnB => ctlEnB_out,
		ctlWeA => ctlWeA_out,
		ctlWeB => ctlWeB_out,
		busDoA => open,
		busDoB => busDoB_out
	);

	Inst_datapath: datapath port map(
		clk => clk,
		rst => rst,
		oper => oper,
		regRin_en => regControl(2 downto 0),
		regRiprev_en => regControl(3),
		regRicurr_en => regControl(4),
		regRinext_en => regControl(5),
		mux1_select => regControl(6),
		regRres_en => regControl(7),
		regRin_out => regRin_out,
		regRiprev_out => regRiprev_out,
		regRicurr_out => regRicurr_out,
		regRinext_out => regRinext_out,
		regRres_out	=> regRres_out,
		adrB_in => regControl(16 downto 8),
		adrB_out	=> adrB_out,
		datain => busDoB_in,
		dataout => busDiB_out
	);
	
	-- registo de controlo entre a UC e a datapath--
	process(clk)
	begin
		if clk'event and clk='1' then
			regControl <= adrB_in & regRres_en & mux1_select & regRinext_en & regRicurr_en & regRiprev_en & regRin_en;
		end if;
	end process;
	
	Inst_controlo: controlo port map(
		start => start, 
		clk => clk, 
		rst => rst,
		ctlEnB_out => ctlEnB_out,
		ctlWeB_out => ctlWeB_out,
		adrB_in => adrB_in,
		ctlEnB_in => ctlEnB_in,
		ctlWeB_in => ctlWeB_in,
		regRin_en => regRin_en,
		regRiprev_en =>	regRiprev_en,
		regRicurr_en => regRicurr_en,
		regRinext_en => regRinext_en,
		mux1_select	=> mux1_select,
		regRres_en => regRres_en
	);
	
	addrin_out <= adrB_in;
	datain_out <= busDoB_in;

end Structural;
