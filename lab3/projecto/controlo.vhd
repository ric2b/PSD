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
		ctlEnB_in 		: out std_logic;
		ctlWeB_in 		: out std_logic;
		
		-- bits de controlo do porto B de MW
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
	type fsm_states is ( s_initial, s_first, s_process, s_last, s_end);
	signal currstate, nextstate : fsm_states;
	
	-- counter signals --
	signal count : std_logic_vector (9 downto 0); --tem que ter o mesmo tamanho do endereco do porto B
	signal enCount, endCount, endRow, endLast : std_logic;
	constant countEND : std_logic_vector (9 downto 0) := "1000000011"; 	-- determina quando termina a contagem (512 enderecos + 4) - 1 = 515
	constant rowEND : std_logic_vector (1 downto 0) := "11";			-- determina quando termina uma linha
	constant lastEND : std_logic_vector (9 downto 0) := "0000000101";	-- determina uma contagem de seis para o estado s_last terminar apos 6 ciclos

begin
	endCount <= '1' when count = countEND else '0';
	endRow <= '1' when count(1 downto 0) = rowEND else '0';
	endLast <= '1' when count = lastEND else '0';
	process (clk, rst) 
	begin
		if rst='1' then 
			count <= (others => '0');
		elsif clk='1' and clk'event then
			if enCount='1' then
				if endCount = '0' then
					count <= count + 1;
				else
					count <= (others => '0');		-- reiniciar o contador quando ele termina a contagem
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

	state_comb: process (currstate, start, count, endCount, endRow, endLast)
	begin  --  process
		nextstate <= currstate ;  -- by default, does not change the state.
		-- default values --
		adrB_in <= "000000000";
		ctlEnB_in <= '1';
		ctlWeB_in <= '0';
		ctlEnB_out <= '1';
		ctlWeB_out <= '1';
		regRin_en <= "000";
		regRiprev_en <= '0';
		regRicurr_en <= '0';
		regRinext_en <= '0';
		mux1_select <= '0';
		regRres_en <= '0';
		enCount <= '0';
	
		case currstate is
			when s_initial => -- começa o processamento se o sinal start ficar a high
				if start='1' then
					nextstate <= s_first ;
				end if;
			
			when s_first => -- preencher regRiprev com 'oper'. depois, passar ao processamento
				if endRow='1' then
					nextstate <= s_process;
				else
					nextstate <= s_first;
				end if;
				enCount <= '1';
				ctlEnB_in <= '1';
				adrB_in <= count(8 downto 0);
				regRin_en <= '1' & count(1 downto 0);
				mux1_select <= '1';
				regRiprev_en <= '1';
				regRicurr_en <= '1';
				regRinext_en <= '1';

			when s_process => -- lê a próxima linha e faz os cálculos da linha actual (regRicurr). Se já leu todas as linhas, passar ao caso especial da última linha (s_last0)
				if endCount='1' then
					nextstate <= s_last;
				else
					nextstate <= s_process;
				end if;
				enCount <= '1';
				ctlEnB_in <= '1';
				adrB_in <= count(8 downto 0);
				regRin_en <= '1' & count(1 downto 0);

				if count(1 downto 0)="00" then -- fazer shift das 3 linhas actuais nos registos
					regRiprev_en <= '1';
					regRicurr_en <= '1';
					regRinext_en <= '1';
				elsif count(1 downto 0)="01" then
					regRres_en <= '1';
				end if;
			
			when s_last =>
				if endLast = '1' then
					nextstate <= s_end;
				else
					nextstate <= s_last;
				end if;

				-- count = 0 ; primeiro ciclo --
				if count = "0000000000" then
					-- carregar linha de 'oper' --
					mux1_select <= '1';
					regRiprev_en <= '1';
					regRicurr_en <= '1';
					regRinext_en <= '1';
				end if;

				-- count = 1 ; segundo ciclo --
				if count = "0000000001" then
					-- guardar resultado da ultima linha --
					regRres_en <= '1';
				end if;

			when s_end => -- terminou a execução, idle
			
		end case;
	end process;
	
end Behavioral;

