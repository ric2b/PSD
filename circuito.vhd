----------------------------------------------------------------------------------

-- Module Name:    circuito - Behavioral 

----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity circuito is
    Port ( mode : in  STD_LOGIC_VECTOR (2 downto 0);
           data_in : in  STD_LOGIC_VECTOR (6 downto 0);
		   reg_select : in std_logic;
           data_out : out  STD_LOGIC_VECTOR (12 downto 0);
           clk : in  STD_LOGIC;
           reset : in  STD_LOGIC);
end circuito;

architecture Behavioral of circuito is

	component control
		port (
				 clk : in std_logic;
				 mode : in std_logic_vector (2 downto 0);
				 state : out std_logic_vector (1 downto 0)
		);
	end component;

	component datapath
		port ( data_in : in  STD_LOGIC_VECTOR (6 downto 0);
				reg_select : in std_logic;
				  oper : in STD_LOGIC_VECTOR (1 downto 0);
				  clk, rst : in STD_LOGIC;
				  data_out : out  STD_LOGIC_VECTOR (12 downto 0)
		);
	end component;
	 
	signal state: std_logic_vector(1 downto 0);
	signal input_CP2: std_logic_vector(6 downto 0);
	signal output_signal_module: std_logic_vector(6 downto 0);
	 
begin

	input_CP2 <= not('1' & data_in(5 downto 0))+1 when data_in(6) = '1' else data_in;
	output_signal_module <= '1' & not(data_out(11 downto 0))+1 when data_out(12) = '1' else data_out;
	
	inst_control: control port map(
		clk => clk,
		mode => mode,
		state => state		
	);

	inst_datapath: datapath port map(
		clk => clk,
		rst => reset,
		data_in => input_CP2,
		reg_select => reg_select,
		data_out => data_out,
		oper => state
	);
	
end Behavioral;

