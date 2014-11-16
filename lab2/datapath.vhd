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
			  RA1_enable : in STD_LOGIC;
			  RA2_enable : in STD_LOGIC;
			  RX1_enable : in STD_LOGIC;
			  RX2_enable : in STD_LOGIC;
           X1_select1 : in STD_LOGIC_VECTOR (1 downto 0);
           X1_select2 : in STD_LOGIC_VECTOR (1 downto 0);
           X2_select1 : in STD_LOGIC_VECTOR (1 downto 0);
           X2_select2 : in STD_LOGIC_VECTOR (1 downto 0);
           adder_select : in STD_LOGIC;
			  adder_control : in STD_LOGIC;
           a : in STD_LOGIC_VECTOR (15 downto 0);
			  b : in STD_LOGIC_VECTOR (15 downto 0);
			  c : in STD_LOGIC_VECTOR (15 downto 0);
			  d : in STD_LOGIC_VECTOR (15 downto 0);
			  e : in STD_LOGIC_VECTOR (15 downto 0);
			  f : in STD_LOGIC_VECTOR (15 downto 0);
			  g : in STD_LOGIC_VECTOR (15 downto 0);
			  h : in STD_LOGIC_VECTOR (15 downto 0);
			  i : in STD_LOGIC_VECTOR (15 downto 0);
           result : out  STD_LOGIC_VECTOR (15 downto 0)
			  );			 
end datapath;

architecture Behavioral of datapath is
	signal x1_input1, x1_input2, x2_input1, x2_input2, adder_input1, adder_input2 : std_logic_vector (15 downto 0) := (others => '0');
	signal adder_out : std_logic_vector (15 downto 0) := (others => '0');
	signal x1_out, x2_out : std_logic_vector (31 downto 0):= (others => '0');
	signal reg1_input, reg2_input, regX1_input, regX2_input : std_logic_vector (15 downto 0) := (others => '0');
	signal reg1, reg2, regX1, regX2 : std_logic_vector (15 downto 0) := (others => '0');
begin
	
	-- Mux X1.1 --
	with X1_select1 select
		x1_input1 <= a when "00",
						 h when "01",
						 g when "10",
						 i when "11",
						 "0000000000000000" when others;
						
	-- Mux X1.2 --
	with X1_select2 select
		x1_input2 <= e when "00",
						 f when "01",
						 d when "10",
						 reg1 when "11",
						 "0000000000000000" when others;
						 
	-- Mux X2.1 --
	with X2_select1 select
		x2_input1 <= e when "00",
						 f when "01",
						 d when "10",
						 reg2 when "11",
						 "0000000000000000" when others;
						 
	-- Mux X2.2 --
	with X2_select2 select
		x2_input2 <= g when "00",
						 h when "01",
						 c when "10",
						 b when "11",
						 "0000000000000000" when others;
						 
	-- Mux Adder input 1--
	with adder_select select
		adder_input1 <= regX1 when '0',
							 reg1 when '1',
							 "0000000000000000" when others;
	-- adder input 2 --			
	adder_input2 <= regX2;
	
	-- Multiplier X1 --
	x1_out <= x1_input1 * x1_input2;
							
	-- Multiplier X2 --
	x2_out <= x2_input1 * x2_input2;
	
	-- Adder/Subtractor --
	with adder_control select
		adder_out <= adder_input1 + adder_input2 when '0',
						 adder_input1 - adder_input2 when '1',
						 b"0000000000000000" when others;
	
	-- registers inputs
	reg1_input <= adder_out;
	reg2_input <= adder_out;
	regX1_input <= x1_out(15 downto 0);
	regX2_input <= x2_out(15 downto 0);
	
	-- Register R1 --
	process (clk)
	begin
		if clk'event and clk='1' and RA1_enable='1' then
			reg1 <= reg1_input;
		end if;
	end process;
						 
	-- Register R2 --
	process (clk)
	begin
		if clk'event and clk='1' and RA2_enable='1' then
			reg2 <= reg2_input;
		end if;
	end process;
	
	-- Register RX1 --
	process (clk)
	begin
		if clk'event and clk='1' and RX1_enable='1' then
			regX1 <= regX1_input;
		end if;
	end process;
	
	-- Register RX2 --
	process (clk)
	begin
		if clk'event and clk='1' and RX2_enable='1' then
			regX2 <= regX2_input;
		end if;
	end process;
	
--	result <= reg1; -- saida ligada ao registo
	result <= adder_out; -- saida ligada a ALU
	
end Behavioral;

