----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:09:59 10/28/2014 
-- Design Name: 
-- Module Name:    Control - Behavioral 
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

entity Control is
    Port ( start : in  STD_LOGIC;
			  clk, rst : in STD_LOGIC;
           RS1_enable : out  STD_LOGIC;
           X1_select1 : out  STD_LOGIC_VECTOR (1 downto 0);
           X1_select2 : out  STD_LOGIC_VECTOR (1 downto 0);
           X2_select1 : out  STD_LOGIC_VECTOR (1 downto 0);
           X2_select2 : out  STD_LOGIC_VECTOR (1 downto 0);
           adder_select : out  STD_LOGIC;
			  adder_control : out STD_LOGIC;
			  done : out STD_LOGIC
			  );
end Control;

architecture Behavioral of Control is
  type fsm_states is ( s_initial, cycle_1, cycle_2, cycle_3, cycle_4, cycle_5, cycle_6, s_end );
  signal currstate, nextstate: fsm_states;

begin
  state_reg: process (clk, rst)
  begin 
    if rst = '1' then
      currstate <= s_initial ;
    elsif clk'event and clk = '1' then
      currstate <= nextstate ;
    end if ;
  end process;

  state_comb: process (currstate, start)
  begin  --  process
    nextstate <= currstate ;  
    -- by default, does not change the state.
    
	 RS1_enable <= '0';
    X1_select1 <= "XX";
	 X1_select2 <= "XX";
	 X2_select1 <= "XX";
	 X2_select2 <= "XX";
	 adder_select <= 'X';
	 adder_control <= 'X';
	 done <= '0';
	 
    case currstate is
      when s_initial =>
			if start = '1' then
				done <= '0';
				nextstate <= cycle_1;
			end if;
			RS1_enable <= '0';
		        
      when cycle_1 =>
			nextstate <= cycle_2;
			X1_select1 <= "11";
			X1_select2 <= "00";
			X2_select1 <= "01";
			X2_select2 <= "01";
			done <= '0';
 
		when cycle_2 =>
			nextstate <= cycle_3;
			RS1_enable <= '1';
			X1_select1 <= "11";
			X1_select2 <= "10";
			X2_select1 <= "01";
			X2_select2 <= "00";
			adder_select <= '0';
			adder_control <= '1';
			done <= '0';
		
      when cycle_3 =>
			nextstate <= cycle_4;
			RS1_enable <= '0';
			X1_select1 <= "01";
			X1_select2 <= "10";	
			X2_select1 <= "00";
			X2_select2 <= "00";
			adder_select <= '0';
			adder_control <= '1';
			done <= '0';
        
      when cycle_4 =>
			nextstate <= cycle_5;
			RS1_enable <= '1';
			X1_select1 <= "00";
			X1_select2 <= "11";
			X2_select1 <= "11";
			X2_select2 <= "11";
			adder_select <= '0';
			adder_control <= '1';
			done <= '0';

		when cycle_5 =>
			nextstate <= cycle_6;
			RS1_enable <= '1';
			X2_select1 <= "11";
			X2_select2 <= "10";
			adder_select <= '0';
			adder_control <= '1';
			done <= '0';
		  
		when cycle_6 =>
			nextstate <= s_end;
			RS1_enable <= '1';
			adder_select <= '1';
			adder_control <= '0';
			done <= '0';
			
		when s_end =>
			done <= '1';
			RS1_enable <= '0';
			
    end case;
  end process;

end Behavioral;