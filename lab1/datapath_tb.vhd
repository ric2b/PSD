--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   15:55:26 10/14/2014
-- Design Name:   
-- Module Name:   /home/david/Dropbox/IST/Ano4/Semestre1/PSD/Labs/P1/Projecto1/work/lab1/datapath_tb.vhd
-- Project Name:  lab1
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: datapath
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
		rst <= '0';
		data_in <= "0000011" after 10 ns, -- 3 * 4 = 12--
					  "0000100" after 20 ns,
					  "0000011" after 30 ns,
					  "1111101" after 40 ns, -- -3 * 12 = -36 --
					  "0000011" after 50 ns,
					  "1011100" after 60 ns, -- -36 * -36 = 1296--
					  "0000011" after 70 ns,
					  "0000110" after 80 ns, -- 6 * 1296 = overflow --
					  "0000011" after 90 ns;
					  
		oper <= "01" after 10 ns,
				  "10" after 20 ns,
				  "11" after 30 ns,
				  "01" after 40 ns,
				  "11" after 50 ns,
				  "01" after 60 ns,
				  "11" after 70 ns,
				  "01" after 80 ns,
				  "11" after 90 ns,
				  "00" after 100 ns;

      wait;
   end process;

END;
