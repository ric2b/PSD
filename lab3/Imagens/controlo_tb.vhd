--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   14:52:15 12/03/2014
-- Design Name:   
-- Module Name:   /home/david/Documents/roberto/controlo_tb.vhd
-- Project Name:  roberto
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: controlo
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
 
ENTITY controlo_tb IS
END controlo_tb;
 
ARCHITECTURE behavior OF controlo_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT controlo
    PORT(
         start : IN  std_logic;
         clk : IN  std_logic;
         rst : IN  std_logic;
         adrA : OUT  std_logic_vector(10 downto 0);
         busDiA : OUT  std_logic_vector(7 downto 0);
         ctlEnA : OUT  std_logic;
         ctlWeA : OUT  std_logic;
         adrB : OUT  std_logic_vector(8 downto 0);
         busDiB : OUT  std_logic_vector(31 downto 0);
         ctlEnB : OUT  std_logic;
         ctlWeB : OUT  std_logic;
         countOut : OUT  std_logic_vector(8 downto 0);
         enRegR : OUT  std_logic_vector(1 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal start : std_logic := '0';
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';

 	--Outputs
   signal adrA : std_logic_vector(10 downto 0);
   signal busDiA : std_logic_vector(7 downto 0);
   signal ctlEnA : std_logic;
   signal ctlWeA : std_logic;
   signal adrB : std_logic_vector(8 downto 0);
   signal busDiB : std_logic_vector(31 downto 0);
   signal ctlEnB : std_logic;
   signal ctlWeB : std_logic;
   signal countOut : std_logic_vector(8 downto 0);
   signal enRegR : std_logic_vector(1 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: controlo PORT MAP (
          start => start,
          clk => clk,
          rst => rst,
          adrA => adrA,
          busDiA => busDiA,
          ctlEnA => ctlEnA,
          ctlWeA => ctlWeA,
          adrB => adrB,
          busDiB => busDiB,
          ctlEnB => ctlEnB,
          ctlWeB => ctlWeB,
          countOut => countOut,
          enRegR => enRegR
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
