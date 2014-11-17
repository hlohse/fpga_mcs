----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    20:53:42 09/23/2013 
-- Design Name: 
-- Module Name:    hdmiOutIF - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
library UNISIM;
use UNISIM.VComponents.all;

entity hdmiOutIF is
  generic (
		xga: integer := 1; -- xga or 720p on hdmi
		simulation: integer := 0
  );
port(
  CLK100_IN          : in     std_logic;
  clkHdmiTx				: out std_logic; -- 65 MHz
  hdmiDataR				: in std_logic_vector(7 downto 0);
  hdmiDataG				: in std_logic_vector(7 downto 0);
  hdmiDataB				: in std_logic_vector(7 downto 0);  -- sync control goes with blue
  hdmiHsync				: out std_logic;  -- row sync for address generator
  hdmiVsync				: out std_logic;  -- vsync for address generator
  hdmiHsyncIn			: in std_logic;  -- row sync from data source
  hdmiVsyncIn			: in std_logic;  -- vsync from data source
  hdmiFsync          : out std_logic;  -- frame sync. active with very last row 
  hdmiRow				: out std_logic_vector(9 downto 0);  -- row number, valid with vsync
  hdmiActive			: out std_logic;  -- read enable
  hdmiActiveIn			: in std_logic;  -- read enable
  hdmiTx0_p				: out std_logic;
  hdmiTx0_n				: out std_logic;
  hdmiTx1_p				: out std_logic;
  hdmiTx1_n				: out std_logic;
  hdmiTx2_p				: out std_logic;
  hdmiTx2_n				: out std_logic;
  hdmiTx3_p				: out std_logic;
  hdmiTx3_n				: out std_logic;
  RESET             	: in     std_logic
);
end hdmiOutIF;

-- sync control goes with blue
-- hsync is c0
-- vsync is c1
-- data enable while not blank

architecture Behavioral of hdmiOutIF is


component hdmiClkXga
port
 (-- Clock in ports
  CLK100_IN           : in     std_logic;
  CLKFB_IN          : in     std_logic;
  -- Clock out ports
  CLK_650          : out    std_logic;
  CLK_130          : out    std_logic;
  CLK_65          : out    std_logic;
  CLKFB_OUT         : out    std_logic;
  -- Status and control signals
  RESET             : in     std_logic;
  LOCKED            : out    std_logic
 );
end component;

component hdmiClk720p
port
 (-- Clock in ports
  CLK100_IN           : in     std_logic;
  CLKFB_IN          : in     std_logic;
  -- Clock out ports
  CLK_650          : out    std_logic;
  CLK_130          : out    std_logic;
  CLK_65          : out    std_logic;
  CLKFB_OUT         : out    std_logic;
  -- Status and control signals
  RESET             : in     std_logic;
  LOCKED            : out    std_logic
 );
end component;

signal clk_650: std_logic;
signal ioclk_650: std_logic;
signal clk_130: std_logic;
signal clk_65: std_logic;
signal CLKFB_OUT: std_logic;
signal bufpll_strobe: std_logic;
signal pll_locked: std_logic;
signal localRst: std_logic;

COMPONENT hdmiOserdes
PORT(
	clk_in : IN std_logic;
	clk_in_div : IN std_logic;
	serdesstrobe : IN std_logic;
	txd : IN std_logic_vector(4 downto 0);
	tx_p : out std_logic;
	tx_n : out std_logic;
	RST : IN std_logic 
	);
END COMPONENT;

signal tmdsClk: std_logic_vector(4 downto 0);

COMPONENT tmdsEncoder
PORT(
	clk : IN std_logic;
	rst : IN std_logic;
	de : IN std_logic;
	c1 : IN std_logic;
	c0 : IN std_logic;
	d : IN std_logic_vector(7 downto 0);          
	q : OUT std_logic_VECTOR (9 downto 0)
	);
END COMPONENT;

signal hdmiTxBEnc : std_logic_vector(9 downto 0);
signal hdmiTxBFast : std_logic_vector(4 downto 0);
signal hdmiTxBFastPipe : std_logic_vector(4 downto 0);

signal hdmiTxREnc : std_logic_vector(9 downto 0);
signal hdmiTxRFast : std_logic_vector(4 downto 0);
signal hdmiTxRFastPipe : std_logic_vector(4 downto 0);

