--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   16:04:15 12/09/2014
-- Design Name:   
-- Module Name:   /home/david/Documents/roberto/t_tb.vhd
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
 
ENTITY t_tb IS
END t_tb;
 
ARCHITECTURE behavior OF t_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT usb2bram
    PORT(
         start : IN  std_logic;
         rst : IN  std_logic;
         clk : IN  std_logic;
         done : OUT  std_logic;
         regR10_out : OUT  std_logic_vector(31 downto 0);
         regR11_out : OUT  std_logic_vector(31 downto 0);
         regR12_out : OUT  std_logic_vector(31 downto 0);
         regR1_out : OUT  std_logic_vector(127 downto 0);
			regR2_out : out std_logic_vector(127 downto 0);
         addrOut : OUT  std_logic_vector(8 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal start : std_logic := '0';
   signal rst : std_logic := '0';
   signal clk : std_logic := '0';

 	--Outputs
   signal done : std_logic;
   signal regR10_out : std_logic_vector(31 downto 0);
   signal regR11_out : std_logic_vector(31 downto 0);
   signal regR12_out : std_logic_vector(31 downto 0);
   signal regR1_out : std_logic_vector(127 downto 0);
	signal regR2_out : std_logic_vector(127 downto 0);
   signal addrOut : std_logic_vector(8 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: usb2bram PORT MAP (
          start => start,
          rst => rst,
          clk => clk,
          done => done,
          regR10_out => regR10_out,
          regR11_out => regR11_out,
          regR12_out => regR12_out,
          regR1_out => regR1_out,
			 regR2_out => regR2_out,
          addrOut => addrOut
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
