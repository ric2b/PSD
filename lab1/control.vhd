library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Este bloco implementa a máquina de estados e controla a datapath. É controlado pelo utilizador usando os 3 botões mais à direita da placa

entity control is
  port (
    clk : in std_logic;
    instr : in std_logic_vector (2 downto 0);
    state_signal : out std_logic_vector (1 downto 0));
end control;

architecture Behavioral of control is
  type fsm_states is ( initial, wait_for_release, loadR1, loadR2, operation);
  signal currstate, nextstate: fsm_states;

begin
  state_reg: process (clk)
  begin 
    if clk'event and clk = '1' then
      currstate <= nextstate ;
    end if ;
  end process;

  state_comb: process (currstate, instr)
  begin  --  process
    nextstate <= currstate ;  
    -- by default, does not change the state.
    
    case currstate is
      when initial =>
        if instr="001" then
          nextstate <= operation ;
        elsif instr="010" then
          nextstate <= loadR2 ;
        elsif instr="100" then
          nextstate <= loadR1;
        end if;
        state_signal<="00";
        
      when loadR1 =>
        nextstate <= wait_for_release;
        state_signal<="01";
        
      when loadR2 =>
        nextstate <= wait_for_release;
        state_signal<="10";
        
      when operation =>
        nextstate <= wait_for_release;
        state_signal<="11";
        
      when wait_for_release =>
        if instr="000" then
          nextstate <= initial ;
        end if;
        state_signal<="00";

    end case;
  end process;

end Behavioral;
