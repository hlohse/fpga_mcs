----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:48:00 10/10/2013 
-- Design Name: 
-- Module Name:    hdmiRx - Behavioral 
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
USE ieee.numeric_std.ALL;
use ieee.std_logic_unsigned.all;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity hdmiRx is
port (
		hdmiRx_p : IN std_logic_vector(3 downto 0);
		hdmiRx_n : IN std_logic_vector(3 downto 0);
		reset : IN std_logic;          
		pclk : OUT std_logic;
		frame_width     : OUT std_logic_vector(15 downto 0) := (others => '0');
		frame_height    : OUT std_logic_vector(15 downto 0) := (others => '0');
		new_frame     : OUT std_logic;
		line_end     : OUT std_logic;
		hsync : OUT std_logic;
		vsync : OUT std_logic;
		de : OUT std_logic;
		red : OUT std_logic_vector(7 downto 0);
		green : OUT std_logic_vector(7 downto 0);
		blue : OUT std_logic_vector(7 downto 0)
);
end hdmiRx;

architecture Behavioral of hdmiRx is

	COMPONENT dvi_decoder
	PORT(
		tmdsclk_p : IN std_logic;
		tmdsclk_n : IN std_logic;
		blue_p : IN std_logic;
		green_p : IN std_logic;
		red_p : IN std_logic;
		blue_n : IN std_logic;
		green_n : IN std_logic;
		red_n : IN std_logic;
		exrst : IN std_logic;          
		reset : OUT std_logic;
		pclk : OUT std_logic;
		hsync : OUT std_logic;
		vsync : OUT std_logic;
		de : OUT std_logic;
		red : OUT std_logic_vector(7 downto 0);
		green : OUT std_logic_vector(7 downto 0);
		blue : OUT std_logic_vector(7 downto 0)
		);
	END COMPONENT;

  type FRAME_STATE_TYPE is (FRAME_RST, FRAME_FIND_POL, FRAME_WAIT_VSYNC, FRAME_DETECT, FRAME_LOCKED);

  signal pll_locked_n  : std_logic;
  signal pll_reset       : std_logic;
  signal soft_reset      : std_logic := '0'; 
  
  signal pxlclk        : std_logic;
  
  signal hsync_i     : std_logic;
  signal vsync_i     : std_logic;
  signal de_i        : std_logic;
  
  
  signal frame_state     : FRAME_STATE_TYPE := FRAME_RST;
  signal writing_cmd     : std_logic;
  signal writing_frame   : std_logic;
  signal frame_is_locked    : std_logic;
  
  signal hsync_pol     : std_logic := '0';
  signal vsync_pol     : std_logic := '0';
  
  signal hsync_reg     : std_logic := '0';
  signal vsync_reg     : std_logic := '0';
  signal de_reg        : std_logic := '0';
 
  signal new_frame_i     : std_logic;
  signal line_end_i     : std_logic;
  
  signal line_cnt : std_logic_vector(15 downto 0) := (others => '0');
  signal pxl_cnt : std_logic_vector(15 downto 0) := (others => '0');
  
  signal write_en        : std_logic := '0';
  signal frame_width_i     : std_logic_vector(15 downto 0) := (others => '0');
  signal frame_height_i    : std_logic_vector(15 downto 0) := (others => '0');
  signal frame_base_addr : std_logic_vector(31 downto 0) := (others => '0');
  signal line_stride     : std_logic_vector(15 downto 0) := (others => '0');

  signal vfbc_cmd_cnt     : std_logic_vector(6 downto 0) := (others => '0');


begin

