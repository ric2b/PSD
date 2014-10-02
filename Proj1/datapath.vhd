----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:55:26 09/30/2014 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity datapath is
    Port ( ENT : in  STD_LOGIC_VECTOR (7 downto 0);
           d_out : out  STD_LOGIC_VECTOR (7 downto 0);
           reset : in  STD_LOGIC;
           clk : in  STD_LOGIC;
           oper : in  STD_LOGIC_VECTOR (7 downto 0));
end datapath;

architecture Behavioral of datapath is
	signal reg1, reg2 : std_logic_vector (7 downto 0) := (others => '0');
begin
	
	-- Registo 1 --
	process (clk)
	begin
		if clk'event and clk='1' then
			if reset='1' then
				reg1 <= X"00";
			elsif load='1' then
				reg1 <= ENT;
			end if;
		end if;
	end process;
	
	-- Registo 2 --
	process (clk)
	begin
		if clk'event and clk='1' then
			if reset='1' then
				reg2 <= X"00";
			elsif load='1' then
				reg1 <= ENT;
			end if;
		end if;
	end process;
	
end Behavioral;

