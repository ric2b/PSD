----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    22:08:33 10/06/2014 
-- Design Name: 
-- Module Name:    datapath - Behavioral 
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_SIGNED.ALL;

entity datapath is
    Port ( data_in : in  STD_LOGIC_VECTOR (6 downto 0);
			  reg_select : in std_logic;
			  oper : in STD_LOGIC_VECTOR (1 downto 0);
			  clk, rst : in STD_LOGIC;
           data_out : out  STD_LOGIC_VECTOR (12 downto 0));
end datapath;

architecture Behavioral of datapath is
	signal reg1 : std_logic_vector (6 downto 0) := (others => '0');
	signal reg2, reg2in, fullReg1, fullDataIn: std_logic_vector (12 downto 0) := (others => '0');
	signal en1, en2, muxSel : std_logic := '0';
	signal alu : std_logic_vector (12 downto 0) := (others => '0');
	signal sra_result : std_logic_vector (12 downto 0) := (others => '0');
	signal remainder : std_logic_vector (3 downto 0);
	-- signal mul : std_logic_vector (19 downto 0) := (others => '0');  -- 13 + 7 bits --
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
	
	shift_ra: process
	begin
		for i in 0 to conv_integer(remainder) loop
			sra_result <= reg2(12)&reg2(12 downto 1);
		end loop;
	end process;
	
	-- ALU --
	remainder <= '0'&reg1(2 downto 0);
	fullReg1 <= "111111"&reg1 when reg1(3)='1' else "000000"&reg1;
	-- mul <= reg2 * reg1 when data_in(2 downto 0)="011";
	with data_in(2 downto 0) select
		alu <= reg2 + fullReg1 when "001",
				 reg2 - fullReg1 when "010",
				 -- mul(12 downto 0) when "011", -- esta solucao nao permite converter 
															--	os valores correctamente quando temos overflow --
				 reg2 xor fullReg1 when "100",
				 sra_result when "101",
				 reg2 when others;	 
	
	-- Mux --
	muxSel <= oper(0);
	fullDataIn <= "111111"&data_in when data_in(3)='1' else "000000"&data_in;
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
	
	data_out <= reg2 when reg_select='0' else fullReg1;
	
end Behavioral;