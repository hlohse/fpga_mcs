--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   09:46:13 09/24/2013
-- Design Name:   
-- Module Name:   /home/kugel/daten/work/vhdl/mbIp/sp6/rtl/hdmi/hdmi_tb.vhd
-- Project Name:  mcs_top
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: hdmiOutIF
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
USE ieee.numeric_std.ALL;
use ieee.std_logic_unsigned.all;
 
ENTITY hdmi_tb IS
END hdmi_tb;
 
ARCHITECTURE behavior OF hdmi_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT hdmiOutIF
    PORT(
         CLK100_IN : IN  std_logic;
         clkHdmiTx : OUT  std_logic;
         hdmiDataR : IN  std_logic_vector(7 downto 0);
         hdmiDataG : IN  std_logic_vector(7 downto 0);
         hdmiDataB : IN  std_logic_vector(7 downto 0);
         hdmiHsync : OUT  std_logic;
         hdmiRow : OUT  std_logic_vector(9 downto 0);
         hdmiActive : OUT  std_logic;
         hdmiTx0_p : OUT  std_logic;
         hdmiTx0_n : OUT  std_logic;
         hdmiTx1_p : OUT  std_logic;
         hdmiTx1_n : OUT  std_logic;
         hdmiTx2_p : OUT  std_logic;
         hdmiTx2_n : OUT  std_logic;
         hdmiTx3_p : OUT  std_logic;
         hdmiTx3_n : OUT  std_logic;
         RESET : IN  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal CLK100_IN : std_logic := '0';
   signal hdmiDataR : std_logic_vector(7 downto 0) := X"55";
   signal hdmiDataG : std_logic_vector(7 downto 0) := X"11";
   signal hdmiDataB : std_logic_vector(7 downto 0) := X"F0";
   signal RESET : std_logic := '0';

 	--Outputs
   signal clkHdmiTx : std_logic;
   signal hdmiHsync : std_logic;
   signal hdmiRow : std_logic_vector(9 downto 0);
   signal hdmiActive : std_logic;
   signal hdmiTx0_p : std_logic;
   signal hdmiTx0_n : std_logic;
   signal hdmiTx1_p : std_logic;
   signal hdmiTx1_n : std_logic;
   signal hdmiTx2_p : std_logic;
   signal hdmiTx2_n : std_logic;
   signal hdmiTx3_p : std_logic;
   signal hdmiTx3_n : std_logic;


	-- verilog 
component hdmi_out_test 
 port (
		SYS_CLK : IN  std_logic;
		RSTBTN : in std_logic;
		TMDS : out  std_logic_vector(3 downto 0);
		TMDSb : out  std_logic_vector(3 downto 0)
);
end component;	


signal SYS_CLK :   std_logic;
signal RSTBTN :  std_logic;
signal TMDS :   std_logic_vector(3 downto 0);
signal TMDSb :   std_logic_vector(3 downto 0);


-------------------------------
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

  type FRAME_STATE_TYPE is (FRAME_RST, FRAME_FIND_POL, FRAME_WAIT_VSYNC, FRAME_DETECT, FRAME_LOCKED, FRAME_WR_CMD, FRAME_WR_DATA);

  signal pll_locked_n  : std_logic;
  signal pll_reset       : std_logic;
  signal soft_reset      : std_logic := '0'; 
  
  signal pxlclk        : std_logic;
  
  signal hsync     : std_logic;
  signal vsync     : std_logic;
  signal de        : std_logic;
  
  signal red                         : std_logic_vector(7 downto 0);
  signal green                       : std_logic_vector(7 downto 0);
  signal blue                        : std_logic_vector(7 downto 0);
  
  signal frame_state     : FRAME_STATE_TYPE := FRAME_RST;
  signal writing_cmd     : std_logic;
  signal writing_frame   : std_logic;
  signal frame_is_locked    : std_logic;
  
  signal hsync_pol     : std_logic := '0';
  signal vsync_pol     : std_logic := '0';
  
  signal hsync_reg     : std_logic := '0';
  signal vsync_reg     : std_logic := '0';
  signal de_reg        : std_logic := '0';
 
  signal new_frame     : std_logic;
  signal line_end     : std_logic;
  
  signal line_cnt : std_logic_vector(15 downto 0) := (others => '0');
  signal pxl_cnt : std_logic_vector(15 downto 0) := (others => '0');
  
  signal write_en        : std_logic := '0';
  signal frame_width     : std_logic_vector(15 downto 0) := (others => '0');
  signal frame_height    : std_logic_vector(15 downto 0) := (others => '0');
  signal frame_base_addr : std_logic_vector(31 downto 0) := (others => '0');
  signal line_stride     : std_logic_vector(15 downto 0) := (others => '0');

  signal vfbc_cmd_cnt     : std_logic_vector(6 downto 0) := (others => '0');
   
	
	-- Clock period definitions
   constant CLK100_IN_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   vhdl: hdmiOutIF PORT MAP (
          CLK100_IN => CLK100_IN,
          clkHdmiTx => clkHdmiTx,
          hdmiDataR => hdmiDataR,
          hdmiDataG => hdmiDataG,
          hdmiDataB => hdmiDataB,
          hdmiHsync => hdmiHsync,
          hdmiRow => hdmiRow,
          hdmiActive => hdmiActive,
          hdmiTx0_p => hdmiTx0_p,
          hdmiTx0_n => hdmiTx0_n,
          hdmiTx1_p => hdmiTx1_p,
          hdmiTx1_n => hdmiTx1_n,
          hdmiTx2_p => hdmiTx2_p,
          hdmiTx2_n => hdmiTx2_n,
          hdmiTx3_p => hdmiTx3_p,
          hdmiTx3_n => hdmiTx3_n,
          RESET => RESET
        );

--   verilog: hdmi_out_test PORT MAP (
--          SYS_CLK => CLK100_IN,
--          TMDS => TMDS,
--          TMDSb => TMDSb,
--          RSTBTN => RESET
--        );


Inst_dvi_decoder: dvi_decoder PORT MAP(
		tmdsclk_p => hdmiTx3_p,
		tmdsclk_n => hdmiTx3_n,
		blue_p => hdmiTx0_p,
		green_p => hdmiTx1_p,
		red_p => hdmiTx2_p,
		blue_n => hdmiTx0_n,
		green_n => hdmiTx1_n,
		red_n => hdmiTx3_n,
		exrst => RESET,
		reset => pll_locked_n,
		pclk => pxlclk,
		hsync => hsync,
		vsync => vsync,
		de => de,
		red => red, 
		green => green,
		blue => blue
	);

	------------ hdmi input logic ----------------
  --Generate the new_frame signal, which goes high when vsync becomes active,
  --and line_end, which goes high when date enable goes low. These pulse signals
  --only stay high for a single cycle
  signal_delay_proc : process (pxlclk)
  begin
    if (rising_edge(pxlclk)) then
      de_reg <= de;
      vsync_reg <= vsync;
    end if;
  end process signal_delay_proc;
  new_frame <= '1' when ((vsync_reg = not(vsync_pol)) and (vsync = vsync_pol)) else
               '0';
  line_end  <= '1' when ((de_reg = '1') and (de = '0'))else
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
        if (de = '1') then
          frame_state <= FRAME_WAIT_VSYNC;
        end if;
      when FRAME_WAIT_VSYNC =>
        if (new_frame = '1') then
          frame_state <= FRAME_DETECT;
        end if;
      when FRAME_DETECT =>
        if (new_frame = '1') then
          frame_state <= FRAME_LOCKED;
        end if;
      when FRAME_LOCKED =>
        if (write_en = '1') then
          frame_state <= FRAME_WR_CMD;
        end if;
      when FRAME_WR_CMD =>
        if (vfbc_cmd_cnt = 80) then
          frame_state <= FRAME_WR_DATA;
        end if;
      when FRAME_WR_DATA =>
        if (new_frame = '1') then
          if (write_en = '1') then
            frame_state <= FRAME_WR_CMD;
          else
            frame_state <= FRAME_LOCKED;
          end if;
        end if;
      when others=> --Should be unreachable
        frame_state <= FRAME_RST;
      end case;
    end if;
  end if;
  end process next_state_proc;
  
  writing_frame <= '1' when ((frame_state = FRAME_WR_CMD) or (frame_state = FRAME_WR_DATA)) else
                   '0';
  writing_cmd <= '1' when (frame_state = FRAME_WR_CMD) else
                 '0';                 
  frame_is_locked <= '1' when ((frame_state = FRAME_WR_CMD) or (frame_state = FRAME_WR_DATA) or (frame_state = FRAME_LOCKED)) else
                     '0';
                  
  find_sync_pol_proc : process (pxlclk)
  begin
    if (rising_edge(pxlclk)) then
      if (frame_state = FRAME_RST) then
        vsync_pol <= '0';
        hsync_pol <= '0';
      elsif (frame_state = FRAME_FIND_POL) then
        if (de = '1') then
          vsync_pol <= not(vsync);
          hsync_pol <= not(hsync);
        end if;
      end if;
    end if;
  end process find_sync_pol_proc;
    
  pxl_cnt_proc : process (pxlclk)
  begin
    if (rising_edge(pxlclk)) then
      if (frame_state = FRAME_DETECT) then
        if (de = '1') then
          pxl_cnt <= pxl_cnt + 1;
        elsif (line_end = '1') then
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
        frame_width <= (others => '0');
        frame_height <= (others => '0');
      elsif (frame_state = FRAME_DETECT) then
        if (line_end = '1') then
          frame_width <= pxl_cnt;
        end if;
        if (new_frame = '1') then
          frame_height <= line_cnt - 1;
        end if;
      end if;  
    end if;
  end process store_frame_dim_proc;

	
	----------------------------------------------


   -- Clock process definitions
   CLK100_IN_process :process
   begin
		CLK100_IN <= '0';
		wait for CLK100_IN_period/2;
		CLK100_IN <= '1';
		wait for CLK100_IN_period/2;
   end process;
 


   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
		reset <= '1';
      wait for 100 ns;	
		reset <= '0';

      wait for CLK100_IN_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;
