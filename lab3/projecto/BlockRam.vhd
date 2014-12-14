library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

Library UNISIM;
use UNISIM.vcomponents.all;

entity BlockRam is
  Port ( 
        clkA : in std_logic;
        adrA : in std_logic_vector(10 downto 0);
        busDiA : in std_logic_vector(7 downto 0);
        busDoA : out std_logic_vector(7 downto 0);
        ctlEnA : in std_logic;
        ctlWeA : in std_logic;

        clkB : in std_logic;
        adrB : in std_logic_vector(8 downto 0);
        busDiB : in std_logic_vector(31 downto 0);
        busDoB : out std_logic_vector(31 downto 0);
        ctlEnB : in std_logic;
        ctlWeB : in std_logic);
end BlockRam;

architecture Structural of BlockRam is

  Constant DntCare: std_logic_vector(3 downto 0) := "0000";
    -- DIPA and DIPB are defined as std_logic_vector(0 downto 0)

begin

   -- RAMB16_S9_S36: 2k/512 x 8/32 + 1/4 Parity bits Parity bits Dual-Port RAM
   --                Spartan-3E
   -- Xilinx HDL Language Template, version 13.4

   RAMB16_S9_S36_inst : RAMB16_S9_S36
   generic map (
      INIT_A => X"000", --  Value of output RAM registers on Port A at startup
      INIT_B => X"000000000", --  Value of output RAM registers on Port B at startup
      SRVAL_A => X"000", --  Port A ouput value upon SSR assertion
      SRVAL_B => X"000000000", --  Port B ouput value upon SSR assertion
      WRITE_MODE_A => "WRITE_FIRST", --  WRITE_FIRST, READ_FIRST or NO_CHANGE
      WRITE_MODE_B => "WRITE_FIRST", --  WRITE_FIRST, READ_FIRST or NO_CHANGE
      SIM_COLLISION_CHECK => "ALL", -- "NONE", "WARNING", "GENERATE_X_ONLY", "ALL" 
      -- The following INIT_xx declarations specify the initial contents of the RAM
      -- Port A Address 0 to 511, Port B Address 0 to 127

  --  INIT_XX => X"-------HEX------- Line 2 (XX1) | Line 1 (XX0) -------HEX--------",
  --  INIT_XX => X"3333333322222222111111110000000033333333222222221111111100000000",
  --  INIT_XX => X"0-----310-----310-----310-----310-----310-----310-----310-----31",
      INIT_00 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_01 => X"000000000000000000000000000000E0000000000000000000000000000000FC",
      INIT_02 => X"00000000000000000000000000000030000000000000000000000000000000F8",
      INIT_03 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_04 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_05 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_06 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_07 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_08 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_09 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_0A => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_0B => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_0C => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_0D => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_0E => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_0F => X"0000000000000000000000000000000000000000000000000000000000000000",
      -- Port A Address 512 to 1023, Port B Address 128 to 255
      INIT_10 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_11 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_12 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_13 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_14 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_15 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_16 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_17 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_18 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_19 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_1A => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_1B => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_1C => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_1D => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_1E => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_1F => X"0000000000000000000000000000000000000000000000000000000000000000",
      -- Port A Address 1024 to 1535, Port B Address 255 to 383
      INIT_20 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_21 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_22 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_23 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_24 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_25 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_26 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_27 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_28 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_29 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_2A => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_2B => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_2C => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_2D => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_2E => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_2F => X"0000000000000000000000000000000000000000000000000000000000000000",
      -- Port A Address 1536 to 2047, Port B Address 384 to 511
      INIT_30 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_31 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_32 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_33 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_34 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_35 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_36 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_37 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_38 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_39 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_3A => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_3B => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_3C => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_3D => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_3E => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_3F => X"0000000000000000000000000000000000000000000000000000000000000000",
  --  INIT_XX => X"0-----310-----310-----310-----310-----310-----310-----310-----31",
  --  INIT_XX => X"3333333322222222111111110000000033333333222222221111111100000000",
  --  INIT_XX => X"-------HEX------- Line 2 (XX1) | Line 1 (XX0) -------HEX--------",



      -- The next set of INITP_xx are for the parity bits
      -- Port A Address 0 to 511, Port B Address 0 to 127
      INITP_00 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INITP_01 => X"0000000000000000000000000000000000000000000000000000000000000000",
      -- Port A Address 512 to 1023, Port B Address 128 to 255
      INITP_02 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INITP_03 => X"0000000000000000000000000000000000000000000000000000000000000000",
      -- Port A Address 1024 to 1535, Port B Address 256 to 383
      INITP_04 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INITP_05 => X"0000000000000000000000000000000000000000000000000000000000000000",
      -- Port A Address 1536 to 2047, Port B Address 384 to 511
      INITP_06 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INITP_07 => X"0000000000000000000000000000000000000000000000000000000000000000")
   port map (
	
		DOA => busDoA,     				-- Port A 8-bit Data Output
		DOB => busDoB,     				-- Port B 32-bit Data Output    
		DOPA => open,  			   	-- Port A 1-bit Parity Output
		DOPB => open, 			    		-- Port B 4-bit Parity Output
		ADDRA => adrA,     				-- Port A 11-bit Address Input
		ADDRB => adrB,     				-- Port B 9-bit Address Input
		CLKA => clkA,      				-- Port A Clock
		CLKB => clkB,      				-- Port B Clock
		DIA => busDiA,     				-- Port A 8-bit Data Input
		DIB => busDiB,   			 		-- Port B 32-bit Data Input
		DIPA => DntCare(0 downto 0),  -- Port A 1-bit parity Input, never used
		DIPB => DntCare,   				-- Port-B 4-bit parity Input, never used
		ENA => ctlEnA,     				-- Port A RAM Enable Input
		ENB => ctlEnB,     				-- Port B RAM Enable Input
		SSRA => '0',       				-- Port A Synchronous Set/Reset Input
		SSRB => '0',       				-- Port B Synchronous Set/Reset Input
		WEA => ctlWeA,     				-- Port A Write Enable Input
		WEB => ctlWeB      				-- Port B Write Enable Input
   );	

   -- End of RAMB16_S9_S36_inst instantiation

end Structural;