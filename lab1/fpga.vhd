library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

---- Uncomment the following library declaration if instdisp_selecttiating
---- disp_selecty Xilinx primitives in this code.
library UNISIM;
use UNISIM.VComponents.all;

entity fpga is
  port (
    mclk: in std_logic;                     			-- 50MHz clock
    btn: in std_logic_vector(3 downto 0);   	-- btn
    sw: in std_logic_vector(7 downto 0);   	-- switchesitches
    led: out std_logic_vector(7 downto 0);  			-- leds
    an: out std_logic_vector(3 downto 0); -- display selectors
    seg: out std_logic_vector(6 downto 0);  -- display 7-disp_7segmments
    dp: out std_logic                     	-- display point
    );
end fpga;

architecture Behavioral of fpga is
  component circuito
    port(
		mode : in  STD_LOGIC_VECTOR (2 downto 0);
      data_in : in  STD_LOGIC_VECTOR (6 downto 0);
		reg_select : in std_logic;
      output_signal_module : out  STD_LOGIC_VECTOR (12 downto 0);
      clk : in  STD_LOGIC;
      reset : in  STD_LOGIC
      );
  end component;
  
  component disp7
    port(
      disp4 : in std_logic_vector(3 downto 0);
      disp3 : in std_logic_vector(3 downto 0);
      disp2 : in std_logic_vector(3 downto 0);
      disp1 : in std_logic_vector(3 downto 0);
      clk : in std_logic;
      aceso : in std_logic_vector(4 downto 1);          
      en_disp : out std_logic_vector(4 downto 1);
      segm : out std_logic_vector(7 downto 1);
      dp : out std_logic
      );
  end component;
  component clkdiv
    port(
      clk : in std_logic;          
      clk50M  : out std_logic;
      clk10Hz : out std_logic;
      clk_disp : out std_logic
      );
  end component;

  signal clk50M, clk10Hz, clk_disp : std_logic;
  signal data_out : std_logic_vector(12 downto 0);
  signal sign_data_out : std_logic_vector(3 downto 0);
begin
  inst_circuito: circuito port map(
    clk => clk10Hz,
    reset => btn(3),
    mode => btn(2 downto 0),
    data_in => sw (6 downto 0),
	 reg_select => sw(7),
    output_signal_module => data_out
    );
  inst_clkdiv: clkdiv port map(
    clk => mclk,
    clk50m => clk50m,
    clk10hz => clk10hz,
    clk_disp => clk_disp
    );

  inst_disp7: disp7 port map(
    disp4 => sign_data_out,
    disp3 => data_out(11 downto 8),
    disp2 => data_out(7 downto 4),
    disp1 => data_out(3 downto 0),
    clk => clk_disp,
    aceso => "1111",
    en_disp => an,
    segm => seg,
    dp => dp
    );
	 
	sign_data_out <= "0000" when data_out(12)='0' else "1111";
	led <= sw;
end behavioral;

