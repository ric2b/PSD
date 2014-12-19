--
-- PrSD 2009/10 - Apoio ao Projecto 3
-- Adapta Projecto BramCfg disponibilizado pela Digilent.
-- Faz upload de ficheiro via usb para porto A da BlockRamIN.
-- Faz download de ficheiro via usb do porto A da BlockRamOUT.
-- Permite visualizar conteudo das BlockRamIN e BlockRamOUT quando execucao parada.
-- Execucao inicia-se quando se activa o botao 1.
-- A datapath troca simplesmente os 4-bits menos siginificativos com os 4-bits mais
-- siginificativos do elemento da BlockRamIN e escreve o novo elemento na BlockRamOUT.
--
--------------------------------------------------------------------------------------
--
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:54:41 03/07/2008 
-- Design Name: 
-- Module Name:    BramCfg - Structural 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- This is the Digilent BramCfg reference project. 
-- It is an example for transferring data between a Block RAM and a PC.
-- The BramCfg project instantiates a Block RAM and interfaces it to 
-- an Epp port (the Digilent OnBoard USB circuitry and firmware)
-- It is used in conjunction with a program running on a PC (a Digilent
-- utility as TransPort or a user generated application) which in turn
-- uses the APIs provided by Digilent Adept Suite.
--
-- The BramCfg project connects to Block RAM port A and leaves all 
-- port B signals "open". Port B can be used for extending the project.
--
-- For more details about using the project, see the 
-- Digilent BramCfg Reference Project Manual
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity usb2bram is
  port ( 
-- Epp-like bus signals
    EppAstb: in std_logic;                       -- Address strobe
    EppDstb: in std_logic;                       -- Data strobe
    EppWr  : in std_logic;                       -- Port write signal
    EppDB  : inout std_logic_vector(7 downto 0); -- port data bus
    EppWait: out std_logic;                      -- Port wait signal

    mclk: in std_logic;
    btn: in std_logic_vector(3 downto 0);
    sw: in std_logic_vector(7 downto 0);
    led: out std_logic_vector(7 downto 0);
    an: out std_logic_vector(3 downto 0);
    seg: out std_logic_vector(6 downto 0);
    dp: out std_logic
  );


end usb2bram;

architecture Structural of usb2bram is


-- signals to interconnect the components
  signal BramDataOut   : std_logic_vector (7 downto 0);
  signal BramAdrIn     : std_logic_vector (10 downto 0);
  signal BramDataIn    : std_logic_vector (7 downto 0);
  signal BramWeIn      : std_logic;
  signal BramEnIn      : std_logic;
  signal BramClkIn     : std_logic;
  signal EppBusOut     : std_logic_vector (7 downto 0);
  signal EppBusIn      : std_logic_vector (7 downto 0);
  signal EppAdrOut     : std_logic_vector (4 downto 0);
  signal EppStbDataOut : std_logic;
  signal EppWrOut      : std_logic;
  signal selBramCtrl   : std_logic;

  signal general_address_S	: std_logic_vector(9 downto 0);
  signal general_address_R	: std_logic_vector(9 downto 0);
  signal done					:std_logic;
  signal we				 		: std_logic;

  signal adrB2, adrB2cnt  : std_logic_vector (8 downto 0);
  signal dataB1, dataB2, dataB2in, dataB1_aux, dataB2in_aux : std_logic_vector (31 downto 0);

  signal clk_disp7, clk_fast, clk_50 : std_logic;
  signal is_executing, rst_all, rst_dp : std_logic;
  
