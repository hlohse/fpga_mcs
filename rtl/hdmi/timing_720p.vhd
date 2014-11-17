----------------------------------------------------------------------------------
-- vim:ts=2:sw=2:expandtab
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:23:05 09/24/2013 
-- Design Name: 
-- Module Name:    timing - Behavioral 
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
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity timing_720p is
  generic (
		simulation: integer := 0
  );
  port (clk       : in  std_logic;
        rst   : in  std_logic;
        hsync     : out std_logic;
        hcount    : out std_logic_vector(10 downto 0);
        vcount    : out std_logic_vector(10 downto 0);
        vsync     : out std_logic;
        fsync     : out std_logic; -- frame sync. active with very last row 
        invert    : out std_logic := '0';
		  active		: out std_logic
		  );
         
end timing_720p;

architecture Behavioral of timing_720p is

	signal hpos_cnt : unsigned(10 downto 0);
	signal hpos_clr : std_logic;
	signal hpos_ena : std_logic;

	signal vpos_cnt : unsigned(10 downto 0);
	signal vpos_clr : std_logic;
	signal vpos_ena : std_logic;

--  //1280x720@60HZ
--  parameter HPIXELS_HDTV720P = 11'd1280; //Horizontal Live Pixels
--  parameter VLINES_HDTV720P  = 11'd720;  //Vertical Live ines
--  parameter HSYNCPW_HDTV720P = 11'd80;  //HSYNC Pulse Width
--  parameter VSYNCPW_HDTV720P = 11'd5;    //VSYNC Pulse Width
--  parameter HFNPRCH_HDTV720P = 11'd72;   //Horizontal Front Portch
--  parameter VFNPRCH_HDTV720P = 11'd3;    //Vertical Front Portch
--  parameter HBKPRCH_HDTV720P = 11'd216;  //Horizontal Front Portch
--  parameter VBKPRCH_HDTV720P = 11'd22;   //Vertical Front Portch

--	constant tc_hsblnk :   unsigned(10 downto 0) := to_unsigned(1280 - 1,11);
--	constant tc_hssync :   unsigned(10 downto 0) := to_unsigned(1280 - 1 + 72,11);
--	constant tc_hesync :   unsigned(10 downto 0) := to_unsigned(1280 - 1 + 72 + 80,11);
--	constant tc_heblnk :   unsigned(10 downto 0) := to_unsigned(1280 - 1 + 72 + 80 + 216,11);
--
--	constant tc_vsblnk :   unsigned(10 downto 0) := to_unsigned(720 - 1,11);
--	constant tc_vssync :   unsigned(10 downto 0) := to_unsigned(720 - 1 + 5,11);
--	constant tc_vesync :   unsigned(10 downto 0) := to_unsigned(720 - 1 + 5 + 3,11);
--	constant tc_veblnk :   unsigned(10 downto 0) := to_unsigned(720 - 1 + 5 + 3 + 22,11);


-- sblnk: start blank, ssync: start sync, esync: end sync, eblnk: end blank

	constant tc_hsblnk :   unsigned(10 downto 0) := to_unsigned(1280 - 1,11);
	constant tc_hssync :   unsigned(10 downto 0) := to_unsigned(1280 - 1 + 72,11);
	constant tc_hesync :   unsigned(10 downto 0) := to_unsigned(1280 - 1 + 72 + 80,11);
	constant tc_heblnk :   unsigned(10 downto 0) := to_unsigned(1280 - 1 + 72 + 80 + 216,11);

	constant tc_vsblnk :   unsigned(10 downto 0) := to_unsigned(720 - 1,11);
	constant tc_vssync :   unsigned(10 downto 0) := to_unsigned(720 - 1 + 3,11);
	constant tc_vesync :   unsigned(10 downto 0) := to_unsigned(720 - 1 + 3 + 5,11);
	constant tc_veblnk :   unsigned(10 downto 0) := to_unsigned(720 - 1 + 3 + 5 + 22,11);

	signal hblnk     :  std_logic;
	signal vblnk     :  std_logic;

	signal hcount_i    :  unsigned(10 downto 0);
	signal vcount_i    :  unsigned(10 downto 0);
	
	signal vsync_i, hsync_i: std_logic;
	
	constant hvsync_polarity : std_logic := '0';

