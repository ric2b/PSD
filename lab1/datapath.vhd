----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    22:15:56 09/30/2014 
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
    Port ( state : in  STD_LOGIC_VECTOR (1 downto 0);
           d_in : in  STD_LOGIC_VECTOR (7 downto 0);
           d_out : out  STD_LOGIC_VECTOR (7 downto 0);
           reset : in  STD_LOGIC;
           clk : in  STD_LOGIC);
end datapath;

architecture Behavioral of datapath is
	signal register1, register2 : std_logic_vector (7 downto 0) := (others => '0');
	signal regEn1, regEn2 : std_logic;
	signal reg2Input : std_logic_vector (7 downto 0);
	signal resultAlu : std_logic_vector (7 downto 0);
begin
	
	regEn1 <= (not state(0)) and state(1);
	regEn2 <= state(0);
	
	-- Register 1 --
	process (clk)
	begin
		if clk'event and clk='1' then
			if reset='1' then
				register1 <= X"00";
			elsif regEn1='1' then
				register1 <= d_in;
			end if;
		end if;
	end process;
	
	-- ALU --
	with d_in select
		resultAlu <= register2 + register1 when b"00000001",
						 register2 - register1 when b"00000010",
						 register2 * register1 when b"00000100",
						 register2 xor register1 when b"00001000",
						 register2 sra (register1 rem 8) when b"00000010",
						 register2 when others ;		-- manter mesmo valor no registo 2 --

	-- Mux --
	reg2Input <= d_in when state(1)='0' else resultAlu;
	
	-- Register 2 --
	process (clk)
	begin
		if clk'event and clk='1' then
			if reset='1' then
				register2 <= X"00";
			elsif regEn2='1' then
				register2 <= d_in;
			end if;
		end if;
	end process;
	
	-- output --
	d_out <= register2;
	
end Behavioral;