-- component declarations
  component EppCtrlAsync
    port(
			  EppAstb   : in    std_logic; 
           EppDstb   : in    std_logic; 
           EppWr     : in    std_logic; 
           busIn     : in    std_logic_vector (7 downto 0); 
           sel0      : inout std_logic; 
           sel2      : inout std_logic; 
           sel4      : inout std_logic; 
           sel6      : inout std_logic; 
           sel8      : inout std_logic; 
           selA      : inout std_logic; 
           selC      : inout std_logic; 
           selE      : inout std_logic; 
           EppDB     : inout std_logic_vector (7 downto 0); 
           EppWait   : out   std_logic; 
           stbData   : out   std_logic; 
           ctlrWr    : out   std_logic; 
           outEppAdr : out   std_logic_vector (4 downto 0); 
           busOut    : out   std_logic_vector (7 downto 0)
	 );
  end component;
  
  component BramComCtrl
	port (
		stbData     : in    std_logic; 
		ctrlWr      : in    std_logic; 
		selBram     : in    std_logic; 
		busEppIn    : in    std_logic_vector (7 downto 0); 
		busEppAdrIn : in    std_logic_vector (4 downto 0); 
		busBramIn   : in    std_logic_vector (7 downto 0); 
		ctlWeBram   : out   std_logic; 
		clkBram     : out   std_logic; 
		busEppOut   : out   std_logic_vector (7 downto 0); 
		busBramAdr  : out   std_logic_vector (10 downto 0); 
		busBramOut  : out   std_logic_vector (7 downto 0); 
		ctlEnBram   : out   std_logic
	);
  end component;
  
  component BlockRam
    port ( 
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
  end component; 
  
  component BlockRam_36 is
    Port ( 
	clkA : in std_logic;
        adrA : in std_logic_vector(8 downto 0);
        busDiA : in std_logic_vector(31 downto 0);
        busDoA : out std_logic_vector(31 downto 0);
        ctlEnA : in std_logic;
        ctlWeA : in std_logic);
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

component datapath_1 is
		Port (
			CLK				: in std_logic;
			rst				: in std_logic;
			opcode		 	: in std_logic_vector (2 downto 0);
			datain			: in std_logic_vector (31 downto 0);
			counterin		: in std_logic_vector (9 downto 0);
			dataout			: out std_logic_vector (31 downto 0);
			adrout			: out std_logic_vector (8 downto 0);
			done				: out std_logic
			);
	end component;


  component controlo
    Port ( 
		clk				: in	std_logic;
		rst				: in  std_logic;
		done				: in  std_logic;
		buttons			: in	std_logic_vector(3 downto 0);	-- button(0) -> reset;	button(3) -> start action;
		general_address: out std_logic_vector(9 downto 0);
		rst_dp			: out std_logic;
		executing 		: out std_logic
	);
  end component;
  
  COMPONENT clk_gen
	PORT(
		CLKIN_IN : IN std_logic;
		RST_IN : IN std_logic;          
		CLKDV_OUT : OUT std_logic;
		CLKFX_OUT : OUT std_logic;
		CLKIN_IBUFG_OUT : OUT std_logic;
		CLK0_OUT : OUT std_logic;
		CLK2X_OUT : OUT std_logic;
		LOCKED_OUT : OUT std_logic
		);
	END COMPONENT;
  
begin

  
	led <= sw;
	adrB2 <= '0' & sw when is_executing = '0' else adrB2cnt;
	dataB1_aux 	<= dataB1(7 downto 0) & dataB1(15 downto 8) & dataB1(23 downto 16) & dataB1(31 downto 24);
	dataB2in_aux	<= dataB2in(7 downto 0) & dataB2in(15 downto 8) & dataB2in(23 downto 16) & dataB2in(31 downto 24);
	we <= is_executing xor done;
	rst_all	<= btn(0) OR rst_dp or not is_executing;


-- component instantiations
Inst_clk_gen: clk_gen PORT MAP(
		CLKIN_IN => mclk,
		RST_IN => btn(0),
		CLKDV_OUT => open,
		CLKFX_OUT => clk_fast,
		CLKIN_IBUFG_OUT => open,
		CLK0_OUT => clk_50,
		CLK2X_OUT => open,
		LOCKED_OUT => open
	);



  EppCtrlAsyncInst : EppCtrlAsync port map (
    busIn     => EppBusIn,
    EppAstb   => EppAstb,
    EppDstb   => EppDstb,
    EppWr     => EppWr,
    busOut    => EppBusOut,
    ctlrWr    => EppWrOut,
    EppWait   => EppWait,
    outEppAdr => EppAdrOut,
    stbData   => EppStbDataOut,
    EppDB     => EppDB,
    selA      => open,
    selC      => open,
    selE      => open,
    sel0      => selBramCtrl,
    sel2      => open,
    sel4      => open,
    sel6      => open,
    sel8      => open
  );
  
  BramComCtrlInst : BramComCtrl port map (
    busBramIn   => BramDataOut,
    busEppAdrIn => EppAdrOut,
    busEppIn    => EppBusOut,
    ctrlWr      => EppWrOut,
    selBram     => selBramCtrl,
    stbData     => EppStbDataOut,
    busBramAdr  => BramAdrIn,
    busBramOut  => BramDataIn,
    busEppOut   => EppBusIn,
    clkBram     => BramClkIn,
    ctlEnBram   => BramEnIn,
    ctlWeBram   => BramWeIn);
	 
  BlockRamIN : BlockRam port map (
    adrA   => BramAdrIn,
    adrB   => general_address_R(8 downto 0),
    busDiA => BramDataIn,
    busDiB => x"00000000",
    clkA   => BramClkIn,
    clkB   => clk_fast,
    ctlEnA => BramEnIn,
    ctlEnB => '1',
    ctlWeA => BramWeIn,
    ctlWeB => '0',
    busDoA => open,
    busDoB => dataB1
  );
	 
	 
  BlockRamOUT : BlockRam port map (
    adrA   => BramAdrIn,
    adrB   => adrB2,
    busDiA => "00000000",
    busDiB => dataB2in_aux,
    clkA   => BramClkIn,
    clkB   => clk_fast,
    ctlEnA => BramEnIn,
    ctlEnB => '1',
    ctlWeA => '0',
    ctlWeB => we,
    busDoA => BramDataOut,
    busDoB => dataB2
  );

  inst_disp7: disp7 port map(
    disp4 => dataB2(15 downto 12),
    disp3 => dataB2(11 downto 8),
    disp2 => dataB2(7 downto 4),
    disp1 => dataB2(3 downto 0),
    clk => clk_disp7,
    aceso => "1111",
    en_disp => an,
    segm => seg,
    dp => dp
    );

  inst_clkdiv: clkdiv port map(
    --clk => mclk,
    clk => clk_50,
    clk50m => open,
    clk10hz => open,
    clk_disp => clk_disp7
    );
  
  Inst_datapath: datapath_1 port map(
		CLK				=> clk_fast,
		rst				=> rst_all,
		opcode		 	=> sw(2 downto 0),
		datain			=> dataB1_aux,
		counterin		=> general_address_S,
		dataout			=> dataB2in,
		adrout			=> adrB2cnt,
		done				=> done
		);

	 
  Inst_controlo: controlo port map(
		clk					=> clk_fast,
		rst					=> btn(0),
		buttons				=> btn,
		done					=> done,
		general_address	=> general_address_R,
		rst_dp				=> rst_dp,
		executing 			=> is_executing
  );
	 
  registr: process(clk_fast, btn(0))
  begin
		if btn(0) = '1' then
			general_address_S	<= "0000000000";	
		elsif rising_edge(CLK_FAST) then
			general_address_S	<= general_address_R;	
		end if;
  end process;
  
end Structural;
