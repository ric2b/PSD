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
end datapath;

architecture Behavioral of datapath is
	-- registos de leitura --
	signal regR10 : std_logic_vector (31 downto 0) := (others => '0');
	signal regR11 : std_logic_vector (31 downto 0) := (others => '0');
	signal regR12 : std_logic_vector (31 downto 0) := (others => '0');
	signal regR1 : std_logic_vector (127 downto 0) := (others => '0');
	
	-- registo da logica --
	signal regR2In : std_logic_vector (127 downto 0) := (others => '0');
	signal regR2 : std_logic_vector (127 downto 0) := (others => '0');
	
begin
	
	-- registo R10 --
	process(clk)
	begin
		if clk'event and clk='1' then
			if enRegR1="100" then
				regR10 <= datain;
			end if;
		end if;
	end process;
	
	-- registo R11 --
	process(clk)
	begin
		if clk'event and clk='1' then
			if enRegR1="101" then
				regR11 <= datain;
			end if;
		end if;
	end process;
	
	-- registo R12 --
	process(clk)
	begin
		if clk'event and clk='1' then
			if enRegR1="110" then
				regR12 <= datain;
			end if;
		end if;
	end process;
	
	-- registo R1 --
	process(clk)
	begin
		if clk'event and clk='1' then
			if enRegR1="111" then
				regR1 <= regR10 & regR11 & regR12 & datain;
			end if;
		end if;
	end process;
	
	-- logica --
	logic: for k in 0 to 127 generate
	begin
		left: if (k = 0) generate
		begin
			regR2In(k) <= regR1(k) or regR1(k + 1);
		end generate left;
		
		middle: if (k > 0 and k < 127) generate
		begin
			regR2In(k) <= regR1(k - 1) or regR1(k) or regR1(k + 1);
		end generate middle;
		
		right: if (k = 127) generate
		begin
			regR2In(k) <= regR1(k - 1) or regR1(k);
		end generate right;
	end generate logic;
	
	-- registo R2 --
	process(clk)
	begin
		if clk'event and clk='1' then
			if enRegR2='1' then
				regR2 <= regR2In;
			end if;
		end if;
	end process;
	
	regR10_out <= regR10;
	regR11_out <= regR11;
	regR12_out <= regR12;
	regR1_out <= regR1;
	regR2_out <= regR2;
	
end Behavioral;