signal hdmiTxGEnc : std_logic_vector(9 downto 0);
signal hdmiTxGFast : std_logic_vector(4 downto 0);
signal hdmiTxGFastPipe : std_logic_vector(4 downto 0);


signal dataEnable: std_logic := '1';
signal blueC0: std_logic := '0';
signal blueC1: std_logic := '0';
signal dataToggle: std_logic := '0';

-------------------------------
COMPONENT timing
PORT(
	rst : IN std_logic;
	clk : IN std_logic;          
   active : out std_logic;
	hcount : OUT std_logic_vector(10 downto 0);
	hsync : OUT std_logic;
	vcount : OUT std_logic_vector(10 downto 0);
	vsync : OUT std_logic
	);
END COMPONENT;

COMPONENT timing_xga
generic (
	simulation: integer := 0
);
PORT(
	rst : IN std_logic;
	clk : IN std_logic;          
   active : out std_logic;
   invert    : out std_logic := '1';
	hcount : OUT std_logic_vector(10 downto 0);
	hsync : OUT std_logic;
	fsync : OUT std_logic;
	vcount : OUT std_logic_vector(10 downto 0);
	vsync : OUT std_logic
	);
END COMPONENT;

COMPONENT timing_720p
generic (
	simulation: integer := 0
);
PORT(
	rst : IN std_logic;
	clk : IN std_logic;          
   active : out std_logic;
   invert    : out std_logic := '1';
	hcount : OUT std_logic_vector(10 downto 0);
	hsync : OUT std_logic;
	fsync : OUT std_logic;
	vcount : OUT std_logic_vector(10 downto 0);
	vsync : OUT std_logic
	);
END COMPONENT;

signal hcount :  std_logic_vector(10 downto 0);
signal hsync_out :  std_logic;
signal vcount :  std_logic_vector(10 downto 0);
signal vsync_out :  std_logic;

signal syncInvert: std_logic;

begin

