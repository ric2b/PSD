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
		enRegR : in std_logic;							--enable dos registos de leitura
		regR_select : in std_logic_vector(1 downto 0);	--select do registo de leitura onde escrever
		enRegW : in std_logic;							--enable do registo de escrita
		regW_out : out std_logic_vector(127 downto 0);	--saida do registo de escrita
		enRegMR : in std_logic;
		regMR_out : out std_logic_vector(31 downto 0);	--saida do registo de leitura da memoria de escrita
		enRegMW : in std_logic;
		regMW_out : out std_logic_vector(31 downto 0);	--saida do registo de escrita da memoria de escrita
		datain : in  std_logic_vector (31 downto 0);
		dataout : out  std_logic_vector (127 downto 0)
	);
end datapath;

architecture Behavioral of datapath is
	
	constant lineLast : std_logic_vector (6 downto 0) := (others => '1');	-- last position of the line
	
	-- registos de leitura --
	signal regR0 : std_logic_vector (31 downto 0) := (others => '0');
	signal regR1 : std_logic_vector (31 downto 0) := (others => '0');
	signal regR2 : std_logic_vector (31 downto 0) := (others => '0');
	signal regR3 : std_logic_vector (31 downto 0) := (others => '0');
	signal regMR : std_logic_vector (31 downto 0) := (others => '0');
	signal regMW : std_logic_vector (31 downto 0) := (others => '0');
	
	signal lineRead : std_logic_vector (127 downto 0) := (others => '0'); --linha total lida 
	
	-- registo de escrita --
	signal regW : std_logic_vector (127 downto 0) := (others => '0');
	
	-- entradas dos registos --
	signal regWIn : std_logic_vector (127 downto 0) := (others => '0');
	signal regMRIn : std_logic_vector (31 downto 0) := (others => '0');
	signal regMWIn : std_logic_vector (31 downto 0) := (others => '0');
	
begin
	
	-- register read 0 --
	process(clk)
	begin
		if clk'event and clk='1' then
			if enRegR='1' and regR_select="00" then
				regR0 <= datain;
			end if;
		end if;
	end process;
	
	-- register read 1 --
	process(clk)
	begin
		if clk'event and clk='1' then
			if enRegR='1' and regR_select="01" then
				regR1 <= datain;
			end if;
		end if;
	end process;
	
	-- register read 2 --
	process(clk)
	begin
		if clk'event and clk='1' then
			if enRegR='1' and regR_select="10" then
				regR2 <= datain;
			end if;
		end if;
	end process;
	
	-- register read 3 --
	process(clk)
	begin
		if clk'event and clk='1' then
			if enRegR='1' and regR_select="11" then
				regR3 <= datain;
			end if;
		end if;
	end process;
	
	lineRead <= regR0 & regR1 & regR2 & regR3;
	
	-- registo de escrita --
	process(clk)
	begin
		if clk'event and clk='1' then
			if enRegW='1' then
				regW <= regWIn;
			end if;
		end if;
	end process;
	
	regW_out <= regW;
	
	-- registo de escrita da memoria de escrita --
	process(clk)
	begin
		if clk'event and clk='1' then
			if enRegMR='1' then
				regMR <= regMRIn;
			end if;
		end if;
	end process;
	
	regMR_out <= regMR;
	
	-- registo de escrita da memoria de escrita --
	process(clk)
	begin
		if clk'event and clk='1' then
			if enRegMW='1' then
				regMW <= regMWIn;
			end if;
		end if;
	end process;
	
	regMW_out <= regMW;
	
	-- logica para obter linha processada --
	rowsGen: for k in 0 to 127 generate
	begin
		left: if (k = 0) generate
		begin
			regWIn(k) <= lineRead(k) or lineRead(k + 1);
		end generate left;
		middle: if ((k > 0) and (k < lineLast)) generate
		begin
			regWIn(k) <= lineRead(k - 1) or lineRead(k) or lineRead(k + 1);
		end generate middle;
		right: if (k = lineLast) generate
		begin
			regWIn(k) <= lineRead(k - 1) or lineRead(k);
		end generate right;
	end generate rowsGen;
	
	dataout <= lineRead;
	
end Behavioral;

