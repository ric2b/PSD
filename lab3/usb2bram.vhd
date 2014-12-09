library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity usb2bram is
	port( 
		start, rst, clk : in std_logic;
		done : out std_logic;
		
		regR10_out : out std_logic_vector(31 downto 0);
		regR11_out : out std_logic_vector(31 downto 0);
		regR12_out : out std_logic_vector(31 downto 0);
		regR1_out : out std_logic_vector(127 downto 0);
		regR2_out : out std_logic_vector(127 downto 0);
		addrOut : out std_logic_vector(8 downto 0)
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
	signal enRegR1: std_logic_vector (2 downto 0);
	signal enRegR2: std_logic;
	
	signal regControl : std_logic_vector(3 downto 0) := (others => '0');
	
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
			rst, clk : in std_logic;
			enRegR1 : in std_logic_vector(2 downto 0);
			enRegR2 : in std_logic;
			regR10_out : out std_logic_vector(31 downto 0);
			regR11_out : out std_logic_vector(31 downto 0);
			regR12_out : out std_logic_vector(31 downto 0);
			regR1_out : out std_logic_vector(127 downto 0);
			regR2_out : out std_logic_vector(127 downto 0);
			
			datain : in  std_logic_vector (31 downto 0)
		);
	end component;
	
	component controlo
		Port ( 
			start, clk, rst : in  std_logic;
			done : out std_logic;
			-- bits de controlo do porto A
			adrA : out std_logic_vector(10 downto 0);
			ctlEnA : out std_logic;
			ctlWeA : out std_logic;
			-- bits de controlo do porto B
			adrB : out std_logic_vector(8 downto 0);
			ctlEnB : out std_logic;
			ctlWeB : out std_logic;
			
			enRegR1 : out std_logic_vector(2 downto 0); -- enables dos registos de leitura --
			enRegR2 : out std_logic
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
		enRegR1=> regControl(2 downto 0),
		enRegR2 => regControl(3),
		regR10_out => regR10_out,
		regR11_out => regR11_out,
		regR12_out => regR12_out,
		regR1_out => regR1_out,
		regR2_out => regR2_out,
		datain => datain
	);
	
	-- registo de controlo --
	process(clk)
	begin
		if clk'event and clk='1' then
			regControl <= enRegR2 & enRegR1;
		end if;
	end process;
	
	Inst_controlo: controlo port map(
		start => start, 
		clk => clk, 
		rst => rst, 
		done => done,
		adrA => adrA,
		ctlEnA => ctlEnA,
		ctlWeA => ctlWeA,
		adrB => adrB,
		ctlEnB => ctlEnB,
		ctlWeB => ctlWeB,
		enRegR1 => enRegR1,
		enRegR2 => enRegR2
	);
	
	addrOut <= adrB;
	
end Structural;
