--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   22:09:04 12/14/2014
-- Design Name:   
-- Module Name:   /home/david/Dropbox/IST/Ano4/Semestre1/PSD/Labs/P3/PSD/Imagens/controlo_level1_tb.vhd
-- Project Name:  Imagens
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: controlo_level1
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
 
ENTITY controlo_level1_tb IS
END controlo_level1_tb;
 
ARCHITECTURE behavior OF controlo_level1_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT controlo_level1
    PORT(
         start : IN  std_logic;
         clk : IN  std_logic;
         rst : IN  std_logic;
         oper : IN  std_logic_vector(1 downto 0);
         operSimple : OUT  std_logic;
         adrBMemRead : OUT  std_logic_vector(8 downto 0);
         enBMemRead : OUT  std_logic;
         writeEnBMemRead : OUT  std_logic;
         enBMemWrite0 : OUT  std_logic;
         writeEnBMemWrite0 : OUT  std_logic;
         enBMemWrite1 : OUT  std_logic;
         writeEnBMemWrite1 : OUT  std_logic;
         enRegRead : OUT  std_logic_vector(2 downto 0);
         enRegRiPrevious : OUT  std_logic;
         enRegRiCurrent : OUT  std_logic;
         enRegRiNext : OUT  std_logic;
         selectMuxOper : OUT  std_logic;
         enRegResult : OUT  std_logic;
         selectMuxDataIn : OUT  std_logic;
         selectMuxMemWriteAdr : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal start : std_logic := '0';
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';
   signal oper : std_logic_vector(1 downto 0) := (others => '0');

 	--Outputs
   signal operSimple : std_logic;
   signal adrBMemRead : std_logic_vector(8 downto 0);
   signal enBMemRead : std_logic;
   signal writeEnBMemRead : std_logic;
   signal enBMemWrite0 : std_logic;
   signal writeEnBMemWrite0 : std_logic;
   signal enBMemWrite1 : std_logic;
   signal writeEnBMemWrite1 : std_logic;
   signal enRegRead : std_logic_vector(2 downto 0);
   signal enRegRiPrevious : std_logic;
   signal enRegRiCurrent : std_logic;
   signal enRegRiNext : std_logic;
   signal selectMuxOper : std_logic;
   signal enRegResult : std_logic;
   signal selectMuxDataIn : std_logic;
   signal selectMuxMemWriteAdr : std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: controlo_level1 PORT MAP (
          start => start,
          clk => clk,
          rst => rst,
          oper => oper,
          operSimple => operSimple,
          adrBMemRead => adrBMemRead,
          enBMemRead => enBMemRead,
          writeEnBMemRead => writeEnBMemRead,
          enBMemWrite0 => enBMemWrite0,
          writeEnBMemWrite0 => writeEnBMemWrite0,
          enBMemWrite1 => enBMemWrite1,
          writeEnBMemWrite1 => writeEnBMemWrite1,
          enRegRead => enRegRead,
          enRegRiPrevious => enRegRiPrevious,
          enRegRiCurrent => enRegRiCurrent,
          enRegRiNext => enRegRiNext,
          selectMuxOper => selectMuxOper,
          enRegResult => enRegResult,
          selectMuxDataIn => selectMuxDataIn,
          selectMuxMemWriteAdr => selectMuxMemWriteAdr
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
		oper <= "10";
		
		rst <= '1' after 0 ns;
		rst <= '0' after clk_period;
		start <= '1' after 2*clk_period;

      wait;
   end process;

END;
