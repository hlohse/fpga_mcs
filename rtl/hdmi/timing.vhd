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

entity timing_xga is
  port (clk       : in  std_logic;
        rst   : in  std_logic;
        hsync     : out std_logic;
        hcount    : out std_logic_vector(10 downto 0);
        vcount    : out std_logic_vector(10 downto 0);
        vsync     : out std_logic;
		  active		: out std_logic
		  );
         
end timing_xga;

architecture Behavioral of timing_xga is

	signal hpos_cnt : std_logic_vector(10 downto 0);
	signal hpos_clr : std_logic;
	signal hpos_ena : std_logic;

	signal vpos_cnt : std_logic_vector(10 downto 0);
	signal vpos_clr : std_logic;
	signal vpos_ena : std_logic;

-- assign tc_hsblnk = 11'd1024 - 11'd1;
--  assign tc_hssync = 11'd1024 - 11'd1 + 11'd24;
--  assign tc_hesync = 11'd1024 - 11'd1 + 11'd24 + 11'd136;
--  assign tc_heblnk = 11'd1024 - 11'd1 + 11'd24 + 11'd136 + 11'd160;
--  assign tc_vsblnk =  11'd768 - 11'd1;
--  assign tc_vssync =  11'd768 - 11'd1 + 11'd3;
--  assign tc_vesync =  11'd768 - 11'd1 + 11'd3 + 11'd6;
--  assign tc_veblnk =  11'd768 - 11'd1 + 11'd3 + 11'd6 + 11'd29;

	constant tc_hsblnk : std_logic_vector(10 downto 0) := std_logic_vector(to_unsigned(1023,11));
	constant tc_hssync : std_logic_vector(10 downto 0);
	constant tc_hesync : std_logic_vector(10 downto 0);
	constant tc_heblnk : std_logic_vector(10 downto 0);

	constant tc_vsblnk : std_logic_vector(10 downto 0);
	constant tc_vssync : std_logic_vector(10 downto 0);
	constant tc_vesync : std_logic_vector(10 downto 0);
	constant tc_veblnk : std_logic_vector(10 downto 0);

	signal hblnk     : std_logic;
	signal vblnk     : std_logic;

begin


  ----------------------------------------------------------------------
  -- This logic describes a 11-bit horizontal position counter.       --
  ----------------------------------------------------------------------
 
  process (clk)
  begin
    if rising_edge(clk) then
      if (hpos_clr = '1') then
        hpos_cnt <= b"00000000000";
      elsif (hpos_ena = '1') then
        hpos_cnt <= hpos_cnt + b"00000000001";
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
        vpos_cnt <= b"00000000000";
      elsif (vpos_ena = '1') then
        vpos_cnt <= vpos_cnt + b"00000000001";
      end if;
    end if;
  end process;


  ----------------------------------------------------------------------
  -- This logic describes the position counter control.  Counters are --
  -- reset when they reach the total count and the counter is then    --
  -- enabled to advance.  Use of GTE operator ensures dynamic changes --
  -- to display timing parameters do not allow counters to run away.  --
  ----------------------------------------------------------------------

  hpos_ena <= b"1";
  hpos_clr <= ((hpos_cnt >= tc_heblnk) and hpos_ena) or rst;

  vpos_ena <= hpos_ena;
  vpos_clr <= ((vpos_cnt >= tc_veblnk) and vpos_ena) or rst;

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

  hcount <= hpos_cnt;
  hblnk <= (hcount > tc_hsblnk);
  hsync <= (hcount > tc_hssync) and (hcount <= tc_hesync);

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

  vcount <= vpos_cnt;
  vblnk <= (vcount > tc_vsblnk);
  vsync <= (vcount > tc_vssync) and (vcount <= tc_vesync);

end Behavioral;

