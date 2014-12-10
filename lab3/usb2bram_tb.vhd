--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   18:12:42 12/10/2014
-- Design Name:   
-- Module Name:   /home/david/Dropbox/IST/Ano4/Semestre1/PSD/Labs/P3/PSD/Imagens/usb2bram_tb.vhd
-- Project Name:  Imagens
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
 
ENTITY usb2bram_tb IS
END usb2bram_tb;
 
ARCHITECTURE behavior OF usb2bram_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT usb2bram
    PORT(
         start : IN  std_logic;
         rst : IN  std_logic;
         clk : IN  std_logic;
         oper : IN  std_logic;
         addrin_out : OUT  std_logic_vector(8 downto 0);
         datain_out : OUT  std_logic_vector(31 downto 0);
         regRin_out : OUT  std_logic_vector(127 downto 0);
         regRiprev_out : OUT  std_logic_vector(127 downto 0);
         regRicurr_out : OUT  std_logic_vector(127 downto 0);
         regRinext_out : OUT  std_logic_vector(127 downto 0);
         regRres_out : OUT  std_logic_vector(127 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal start : std_logic := '0';
   signal rst : std_logic := '0';
   signal clk : std_logic := '0';
   signal oper : std_logic := '0';

 	--Outputs
   signal addrin_out : std_logic_vector(8 downto 0);
   signal datain_out : std_logic_vector(31 downto 0);
   signal regRin_out : std_logic_vector(127 downto 0);
   signal regRiprev_out : std_logic_vector(127 downto 0);
   signal regRicurr_out : std_logic_vector(127 downto 0);
   signal regRinext_out : std_logic_vector(127 downto 0);
   signal regRres_out : std_logic_vector(127 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: usb2bram PORT MAP (
          start => start,
          rst => rst,
          clk => clk,
          oper => oper,
          addrin_out => addrin_out,
          datain_out => datain_out,
          regRin_out => regRin_out,
          regRiprev_out => regRiprev_out,
          regRicurr_out => regRicurr_out,
          regRinext_out => regRinext_out,
          regRres_out => regRres_out
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
		oper <= '0';
		
		rst <= '1' after 0 ns;
		rst <= '0' after clk_period;
		start <= '1' after 2*clk_period;

      wait;
   end process;

END;
