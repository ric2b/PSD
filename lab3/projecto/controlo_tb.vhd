--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   18:07:15 12/10/2014
-- Design Name:   
-- Module Name:   /home/david/Dropbox/IST/Ano4/Semestre1/PSD/Labs/P3/PSD/Imagens/controlo_tb.vhd
-- Project Name:  Imagens
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
         adrB_in : OUT  std_logic_vector(8 downto 0);
         busDiB_in : OUT  std_logic_vector(31 downto 0);
         ctlEnB_in : OUT  std_logic;
         ctlWeB_in : OUT  std_logic;
         adrB_out : OUT  std_logic_vector(8 downto 0);
         busDiB_out : OUT  std_logic_vector(31 downto 0);
         ctlEnB_out : OUT  std_logic;
         ctlWeB_out : OUT  std_logic;
         regRin_en : OUT  std_logic_vector(2 downto 0);
         regRiprev_en : OUT  std_logic;
         regRicurr_en : OUT  std_logic;
         regRinext_en : OUT  std_logic;
         mux1_select : OUT  std_logic;
         regRres_en : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal start : std_logic := '0';
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';

 	--Outputs
   signal adrB_in : std_logic_vector(8 downto 0);
   signal busDiB_in : std_logic_vector(31 downto 0);
   signal ctlEnB_in : std_logic;
   signal ctlWeB_in : std_logic;
   signal adrB_out : std_logic_vector(8 downto 0);
   signal busDiB_out : std_logic_vector(31 downto 0);
   signal ctlEnB_out : std_logic;
   signal ctlWeB_out : std_logic;
   signal regRin_en : std_logic_vector(2 downto 0);
   signal regRiprev_en : std_logic;
   signal regRicurr_en : std_logic;
   signal regRinext_en : std_logic;
   signal mux1_select : std_logic;
   signal regRres_en : std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: controlo PORT MAP (
          start => start,
          clk => clk,
          rst => rst,
          adrB_in => adrB_in,
          busDiB_in => busDiB_in,
          ctlEnB_in => ctlEnB_in,
          ctlWeB_in => ctlWeB_in,
          adrB_out => adrB_out,
          busDiB_out => busDiB_out,
          ctlEnB_out => ctlEnB_out,
          ctlWeB_out => ctlWeB_out,
          regRin_en => regRin_en,
          regRiprev_en => regRiprev_en,
          regRicurr_en => regRicurr_en,
          regRinext_en => regRinext_en,
          mux1_select => mux1_select,
          regRres_en => regRres_en
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
		rst <= '0' after clk_period;
		start <= '1' after 2*clk_period;
		
      wait;
   end process;

END;
