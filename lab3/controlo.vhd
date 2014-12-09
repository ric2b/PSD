library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity controlo is
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
		
		enRegR : out std_logic; 						-- enable dos registos de leitura
		regR_select : out std_logic_vector(1 downto 0);	-- select do registo de leitura onde escrever
		enRegW : out std_logic;							-- enables dos registos de escrita (1 bit por registo)
		enRegMR : out std_logic;							-- enable do registo de leitura da memoria de escrita
		enRegMW : out std_logic							-- enable do registo de escrita da memoria de escrita
	);
end controlo;

architecture Behavioral of controlo is
	-- state machine signals --
	type fsm_states is ( s_initial, s_end, s_read_image, s_process, s_read_write, s_or, s_write_write );
	signal currstate, nextstate : fsm_states;
	
	-- counter signals --
	signal count : std_logic_vector (8 downto 0); --tem que ter o mesmo tamanho do endereo do porto B
	signal enCount, endCount : std_logic;
	constant countEND : std_logic_vector (8 downto 0) := "000000011";
  
begin
	endCount <= '1' when count = countEND else '0';
	process (clk, rst) 
	begin
		if rst='1' then 
			count <= (others => '0');
		elsif clk='1' and clk'event then
			if enCount='1' then
				if endCount = '0' then
					count <= count + 1;
				end if;
			end if;
		end if;
	end process;
	
	state_reg: process (clk, rst)
	begin
		if rst = '1' then
			currstate <= s_initial;
		elsif clk'event and clk = '1' then
			currstate <= nextstate;
		end if;
	end process;

	state_comb: process (currstate, start, count, endCount)
	begin  --  process
		nextstate <= currstate ;  -- by default, does not change the state.
		-- default values --
		adrA <= "00000000000";
		busDiA <= "00000000";
		ctlEnA <= '0';
		ctlWeA <= '0';
		adrB <= "000000000";
		busDiB <= X"10000000";
		ctlEnB <= '0';
		ctlWeB <= '0';
		enCount <= '0';
		enRegR <= '0';
		regR_select <= "00";
		enRegW <= '0';
		enRegMR <= '0';
		enRegMW <= '0';
	
		case currstate is
			when s_initial =>
				if start='1' then
					nextstate <= s_read_image ;
				end if;
			
			when s_read_image =>
				if endCount = '1' then
					nextstate <= s_process;
				else
					nextstate <= s_read_image;
				end if;
				enCount <= '1';
				ctlEnB <= '1';
				adrB <= count;
				enRegR <= '1';
				regR_select <= count(1 downto 0);
			
			when s_process =>
				nextstate <= s_read_write;
				enRegW <= '1';
				
			when s_read_write =>
				nex
			
			when s_end =>
			
		end case;
	end process;
	
end Behavioral;

