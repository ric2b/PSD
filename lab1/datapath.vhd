library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_SIGNED.ALL;

-- Este bloco faz as operacoes matematicas/logicas e o load dos registos. É controlado pela unidade de controlo e tem como saídas os dois registos R1 e R2

entity datapath is
    Port ( data_in : in  STD_LOGIC_VECTOR (6 downto 0);
			  reg_select : in STD_LOGIC;
			  oper : in STD_LOGIC_VECTOR (1 downto 0);
			  clk, rst : in STD_LOGIC;
           data_out : out  STD_LOGIC_VECTOR (12 downto 0));
end datapath;

architecture Behavioral of datapath is
	signal reg1 : std_logic_vector (6 downto 0) := (others => '0');
	signal reg2, reg2in, fullReg1, fullDataIn, sra_result, sra_result0, sra_result1: std_logic_vector (13 downto 0) := (others => '0');
	signal en1, en2, muxSel : std_logic := '0';
	signal alu : std_logic_vector (13 downto 0) := (others => '0');
	signal mul, mul_result : std_logic_vector (20 downto 0) := (others => '0');  -- 14 + 7 bits --
	signal mul_overflow : std_logic := '0';
begin
	
	-- Register 1 --
	en1 <= (not oper(1)) and oper(0);
	process (clk)
	begin
		if clk'event and clk='1' then
			if rst='1' then
				reg1 <= (others => '0');
			elsif en1='1' then
				reg1 <= data_in;
			end if;
		end if;
	end process;
	fullReg1 <= "1111111"&reg1 when reg1(6)='1' else "0000000"&reg1;
	
	-- ALU --
	-- SRA --
	with reg1(2 downto 0) select
		sra_result1 <= "1"&reg2(13 downto 1) when "001",
			  			   "11"&reg2(13 downto 2) when "010",
						   "111"&reg2(13 downto 3) when "011",
						   "1111"&reg2(13 downto 4) when "100",
						   "11111"&reg2(13 downto 5) when "101",
						   "111111"&reg2(13 downto 6) when "110",
						   "1111111"&reg2(13 downto 7) when "111",
						   reg2 when others;
							
	with reg1(2 downto 0) select
		sra_result0 <= "0"&reg2(13 downto 1) when "001",
							"00"&reg2(13 downto 2) when "010",
							"000"&reg2(13 downto 3) when "011",
							"0000"&reg2(13 downto 4) when "100",
							"00000"&reg2(13 downto 5) when "101",
							"000000"&reg2(13 downto 6) when "110",
							"0000000"&reg2(13 downto 7) when "111",
							reg2 when others;
	
	sra_result <= sra_result0 when reg2(13)='0' else sra_result1;
	
	-- Multiplication --
	mul_result <= reg2 * reg1;
	mul_overflow <= '1' when ((mul(20 downto 12)/="111111111" and mul(20 downto 12)/="000000000")) else '0';
	mul <= mul_result when mul_overflow='0' else "000000000000000000000";
	
	with data_in(2 downto 0) select
		alu <= reg2 + fullReg1 when "001",
				 reg2 - fullReg1 when "010",
				 mul(13 downto 0) when "011",
				 reg2 xor fullReg1 when "100",
				 sra_result when "101",
				 reg2 when others;	 
	
	-- Mux --
	muxSel <= oper(0);
	fullDataIn <= "1111111"&data_in when data_in(6)='1' else "0000000"&data_in;
	reg2in <= alu when muxSel='1' else fullDataIn;
	
	-- Register 2 --
	en2 <= oper(1);
	process (clk)
	begin
		if clk'event and clk='1' then
			if rst='1' then
				reg2 <= (others => '0');
			elsif en2='1' then
				reg2 <= reg2in;
			end if;
		end if;
	end process;
	
	data_out <= reg2(12 downto 0) when reg_select='0' else fullReg1(12 downto 0);
	
end Behavioral;