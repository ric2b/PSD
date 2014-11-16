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
			  RA1_enable : out STD_LOGIC;
			  RA2_enable : out STD_LOGIC;
			  RX1_enable : out STD_LOGIC;
			  RX2_enable : out STD_LOGIC;
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
    
	 RA1_enable <= '0';
	 RA2_enable <= '0';
	 RX1_enable <= '0';
	 RX2_enable <= '0';
	 X1_select1 <= "00"; 
	 X1_select2 <= "11"; 
	 X2_select1 <= "11"; 
	 X2_select2 <= "10"; 
	 adder_select <= '1'; 
	 adder_control <= '0';
	 done <= '0';
	 
    case currstate is
      when s_initial =>
			if start = '1' then
				done <= '0';
				nextstate <= cycle_1;
			end if;
		        
      when cycle_1 =>
			nextstate <= cycle_2;
			RA1_enable <= '0';
			RA2_enable <= '0';
			RX1_enable <= '1';
			RX2_enable <= '1';
			X1_select1 <= "11";
			X1_select2 <= "00";
			X2_select1 <= "01";
			X2_select2 <= "01";
 
		when cycle_2 =>
			nextstate <= cycle_3;
			RA1_enable <= '1';
			RA2_enable <= '0';
			RX1_enable <= '1';
			RX2_enable <= '1';
			X1_select1 <= "11";
			X1_select2 <= "10";
			X2_select1 <= "01";
			X2_select2 <= "00";
			adder_select <= '0';
			adder_control <= '1';
		
      when cycle_3 =>
			nextstate <= cycle_4;
			RA1_enable <= '0';
			RA2_enable <= '1';
			RX1_enable <= '1';
			RX2_enable <= '1';
			X1_select1 <= "01";
			X1_select2 <= "10";	
			X2_select1 <= "00";
			X2_select2 <= "00";
			adder_select <= '0';
			adder_control <= '1';
        
      when cycle_4 =>
			nextstate <= cycle_5;
			RA1_enable <= '0';
			RA2_enable <= '1';
			RX1_enable <= '1';
			RX2_enable <= '1';
			X1_select1 <= "00";
			X1_select2 <= "11";
			X2_select1 <= "11";
			X2_select2 <= "11";
			adder_select <= '0';
			adder_control <= '1';

		when cycle_5 =>
			nextstate <= cycle_6;
			RA1_enable <= '1';
			RA2_enable <= '0';
			RX1_enable <= '0';
			RX2_enable <= '1';
			X2_select1 <= "11";
			X2_select2 <= "10";
			adder_select <= '0';
			adder_control <= '1';
		  
		when cycle_6 =>
			nextstate <= s_end;
			RA1_enable <= '0';
			RA2_enable <= '1';
			RX1_enable <= '0';
			RX2_enable <= '0';
			adder_select <= '1';
			adder_control <= '0';
			done <= '1';
			
		when s_end =>
			nextstate <= s_initial;
			done <= '1';
			
    end case;
  end process;

end Behavioral;