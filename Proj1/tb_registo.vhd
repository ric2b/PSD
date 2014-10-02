-- TestBench Template 

  LIBRARY ieee;
  USE ieee.std_logic_1164.ALL;
  USE ieee.numeric_std.ALL;

  ENTITY testbench IS
  END testbench;

  ARCHITECTURE behavior OF testbench IS 

  -- Component Declaration
          COMPONENT registo
				 Port ( reg_in : in  STD_LOGIC_VECTOR (7 downto 0);
						  reg_out : out  STD_LOGIC_VECTOR (7 downto 0);
						  load : in  STD_LOGIC;
						  reset : in STD_LOGIC
						 );
          END COMPONENT;

          signal reg_in, reg_out : STD_LOGIC_VECTOR (7 downto 0);
			 signal reset, load : STD_LOGIC;
  BEGIN
	-- Instantiate the Unit Under Test (UUT)
		uut: circuito PORT MAP (
			clk => clk,
			rst => rst,
			instr => instr,
			data_in => data_in,
			res => res
		);
	-- Clock process definitions
		clk_process: process
		begin
			clk <= '0';
			wait for clk_period/2;
			clk <= '1';
			wait for clk_period/2;
		end process;
	-- Stimulus process
	stim_proc: process
	begin
		-- hold reset state for 100 ns.
		wait for 100 ns;
		wait for clk_period*10;
		
		-- insert stimulus here
		rst <= '1' after 20 ns,
		'0' after 40 ns;
		data_in <= X"67" after 40 ns,
					  X"12" after 120 ns,
					  X"C3" after 200 ns;
		instr <= "001" after 40 ns,
					"000" after 80 ns,
					"010" after 120 ns,
					"000" after 160 ns,
					"100" after 200 ns,
					"000" after 300 ns;
		wait;
	end process;

  END;
