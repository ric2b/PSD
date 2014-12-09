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
		done : out std_logic;
		-- bits de controlo do porto A
		adrA : out std_logic_vector(10 downto 0);
		ctlEnA : out std_logic;
		ctlWeA : out std_logic;
		-- bits de controlo do porto B
		adrB : out std_logic_vector(8 downto 0);
		ctlEnB : out std_logic;
		ctlWeB : out std_logic;
		
		enRegR1 : out std_logic_vector(2 downto 0); 	-- enables dos registos de leitura --
		enRegR2 : out std_logic
	);
end controlo;

architecture Behavioral of controlo is
	-- state machine signals --
	type fsm_states is ( s_initial, s_end, s_read_image, s_logic );
	signal currstate, nextstate : fsm_states;
	
	-- counter signals --
	signal count : std_logic_vector (8 downto 0); --tem que ter o mesmo tamanho do endereo do porto B
	signal enCount, endCount, stopCount : std_logic;
	constant countEND : std_logic_vector (8 downto 0) := "001111111";
	constant countSTOP : std_logic_vector (1 downto 0) := "11";
  
begin
	
	endCount <= '1' when count = countEND else '0';
	stopCount <= '1' when count(1 downto 0) = countSTOP else '1';
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

	state_comb: process (currstate, start, count, endCount, stopCount)
	begin  --  process
		nextstate <= currstate ;  -- by default, does not change the state.
		-- default values --
		done <= '0';
		adrA <= "00000000000";
		ctlEnA <= '0';
		ctlWeA <= '0';
		adrB <= "000000000";
		ctlEnB <= '0';
		ctlWeB <= '0';
		enCount <= '0';
		enRegR1 <= "000";
		enRegR2 <= '0';
	
		case currstate is
			when s_initial =>
				if start='1' then
					nextstate <= s_read_image ;
				end if;
			
			when s_read_image =>
				if stopCount = '1' or endCount = '1' then
					nextstate <= s_logic;
				else
					nextstate <= s_read_image;
				end if;
				enCount <= '1';
				ctlEnB <= '1';
				adrB <= count;
				enRegR1 <= '1'&count(1 downto 0);
			
			when s_logic =>
				if endCount = '1' then
					nextstate <= s_end;
				else
					nextstate <= s_read_image;
				end if;
				enRegR2 <= '1';
				
			when s_end =>
				done <= '1';
			
		end case;
	end process;
	
end Behavioral;