receiveDecoder: dvi_decoder PORT MAP(
		tmdsclk_p => hdmiRx_p(3),
		tmdsclk_n => hdmiRx_n(3),
		blue_p => hdmiRx_p(0),
		green_p => hdmiRx_p(1),
		red_p => hdmiRx_p(2),
		blue_n => hdmiRx_n(0),
		green_n => hdmiRx_n(1),
		red_n => hdmiRx_n(2),
		exrst => RESET,
		reset => pll_locked_n,
		pclk => pxlclk,
		hsync => hsync_i,
		vsync => vsync_i,
		de => de_i,
		red => red, 
		green => green,
		blue => blue
	);

	de <= de_i;
	hsync <= hsync_i xor hsync_pol;
	vsync <= vsync_i xor vsync_pol;
	
	frame_width <= frame_width_i;
	frame_height <= frame_height_i;
	new_frame <= new_frame_i;
	line_end <= line_end_i;

	pclk <= pxlclk;
	
	------------ hdmi input logic ----------------
  --Generate the new_frame signal, which goes high when vsync becomes active,
  --and line_end, which goes high when date enable goes low. These pulse signals
  --only stay high for a single cycle
  signal_delay_proc : process (pxlclk)
  begin
    if (rising_edge(pxlclk)) then
      de_reg <= de_i;
      vsync_reg <= vsync_i;
    end if;
  end process signal_delay_proc;
  new_frame_i <= '1' when ((vsync_reg = not(vsync_pol)) and (vsync_i = vsync_pol)) else
               '0';
  line_end_i  <= '1' when ((de_reg = '1') and (de_i = '0'))else
               '0';
  
  
  
  --Next state logic for frame detect and write state machine
  next_state_proc : process (pxlclk, pll_locked_n)
  begin
  if (pll_locked_n = '1') then
    frame_state <= FRAME_RST;
  else
    if (rising_edge(pxlclk)) then
      case frame_state is 
      when FRAME_RST =>
        frame_state <= FRAME_FIND_POL;
      when FRAME_FIND_POL =>
        if (de_i = '1') then
          frame_state <= FRAME_WAIT_VSYNC;
        end if;
      when FRAME_WAIT_VSYNC =>
        if (new_frame_i = '1') then
          frame_state <= FRAME_DETECT;
        end if;
      when FRAME_DETECT =>
        if (new_frame_i = '1') then
          frame_state <= FRAME_LOCKED;
        end if;
      when FRAME_LOCKED =>
          frame_state <= FRAME_LOCKED; -- no exit from here
      when others=> --Should be unreachable
        frame_state <= FRAME_RST;
      end case;
    end if;
  end if;
  end process next_state_proc;
  
                  
  find_sync_pol_proc : process (pxlclk)
  begin
    if (rising_edge(pxlclk)) then
      if (frame_state = FRAME_RST) then
        vsync_pol <= '0';
        hsync_pol <= '0';
      elsif (frame_state = FRAME_FIND_POL) then
        if (de_i = '1') then
          vsync_pol <= not(vsync_i);
          hsync_pol <= not(hsync_i);
        end if;
      end if;
    end if;
  end process find_sync_pol_proc;
    
  pxl_cnt_proc : process (pxlclk)
  begin
    if (rising_edge(pxlclk)) then
      if (frame_state = FRAME_DETECT) then
        if (de_i = '1') then
          pxl_cnt <= pxl_cnt + 1;
        elsif (line_end_i = '1') then
          pxl_cnt <= (others => '0');
          line_cnt <= line_cnt + 1; 
        end if;
      else
        pxl_cnt <= (others => '0');
        line_cnt <= (others => '0');
      end if;  
    end if;
  end process pxl_cnt_proc;
  
  store_frame_dim_proc : process (pxlclk)
  begin
    if (rising_edge(pxlclk)) then
      if (frame_state = FRAME_RST) then
        frame_width_i <= (others => '0');
        frame_height_i <= (others => '0');
      elsif (frame_state = FRAME_DETECT) then
        if (line_end_i = '1') then
          frame_width_i <= pxl_cnt;
        end if;
        if (new_frame_i = '1') then
          frame_height_i <= line_cnt - 1;
        end if;
      end if;  
    end if;
  end process store_frame_dim_proc;
	


end Behavioral;

