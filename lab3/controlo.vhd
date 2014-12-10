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

		-- bits de controlo do porto B de MR
		adrB_in 		: out std_logic_vector(8 downto 0);
		busDiB_in 		: out std_logic_vector(31 downto 0);
		ctlEnB_in 		: out std_logic;
		ctlWeB_in 		: out std_logic;
		
		-- bits de controlo do porto B de MW
		adrB_out 		: out std_logic_vector(8 downto 0);
		busDiB_out 		: out std_logic_vector(31 downto 0);
		ctlEnB_out 		: out std_logic;
		ctlWeB_out 		: out std_logic;

		-- enables e selects --
		regRin_en 		: out std_logic_vector(2 downto 0);		-- enables dos registos de entrada
		regRiprev_en	: out std_logic; 						-- enable do registo Ri-1
		regRicurr_en	: out std_logic;						-- enable do registo Ri
		regRinext_en	: out std_logic;						-- enable do registo Ri+1
		mux1_select		: out std_logic;						-- select do mux 1 que seleciona a entrada de Ri+1
		regRres_en		: out std_logic							-- enable do registo que guarda o resultado
		
	);
end controlo;

architecture Behavioral of controlo is
	-- state machine signals --
	type fsm_states is ( s_initial, s_end, s_first, s_last0, s_last1, s_last2, s_process);
	signal currstate, nextstate : fsm_states;
	
	-- counter signals --
	signal count : std_logic_vector (8 downto 0); --tem que ter o mesmo tamanho do endereco do porto B
	signal enCount, endCount, endRow : std_logic;
	constant countEND : std_logic_vector (8 downto 0) := "000001111";
	constant rowEND : std_logic_vector (1 downto 0) := "11";
  
begin
	endCount <= '1' when count = countEND else '0';
	endRow <= '1' when count(1 downto 0) = rowEND else '0';
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

	state_comb: process (currstate, start, count, endCount, endRow)
	begin  --  process
		nextstate <= currstate ;  -- by default, does not change the state.
		-- default values --
		adrB_in <= "000000000";
		busDiB_in <= X"10000000";
		ctlEnB_in <= '0';
		ctlWeB_in <= '0';
		adrB_out <= "000000000";
		busDiB_out <= X"10000000";
		ctlEnB_out <= '0';
		ctlWeB_out <= '0';
		regRin_en <= "000";
		regRiprev_en <= '0';
		regRicurr_en <= '0';
		regRinext_en <= '0';
		mux1_select <= '0';
		regRres_en <= '0';
		enCount <= '0';
	
		case currstate is
			when s_initial =>
				if start='1' then
					nextstate <= s_first ;
				end if;
			
			when s_first =>
				if endRow='1' then
					nextstate <= s_process;
				else
					nextstate <= s_first;
				end if;
				enCount <= '1';
				ctlEnB_in <= '1';
				adrB_in <= count;
				regRin_en <= '1' & count(1 downto 0);
				mux1_select <= '1';
				regRiprev_en <= '1';
				regRicurr_en <= '1';
				regRinext_en <= '1';

			when s_process =>
				if endCount='1' then
					nextstate <= s_last0;
				else
					nextstate <= s_process;
				end if;
				enCount <= '1';
				ctlEnB_in <= '1';
				adrB_in <= count;
				regRin_en <= '1' & count(1 downto 0);

				if count(1 downto 0)="00" then
					regRiprev_en <= '1';
					regRicurr_en <= '1';
					regRinext_en <= '1';
				elsif count(1 downto 0)="01" then
					regRres_en <= '1';
				end if;
			
			when s_last0 =>
				nextstate <= s_last1;
				regRiprev_en <= '1';
				regRicurr_en <= '1';
				regRinext_en <= '1';

			when s_last1 =>
				nextstate <= s_last2;
				mux1_select <= '1';
				regRiprev_en <= '1';
				regRicurr_en <= '1';
				regRinext_en <= '1';
				regRres_en <= '1';

			when s_last2 =>
				nextstate <= s_end;
				regRres_en <= '1';				

			when s_end =>
			
		end case;
	end process;
	
end Behavioral;

