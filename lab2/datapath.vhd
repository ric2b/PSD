----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:25:37 10/21/2014 
-- Design Name: 
-- Module Name:    datapath - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_SIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity datapath is
    Port ( clk : in STD_LOGIC;
			  enR1 : in  STD_LOGIC;
           X1_select1 : in  STD_LOGIC_VECTOR (1 downto 0);
           X1_select2 : in  STD_LOGIC_VECTOR (1 downto 0);
           X2_select1 : in  STD_LOGIC_VECTOR (1 downto 0);
           X2_select2 : in  STD_LOGIC_VECTOR (1 downto 0);
           adder_select : in  STD_LOGIC;
			  adder_control : in STD_LOGIC;
           matrix : in  STD_LOGIC_VECTOR (143 downto 0);
           result : out  STD_LOGIC_VECTOR (15 downto 0));
			 
end datapath;

architecture Behavioral of datapath is
	signal x1_input1, x1_input2, x2_input1, x2_input2, adder_input1, adder_input2 : std_logic_vector (15 downto 0);
	signal adder_out : std_logic_vector (15 downto 0);
	signal x1_out, x2_out : std_logic_vector (31 downto 0);
	signal reg1_input, reg2_input, regX1_input, regX2_input : std_logic_vector (15 downto 0);
	signal a, b, c, d, e, f, g, h ,i : std_logic_vector (15 downto 0);
	signal reg1, reg2, regX1, regX2 : std_logic_vector (15 downto 0);
begin
	
	-- inputs --
	a <= matrix(143 downto 128);
	b <= matrix(127 downto 112);
	c <= matrix(111 downto 96);
	d <= matrix(95 downto 80);
	e <= matrix(79 downto 64);
	f <= matrix(63 downto 48);
	g <= matrix(47 downto 32);
	h <= matrix(31 downto 16);
	i <= matrix(15 downto 0);
	
	-- Mux X1.1 --
	with X1_select1 select
		x1_input1 <= a when "00",
						 f when "01",
						 d when "10",
						 c when "11",
						 x"0000" when others;
						
	-- Mux X1.2 --
	with X1_select2 select
		x1_input2 <= e when "00",
						 g when "01",
						 h when "10",
						 reg1 when "11",
						 x"0000" when others;
						 
	-- Mux X2.1 --
	with X2_select1 select
		x2_input1 <= f when "00",
						 d when "01",
						 e when "10",
						 reg2 when "11",
						 x"0000" when others;
						 
	-- Mux X2.2 --
	with X2_select2 select
		x2_input2 <= h when "00",
						 i when "01",
						 g when "10",
						 b when "11",
						 x"0000" when others;
						 
	-- Mux Adder --
	with adder_select select
		adder_input1 <= regX2 when '0',
							 reg1 when '1',
							 x"0000" when others;
						 
	
	-- Register R1 --
	process (clk)
	begin
		if clk'event and clk='1' and enR1='1' then
			reg1 <= reg1_input;
		end if;
	end process;
						 
	-- Register R2 --
	process (clk)
	begin
		if clk'event and clk='1' then
			reg2 <= reg2_input;
		end if;
	end process;
	
	-- Register RX1 --
	process (clk)
	begin
		if clk'event and clk='1' then
			regX1 <= regX1_input;
		end if;
	end process;
	
	-- Register RX2 --
	process (clk)
	begin
		if clk'event and clk='1' then
			regX2 <= regX2_input;
		end if;
	end process;
	
	-- Multiplier X1 --
	x1_out <= x1_input1 * x1_input2;
	-- Multiplier X2 --
	x2_out <= x2_input1 * x2_input2;
	-- Adder/Subtractor --
	with adder_control select
		adder_out <= adder_input1 + adder_input2 when '0',
						 adder_input1 - adder_input2 when '1',
						 x"0000" when others;

end Behavioral;

