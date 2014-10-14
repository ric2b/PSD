----------------------------------------------------------------------------------

-- Module Name:    circuito - Behavioral 

----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_SIGNED.ALL;

entity circuito is
    Port ( instr : in  STD_LOGIC_VECTOR (2 downto 0);
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
				 instr : in std_logic_vector (2 downto 0);
				 state_signal : out std_logic_vector (1 downto 0)
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
	 
begin
		
	inst_control: control port map(
		clk => clk,
		instr => instr,
		state_signal => state		
	);

	inst_datapath: datapath port map(
		clk => clk,
		rst => reset,
		data_in => data_in,
		reg_select => reg_select,
		data_out => data_out,
		oper => state
	);
	
end Behavioral;

