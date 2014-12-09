--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   14:50:51 12/03/2014
-- Design Name:   
-- Module Name:   /home/david/Documents/roberto/test_tb.vhd
-- Project Name:  roberto
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: usb2bram
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
 
ENTITY test_tb IS
END test_tb;
 
ARCHITECTURE behavior OF test_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT usb2bram
    PORT(
         start : IN  std_logic;
         rst : IN  std_logic;
         clk : IN  std_logic;
         ram_out : OUT  std_logic_vector(31 downto 0);
         output : OUT  std_logic_vector(127 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal start : std_logic := '0';
   signal rst : std_logic := '0';
   signal clk : std_logic := '0';

 	--Outputs
   signal countOut : std_logic_vector(8 downto 0);
   signal ram_out : std_logic_vector(31 downto 0);
   signal output : std_logic_vector(127 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: usb2bram PORT MAP (
          start => start,
          rst => rst,
          clk => clk,
          countOut => countOut,
          ram_out => ram_out,
          output => output
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
      wait for 100 ns;	

      wait for clk_period*10;

      -- insert stimulus here 
		rst <= '1' after 0 ns;
		rst <= '0' after 20 ns;
		start <= '1' after 0 ns;
		
      wait;
   end process;

END;
