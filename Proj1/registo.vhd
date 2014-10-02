----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:12:04 09/30/2014 
-- Design Name: 
-- Module Name:    registo - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity registo is
    Port ( reg_in : in  STD_LOGIC_VECTOR (7 downto 0);
           reg_out : out  STD_LOGIC_VECTOR (7 downto 0);
           load : in  STD_LOGIC;
			  reset : in STD_LOGIC);
end registo;

architecture Behavioral of registo is
	signal value : STD_LOGIC_VECTOR (7 downto 0) := (others => '0');
begin
	
	process (clk)
	begin
		if clk'event and clk='1' then
			if reset='1' then
				value <= X"00";
			elsif load='1' then
				value <= reg_in;
			end if;
		end if;
	end process;
	
	reg_out <= value;
	
end Behavioral;

