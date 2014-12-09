library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity usb2bram is
	port( 
		start, rst, clk : in std_logic;
		regW_out : out std_logic_vector(127 downto 0);
		regMR_out : out std_logic_vector(31 downto 0);
		regMW_out : out std_logic_vector(31 downto 0);
		addrOut : out std_logic_vector(8 downto 0);
		ram_out : out std_logic_vector(31 downto 0);
		output : out std_logic_vector(127 downto 0)
	);
end usb2bram;

architecture Structural of usb2bram is

	-- signals to interconnect the components
	signal adrA : std_logic_vector(10 downto 0) := (others => '0');
	signal busDiA : std_logic_vector(7 downto 0) := (others => '0');
	signal ctlEnA, ctlWeA : std_logic := '0';
	
	signal adrB : std_logic_vector(8 downto 0);
	signal busDiB : std_logic_vector(31 downto 0);
	signal ctlEnB, ctlWeB : std_logic;
	
	signal datain : std_logic_vector (31 downto 0);

	signal enRegR : std_logic;
	signal regR_select : std_logic_vector(1 downto 0);
	signal enRegW : std_logic;
	signal enRegMR : std_logic;
	signal enRegMW : std_logic;
		
	signal regControl : std_logic_vector(5 downto 0);
	
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
			clk, rst : in std_logic;
			enRegR : in std_logic;
			regR_select : in std_logic_vector(1 downto 0);
			enRegW : in std_logic;
			regW_out : out std_logic_vector(127 downto 0);
			enRegMR : in std_logic;
			regMR_out : out std_logic_vector(31 downto 0);
			enRegMW : in std_logic;
			regMW_out : out std_logic_vector(31 downto 0);
			datain : in  std_logic_vector (31 downto 0);
			dataout : out  std_logic_vector (127 downto 0)
		);
	end component;
	
	component controlo
		Port ( 
			start, clk, rst : in  std_logic;
			-- bits de controlo do porto A
			adrA : out std_logic_vector(10 downto 0);
			busDiA : out std_logic_vector(7 downto 0);
			ctlEnA : out std_logic;
			ctlWeA : out std_logic;
			-- bits de controlo do porto B
			adrB : out std_logic_vector(8 downto 0);
			busDiB : out std_logic_vector(31 downto 0);
			ctlEnB : out std_logic;
			ctlWeB : out std_logic;
			
			enRegR : out std_logic;
			regR_select : out std_logic_vector(1 downto 0);
			enRegW : out std_logic;
			enRegMR : out std_logic;
			enRegMW : out std_logic
		);
	end component;
	
begin
	-- component instantiations
	Inst_BlockRam : BlockRam port map (
		adrA   => adrA,
		adrB   => adrB,
		busDiA => busDiA,
		busDiB => busDiB,
		clkA   => clk,
		clkB   => clk,
		ctlEnA => ctlEnA,
		ctlEnB => ctlEnB,
		ctlWeA => ctlWeA,
		ctlWeB => ctlWeB,
		busDoA => open,
		busDoB => datain
	);
	
	Inst_datapath: datapath port map(
		clk => clk,
		rst => rst,
		enRegR => regControl(0),
		regR_select => regControl (2 downto 1),
		enRegW => regControl(3),
		regW_out => regW_out,
		enRegMR => regControl(4),
		regMR_out => regMR_out,
		enRegMW => regControl(5),
		regMW_out => regMW_out,
		datain => datain,
		dataout => output
	);
	
	-- registo de controlo entre a UC e a datapath--
	process(clk)
	begin
		if clk'event and clk='1' then
			regControl <= enRegMW & enRegMR & enRegW & regR_select & enRegR;
		end if;
	end process;
	
	Inst_controlo: controlo port map(
		start => start, 
		clk => clk, 
		rst => rst,
		adrA => adrA,
		busDiA => busDiA,
		ctlEnA => ctlEnA,
		ctlWeA => ctlWeA,
		adrB => adrB,
		busDiB => busDiB,
		ctlEnB => ctlEnB,
		ctlWeB => ctlWeB,
		enRegR => enRegR,
		regR_select => regR_select,
		enRegW => enRegW,
		enRegMR => enRegMR,
		enRegMW => enRegMW
	);
	
	addrOut <= adrB;
	ram_out <= datain;
	
end Structural;
