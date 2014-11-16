library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity circuito is
  port (
    clk, rst, start: in std_logic;
	 a : in STD_LOGIC_VECTOR (15 downto 0);
	 b : in STD_LOGIC_VECTOR (15 downto 0);
	 c : in STD_LOGIC_VECTOR (15 downto 0);
	 d : in STD_LOGIC_VECTOR (15 downto 0);
	 e : in STD_LOGIC_VECTOR (15 downto 0);
	 f : in STD_LOGIC_VECTOR (15 downto 0);
	 g : in STD_LOGIC_VECTOR (15 downto 0);
	 h : in STD_LOGIC_VECTOR (15 downto 0);
	 i : in STD_LOGIC_VECTOR (15 downto 0);
	 result : out STD_LOGIC_VECTOR (15 downto 0);
	 done : out STD_LOGIC
	 );
end circuito;

architecture Behavioral of circuito is
  component control
    port(
		  start : in  STD_LOGIC;
		  clk, rst : in STD_LOGIC;
		  RA1_enable : out STD_LOGIC;
		  RA2_enable : out STD_LOGIC;
		  RX1_enable : out STD_LOGIC;
		  RX2_enable : out STD_LOGIC;
		  X1_select1 : out STD_LOGIC_VECTOR (1 downto 0);
		  X1_select2 : out STD_LOGIC_VECTOR (1 downto 0);
		  X2_select1 : out STD_LOGIC_VECTOR (1 downto 0);
		  X2_select2 : out STD_LOGIC_VECTOR (1 downto 0);
		  adder_select : out STD_LOGIC;
		  adder_control : out STD_LOGIC;
		  done : out STD_LOGIC
      );
  end component;
  component datapath
    port(
		  clk : in STD_LOGIC;
		  RA1_enable : in STD_LOGIC;
		  RA2_enable : in STD_LOGIC;
		  RX1_enable : in STD_LOGIC;
		  RX2_enable : in STD_LOGIC;
		  X1_select1 : in  STD_LOGIC_VECTOR (1 downto 0);
		  X1_select2 : in  STD_LOGIC_VECTOR (1 downto 0);
		  X2_select1 : in  STD_LOGIC_VECTOR (1 downto 0);
		  X2_select2 : in  STD_LOGIC_VECTOR (1 downto 0);
		  adder_select : in  STD_LOGIC;
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
  end component;

  signal RA1_enable, RA2_enable, RX1_enable, RX2_enable, adder_select, adder_control : std_logic;
  signal X1_select1, X1_select2, X2_select1, X2_select2 : std_logic_vector(1 downto 0);
  signal control_reg : std_logic_vector (13 downto 0);
  signal control_done, aux_done : std_logic;

begin
  inst_control: control port map(
    clk => clk,
    rst => rst,
    start => start,
    RA1_enable => RA1_enable,
	 RA2_enable => RA2_enable,
	 RX1_enable => RX1_enable,
	 RX2_enable => RX2_enable,
    X1_select1 => X1_select1,
	 X1_select2 => X1_select2,
	 X2_select1 => X2_select1,
	 X2_select2 => X2_select2,
	 adder_select => adder_select,
	 adder_control => adder_control,
	 done => aux_done
    );
	 
	process (clk)
	begin
		if clk'event and clk='1' then
			control_reg <= RA1_enable & RA2_enable & RX1_enable & RX2_enable
								& adder_select & adder_control 
								& X1_select1 & X1_select2 & X2_select1 & X2_select2;
			control_done <= aux_done;
		end if;
	end process;
	 
  inst_datapath: datapath port map(
    clk => clk,
    RA1_enable => control_reg(13),
	 RA2_enable => control_reg(12),
	 RX1_enable => control_reg(11),
	 RX2_enable => control_reg(10),
	 adder_select => control_reg(9),
	 adder_control => control_reg(8),
    X1_select1 => control_reg(7 downto 6),
	 X1_select2 => control_reg(5 downto 4),
	 X2_select1 => control_reg(3 downto 2),
	 X2_select2 => control_reg(1 downto 0),
	 a => a,
	 b => b,
	 c => c,
	 d => d,
	 e => e,
	 f => f,
	 g => g,
	 h => h,
	 i => i,
	 result => result
    );
	 
	done <= control_done;
	
end Behavioral;

