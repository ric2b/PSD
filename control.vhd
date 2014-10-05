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
    clk, rst : in std_logic;
    mode : in std_logic_vector (2 downto 0);
    enable : out std_logic;
    state : out std_logic_vector (1 downto 0));
end control;

architecture Behavioral of control is
  type fsm_states is (ini, load1, load2, oper);
  signal currstate, nextstate: fsm_states;

begin
  state_reg: process (clk, rst)
  begin 
    if rst = '1' then
      currstate <= ini ;
    elsif clk'event and clk = '1' then
      currstate <= nextstate ;
    end if ;
  end process;

  state_comb: process (currstate, instr)
  begin  --  process
    nextstate <= currstate ;  
    -- by default, does not change the state.
    
    case currstate is
      when ini =>
        if instr="001" then
          nextstate <= oper;
        elsif instr="010" then
          nextstate <= load2 ;
        elsif instr="100" then
          nextstate <= load1;
        end if;
        state<="00";
        enable<='0';
        
      when load1 =>
        nextstate <= ini;
        oper<="01";
        enable<='1';
        
      when load2 =>
        nextstate <= ini;
        oper<="10";
        enable<='1';
        
      when oper =>
        nextstate <= ini;
        oper<="11";
        enable<='1';

    end case;
  end process;

end Behavioral;

