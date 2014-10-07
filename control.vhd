library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity control is
  port (
    clk : in std_logic;
    mode : in std_logic_vector (2 downto 0);
    state : out std_logic_vector (1 downto 0));
end control;

architecture Behavioral of control is

begin
  state_reg: process (clk)
  begin     
    if clk'event and clk = '1' then
      case mode is
			when "100" =>
				state <= "01";
			when "010" =>
				state <= "10";
			when "001" =>
				state <= "11";
			when others =>
				state <= "00";
		end case;

    end if ;
  end process;

end Behavioral;
