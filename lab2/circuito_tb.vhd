--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   11:48:03 11/16/2014
-- Design Name:   
-- Module Name:   /home/david/Dropbox/IST/Ano4/Semestre1/PSD/Labs/P2/ya/Proj2/circuito_tb.vhd
-- Project Name:  Proj2
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
         clk : IN  std_logic;
         rst : IN  std_logic;
         start : IN  std_logic;
         a : IN  std_logic_vector(15 downto 0);
         b : IN  std_logic_vector(15 downto 0);
         c : IN  std_logic_vector(15 downto 0);
         d : IN  std_logic_vector(15 downto 0);
         e : IN  std_logic_vector(15 downto 0);
         f : IN  std_logic_vector(15 downto 0);
         g : IN  std_logic_vector(15 downto 0);
         h : IN  std_logic_vector(15 downto 0);
         i : IN  std_logic_vector(15 downto 0);
         result : OUT  std_logic_vector(15 downto 0);
         done : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';
   signal start : std_logic := '0';
   signal a : std_logic_vector(15 downto 0) := (others => '0');
   signal b : std_logic_vector(15 downto 0) := (others => '0');
   signal c : std_logic_vector(15 downto 0) := (others => '0');
   signal d : std_logic_vector(15 downto 0) := (others => '0');
   signal e : std_logic_vector(15 downto 0) := (others => '0');
   signal f : std_logic_vector(15 downto 0) := (others => '0');
   signal g : std_logic_vector(15 downto 0) := (others => '0');
   signal h : std_logic_vector(15 downto 0) := (others => '0');
   signal i : std_logic_vector(15 downto 0) := (others => '0');

 	--Outputs
   signal result : std_logic_vector(15 downto 0);
   signal done : std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: circuito PORT MAP (
          clk => clk,
          rst => rst,
          start => start,
          a => a,
          b => b,
          c => c,
          d => d,
          e => e,
          f => f,
          g => g,
          h => h,
          i => i,
          result => result,
          done => done
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

		rst <= '1' after 0 ns;
		rst <= '0' after clk_period;
      -- insert stimulus here 
		
		a <= X"FFFE" after 0 ns; -- (-2)
		b <= X"0003" after 0 ns; -- 3
		c <= X"0001" after 0 ns; -- 1
		d <= X"FFFC" after 0 ns; -- (-4)
		e <= X"0005" after 0 ns; -- 5
		f <= X"0002" after 0 ns; -- 2
		g <= X"FFFD" after 0 ns; -- (-3)
		h <= X"FFFC" after 0 ns; -- (-4)
		i <= X"0001" after 0 ns; -- 1
--		 resultado esperado : (-1)
		
		start <= '0';
		wait for clk_period;
		start <= '1';
		wait for 2*clk_period;
		start <= '0';

      wait;
   end process;

END;
