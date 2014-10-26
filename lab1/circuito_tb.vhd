--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   13:55:39 10/19/2014
-- Design Name:   
-- Module Name:   /home/david/Dropbox/IST/Ano4/Semestre1/PSD/Labs/P1/Projecto1/work/lab1/circuito_tb.vhd
-- Project Name:  lab1
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: circuito
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY circuito_tb IS
END circuito_tb;
 
ARCHITECTURE behavior OF circuito_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT circuito
    PORT(
         instr : IN  std_logic_vector(2 downto 0);
         data_in : IN  std_logic_vector(6 downto 0);
         reg_select : IN  std_logic;
         data_out : OUT  std_logic_vector(12 downto 0);
         clk : IN  std_logic;
         reset : IN  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal instr : std_logic_vector(2 downto 0) := (others => '0');
   signal data_in : std_logic_vector(6 downto 0) := (others => '0');
   signal reg_select : std_logic := '0';
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';

 	--Outputs
   signal data_out : std_logic_vector(12 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: circuito PORT MAP (
          instr => instr,
          data_in => data_in,
          reg_select => reg_select,
          data_out => data_out,
          clk => clk,
          reset => reset
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
		
--		data_in <= "0000011" after 10 ns,  	-- R1 <- 3 --
--					  "0000111" after 40 ns,	-- R2 <- 7 --
--					  "0000001" after 70 ns;	-- R2 <- R1 + R2 --
--		
--		instr <= "100" after 10 ns, -- R1 <- 3 --
--					"000" after 20 ns,
--					"010" after 40 ns, -- R2 <- 7 --
--					"000" after 50 ns,
--					"001" after 70 ns, -- R2 <- R1 + R2 --
--					"000" after 80 ns;
--		
--		reg_select <= '1' after 10 ns, -- mostrar R1 --
--						  '0' after 40 ns; -- mostrar R2 --
					  
		data_in <= "0111111" after 10 ns,  	-- R1 <- +63 --
					  "1111111" after 40 ns,	-- R2 <- -63 --
					  "0000011" after 70 ns;	-- R2 <- R1 + R2 --
		
		instr <= "100" after 10 ns, -- R1 <- +63 --
					"000" after 20 ns,
					"010" after 40 ns, -- R2 <- -63 --
					"000" after 50 ns,
					"001" after 70 ns, -- R2 <- R1 * R2 --
					"000" after 80 ns,
					"001" after 90 ns, -- overflow R2 <- R1 * R2 --
					"000" after 100 ns;
		
		reg_select <= '1' after 10 ns, -- mostrar R1 --
						  '0' after 40 ns; -- mostrar R2 --
		
      wait;
   end process;

END;