-- reset
	process(reset, pll_locked, clk_65) 
	begin
		if reset = '1' or pll_locked = '0' then
			localRst <= '1';
		elsif rising_edge(clk_65) then
			localRst <= '0';
		end if;
	end process;



	clkHdmiTx <= CLK_65;

  -- high speed clock
  bufpll_inst_fwd : BUFPLL
     generic map (
       DIVIDE        => 5)
     port map (
       IOCLK        => ioclk_650,
       LOCK         => open, -- bufpll_locked,
       SERDESSTROBE => bufpll_strobe,
       GCLK         => CLK_130,
       LOCKED       => pll_locked,
       PLLIN        => CLK_650
		 );

	-- Toggle
   process
	begin
		wait until rising_edge(clk_130);
		if localRst = '1' then
			dataToggle <= '0';
		else
			dataToggle <= not dataToggle;
		end if;
	end process;

	-- timing control
	xgaTiming: if xga /= 0 generate
	begin
		clkGen : hdmiClkXga
		port map
			(-- Clock in ports
			 CLK100_IN => CLK100_IN,
			 CLKFB_IN => CLKFB_OUT,
			 -- Clock out ports
			 CLK_650 => CLK_650,
			 CLK_130 => CLK_130,
			 CLK_65 => CLK_65,
			 CLKFB_OUT => CLKFB_OUT,
			 -- Status and control signals
			 LOCKED => pll_locked,
			 RESET  => RESET
		 );
		 
		timeCtl: timing_xga 
		generic map ( simulation => simulation)
		PORT MAP(
			hcount => hcount,
			hsync => hsync_out,
			active => hdmiActive, -- dataEnable,
			-- hblnk => hblnk,
			invert => syncInvert,
			vcount => vcount,
			vsync => vsync_out,
			fsync => hdmiFsync,
			-- vblnk => vblnk,
			rst => localRst,
			clk => clk_65
		);
	end generate;

	nonXgaTiming: if xga = 0 generate
	begin
		clkGen : hdmiClk720p
		port map
			(-- Clock in ports
			 CLK100_IN => CLK100_IN,
			 CLKFB_IN => CLKFB_OUT,
			 -- Clock out ports
			 CLK_650 => CLK_650,
			 CLK_130 => CLK_130,
			 CLK_65 => CLK_65,
			 CLKFB_OUT => CLKFB_OUT,
			 -- Status and control signals
			 LOCKED => pll_locked,
			 RESET  => RESET
		 );
		 
		timeCtl: timing_720p 
		generic map ( simulation => simulation)
		PORT MAP(
			hcount => hcount,
			hsync => hsync_out,
			active => hdmiActive, -- dataEnable,
			-- hblnk => hblnk,
			invert => syncInvert,
			vcount => vcount,
			vsync => vsync_out,
			fsync => hdmiFsync,
			-- vblnk => vblnk,
			rst => localRst,
			clk => clk_65
		);
	end generate;
	
	-- make syncs always high active ->check with timing generator
  hdmiHsync <= hsync_out xor syncInvert;	-- sync is for horizontal line
  hdmiVsync <= vsync_out xor syncInvert;	-- sync is for frame
  blueC1 <= hdmiVsyncIn xor syncInvert;
  blueC0 <= hdmiHsyncIn xor syncInvert;
  hdmiRow <= vcount(9 downto 0); -- row number is from vertical count
  -- hdmiActive <= dataEnable;
  dataEnable <= hdmiActiveIn;

	-- encoding
	blueEncoder: tmdsEncoder PORT MAP(
		clk => clk_65,
		rst => localRst,
		de => dataEnable,
		c1 => blueC1, -- vsync
		c0 => blueC0, -- hsync
		d => hdmiDataB,
		q => hdmiTxBEnc
	);

	redEncoder: tmdsEncoder PORT MAP(
		clk => clk_65,
		rst => localRst,
		de => dataEnable,
		c1 => '0',
		c0 => '0',
		d => hdmiDataR,
		q => hdmiTxREnc
	);
	greeEncoder: tmdsEncoder PORT MAP(
		clk => clk_65,
		rst => localRst,
		de => dataEnable,
		c1 => '0',
		c0 => '0',
		d => hdmiDataG,
		q => hdmiTxGEnc
	);

	
	-- 2 stage serialisation
	muxProc: process
	begin
		wait until rising_edge(clk_130);
		if dataToggle = '1' then
			hdmiTxBFast <= hdmiTxBEnc(4 downto 0);
			hdmiTxRFast <= hdmiTxREnc(4 downto 0);
			hdmiTxGFast <= hdmiTxGEnc(4 downto 0);
		else
			hdmiTxBFast <= hdmiTxBEnc(9 downto 5);
			hdmiTxRFast <= hdmiTxREnc(9 downto 5);
			hdmiTxGFast <= hdmiTxGEnc(9 downto 5);
		end if;
		-- pipeline stages
		hdmiTxBFastPipe <= hdmiTxBFast;
		hdmiTxRFastPipe <= hdmiTxRFast;
		hdmiTxGFastPipe <= hdmiTxGFast;
	end process;


	-- blue goes on 0
	hdmiOserdes_0: hdmiOserdes PORT MAP(
		clk_in => ioclk_650,
		clk_in_div => CLK_130,
		serdesstrobe => bufpll_strobe,
		txd => hdmiTxBFastPipe,
		tx_p => hdmiTx0_p,
		tx_n => hdmiTx0_n,
		RST => localRst
	);

	-- red goes on 1
	hdmiOserdes_1: hdmiOserdes PORT MAP(
		clk_in => ioclk_650,
		clk_in_div => CLK_130,
		serdesstrobe => bufpll_strobe,
		txd => hdmiTxRFastPipe,
		tx_p => hdmiTx1_p,
		tx_n => hdmiTx1_n,
		RST => localRst
	);
	
	-- green goes on 2
	hdmiOserdes_2: hdmiOserdes PORT MAP(
		clk_in => ioclk_650,
		clk_in_div => CLK_130,
		serdesstrobe => bufpll_strobe,
		txd => hdmiTxGFastPipe,
		tx_p => hdmiTx2_p,
		tx_n => hdmiTx2_n,
		RST => localRst
	);

	-- create toggle clock
	tmdsClk <= (others => '1') when dataToggle = '1' else (others => '0');
	
	-- clock goes on 3
	hdmiOserdes_3: hdmiOserdes PORT MAP(
		clk_in => ioclk_650,
		clk_in_div => CLK_130,
		serdesstrobe => bufpll_strobe,
		txd => tmdsClk,  
		tx_p => hdmiTx3_p,
		tx_n => hdmiTx3_n,
		RST => localRst
	);


end Behavioral;

