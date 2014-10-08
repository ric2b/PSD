LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
ENTITY datapath_tb IS
END datapath_tb;
 
ARCHITECTURE behavior OF datapath_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT datapath
    PORT(
         data_in : IN  std_logic_vector(6 downto 0);
         reg_select : IN  std_logic;
         oper : IN  std_logic_vector(1 downto 0);
         clk : IN  std_logic;
         rst : IN  std_logic;
         data_out : OUT  std_logic_vector(12 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal data_in : std_logic_vector(6 downto 0) := (others => '0');
   signal reg_select : std_logic := '0';
   signal oper : std_logic_vector(1 downto 0) := (others => '0');
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';

 	--Outputs
   signal data_out : std_logic_vector(12 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: datapath PORT MAP (
          data_in => data_in,
          reg_select => reg_select,
          oper => oper,
          clk => clk,
          rst => rst,
          data_out => data_out
        );

   -- Clock process definitions
   clk_process :process
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
      -- insert stimulus here 
		data_in <= "0000010" after 10 ns,
					  "0000011" after 30 ns;
					  
		oper <= "01" after 10 ns,
				  "10" after 20 ns,
				  "11" after 30 ns,
				  "00" after 40 ns;
				  
      wait;
   end process;

END;
