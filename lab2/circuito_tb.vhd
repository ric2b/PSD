--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   15:59:28 11/04/2014
-- Design Name:   
-- Module Name:   C:/Users/PSD/lab2/circuito_tb.vhd
-- Project Name:  lab2
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
         a : in STD_LOGIC_VECTOR (15 downto 0);
			b : in STD_LOGIC_VECTOR (15 downto 0);
			c : in STD_LOGIC_VECTOR (15 downto 0);
			d : in STD_LOGIC_VECTOR (15 downto 0);
			e : in STD_LOGIC_VECTOR (15 downto 0);
			f : in STD_LOGIC_VECTOR (15 downto 0);
			g : in STD_LOGIC_VECTOR (15 downto 0);
			h : in STD_LOGIC_VECTOR (15 downto 0);
			i : in STD_LOGIC_VECTOR (15 downto 0);
         result : OUT  std_logic_vector(15 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';
   signal start : std_logic := '0';
   signal a,b,c,d,e,f,g,h,i : std_logic_vector(15 downto 0) := (others => '0');

 	--Outputs
   signal result : std_logic_vector(15 downto 0);

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
          result => result
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
      wait for clk_period;
		rst <= '1';
      wait for clk_period;		
		rst <= '0';
      -- insert stimulus here 

--		a <= x"0001";
--		b <= x"0003";
--		c <= x"0003";
--		d <= x"0001";
--		e <= x"0001";
--		f <= x"0001";
--		g <= x"0001";
--		h <= x"0003";
--		i <= x"0001";
		
--		a <= X"FFFE"; -- (-2)
--		b <= X"0003"; -- 3
--		c <= X"0001"; -- 1
--		d <= X"FFFC"; -- (-4)
--		e <= X"0005"; -- 5
--		f <= X"0002"; -- 2
--		g <= X"FFFD"; -- (-3)
--		h <= X"FFFC"; -- (-4)
--		i <= X"0001"; -- 1
		-- resultado esperado : (-1)
		
--		a <= X"7FFF"; -- 32767
--		b <= X"8AD0"; -- (-30000)
--		c <= X"0000"; -- 0
--		d <= X"FFFE"; -- (-2)
--		e <= X"7780"; -- 30592
--		f <= X"8620"; -- (-31200)
--		g <= X"006D"; -- 109
--		h <= X"FA22"; -- (-1502)
--		i <= X"737B"; -- 29563
		-- resultado esperado : 7072 
		
				
				a <= X"4E20"; 
				b <= X"0E10"; 
				c <= X"1770"; 
				d <= X"2328"; 
				e <= X"2710"; 
				f <= X"2320"; 
				g <= X"157C"; 
				h <= X"7530"; 
				i <= X"1838"; 
		-- resultado esperado : 16... 
		
		wait for clk_period;
		start <= '1';
		wait for clk_period;
		start <= '0';
		wait for clk_period*5;

		
      wait;
   end process;

END;