begin

	-- fix invert signal
	invert <= '0';

  ----------------------------------------------------------------------
  -- This logic describes a 11-bit horizontal position counter.       --
  ----------------------------------------------------------------------
 
  process (clk)
  begin
    if rising_edge(clk) then
      if (hpos_clr = '1') then
        hpos_cnt <= (others => '0');
      elsif (hpos_ena = '1') then
        hpos_cnt <= hpos_cnt + 1; 
      end if;
    end if;
  end process;

  ----------------------------------------------------------------------
  -- This logic describes a 11-bit vertical position counter.         --
  ----------------------------------------------------------------------

  process (clk)
  begin
	 if rising_edge(clk) then
		if (vpos_clr = '1') then
		  vpos_cnt <= (others => '0'); 
		elsif (vpos_ena = '1') then
		  vpos_cnt <= vpos_cnt + 1; 
		end if;
	 end if;
  end process;

  -- drive frame sync signal when in last row
  fsync <= '1' when (vpos_cnt = tc_veblnk) else '0';

  ----------------------------------------------------------------------
  -- This logic describes the position counter control.  Counters are --
  -- reset when they reach the total count and the counter is then    --
  -- enabled to advance.  Use of GTE operator ensures dynamic changes --
  -- to display timing parameters do not allow counters to run away.  --
  ----------------------------------------------------------------------

  hpos_ena <= '1';
  hpos_clr <= '1' when ((hpos_cnt >= tc_heblnk) and (hpos_ena = '1')) else '1' when rst = '1' else '0';

  vpos_ena <= hpos_clr;
  vpos_clr <= '1' when ((vpos_cnt >= tc_veblnk) and (vpos_ena = '1')) else '1' when rst = '1' else '0';

  ----------------------------------------------------------------------
  -- This is the logic for the horizontal outputs.  Active video is   --
  -- always started when the horizontal count is zero.  Example:      --
  --                                                                  --
  -- tc_hsblnk = 03                                                   --
  -- tc_hssync = 07                                                   --
  -- tc_hesync = 11                                                   --
  -- tc_heblnk = 15 (htotal)                                          --
  --                                                                  --
  -- hcount   00 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15         --
  -- hsync    ________________________------------____________        --
  -- hblnk    ____________------------------------------------        --
  --                                                                  --
  -- hsync time  = (tc_hesync - tc_hssync) pixels                     --
  -- hblnk time  = (tc_heblnk - tc_hsblnk) pixels                     --
  -- active time = (tc_hsblnk + 1) pixels                             --
  --                                                                  --
  ----------------------------------------------------------------------

  hcount_i <= hpos_cnt;
  hblnk <= '1' when (hcount_i > tc_hsblnk) else '0';
  hsync_i <= '1' when (hcount_i > tc_hssync) and (hcount_i <= tc_hesync) else '0';

  ----------------------------------------------------------------------
  -- This is the logic for the vertical outputs.  Active video is     --
  -- always started when the vertical count is zero.  Example:        --
  --                                                                  --
  -- tc_vsblnk = 03                                                   --
  -- tc_vssync = 07                                                   --
  -- tc_vesync = 11                                                   --
  -- tc_veblnk = 15 (vtotal)                                          --
  --                                                                  --
  -- vcount   00 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15         --
  -- vsync    ________________________------------____________        --
  -- vblnk    ____________------------------------------------        --
  --                                                                  --
  -- vsync time  = (tc_vesync - tc_vssync) lines                      --
  -- vblnk time  = (tc_veblnk - tc_vsblnk) lines                      --
  -- active time = (tc_vsblnk + 1) lines                              --
  --                                                                  --
  ----------------------------------------------------------------------

  vcount_i <= vpos_cnt;
  vblnk <= '1' when (vcount_i > tc_vsblnk) else '0';
  vsync_i <= '1' when (vcount_i > tc_vssync) and (vcount_i <= tc_vesync) else '0';

	-- output process
	process
	begin
		wait until rising_edge(clk);
		vsync <= vsync_i xor hvsync_polarity;
		hsync <= hsync_i xor hvsync_polarity;
		active <= (not hblnk) and (not vblnk);
	end process;

	hcount <= std_logic_vector(hcount_i);
	vcount <= std_logic_vector(vcount_i);
	
end Behavioral;

