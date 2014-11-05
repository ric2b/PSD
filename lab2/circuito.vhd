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
	 result : out STD_LOGIC_VECTOR (15 downto 0)
	 );
end circuito;

architecture Behavioral of circuito is
  component control
    port(
		  start : in  STD_LOGIC;
		  clk, rst : in STD_LOGIC;
		  RS1_enable : out  STD_LOGIC;
		  X1_select1 : out  STD_LOGIC_VECTOR (1 downto 0);
		  X1_select2 : out  STD_LOGIC_VECTOR (1 downto 0);
		  X2_select1 : out  STD_LOGIC_VECTOR (1 downto 0);
		  X2_select2 : out  STD_LOGIC_VECTOR (1 downto 0);
		  adder_select : out  STD_LOGIC;
		  adder_control : out STD_LOGIC
      );
  end component;
  component datapath
    port(
		  clk : in STD_LOGIC;
		  RS1_enable : in  STD_LOGIC;
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

  signal RS1_enable, adder_select, adder_control : std_logic;
  signal X1_select1, X1_select2, X2_select1, X2_select2 : std_logic_vector(1 downto 0);

begin
  inst_control: control port map(
    clk => clk,
    rst => rst,
    start => start,
    RS1_enable => RS1_enable,
    X1_select1 => X1_select1,
	 X1_select2 => X1_select2,
	 X2_select1 => X2_select1,
	 X2_select2 => X2_select2,
	 adder_select => adder_select,
	 adder_control => adder_control
    );
  
  inst_datapath: datapath port map(
    clk => clk,
    RS1_enable => RS1_enable,
    X1_select1 => X1_select1,
	 X1_select2 => X1_select2,
	 X2_select1 => X2_select1,
	 X2_select2 => X2_select2,
	 adder_select => adder_select,
	 adder_control => adder_control,
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

end Behavioral;

