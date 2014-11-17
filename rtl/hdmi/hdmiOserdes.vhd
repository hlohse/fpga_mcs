----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    21:51:04 09/23/2013 
-- Design Name: 
-- Module Name:    hdmiOserdes - Behavioral 
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

entity hdmiOserdes is
	port (
        clk_in : std_logic;
        clk_in_div : std_logic;
        serdesstrobe : std_logic;
		  txd: std_logic_vector(4 downto 0);
		  tx_p : out std_logic;
		  tx_n : out std_logic;
        RST  : std_logic
	);
end hdmiOserdes;

architecture Behavioral of hdmiOserdes is

signal ocascade_sm_d : std_logic;
signal ocascade_sm_t : std_logic;
signal ocascade_ms_d : std_logic;
signal ocascade_ms_t : std_logic;
signal tx: std_logic;

begin

     -- declare the oserdes
     oserdes2_master : OSERDES2
       generic map (
         DATA_RATE_OQ   => "SDR",
         DATA_RATE_OT   => "SDR",
         TRAIN_PATTERN  => 0,
         DATA_WIDTH     => 5,
         SERDES_MODE    => "MASTER",
         OUTPUT_MODE    => "DIFFERENTIAL") --"SINGLE_ENDED")
       port map (
        D1         => txd(4), --txd(3),
        D2         => '1', -- txd(2),
        D3         => '1', -- txd(1),
        D4         => '1', -- txd(0),
        T1         => '0',
        T2         => '0',
        T3         => '0',
        T4         => '0',
        SHIFTIN1   => '1',
        SHIFTIN2   => '1',
        SHIFTIN3   => ocascade_sm_d,
        SHIFTIN4   => ocascade_sm_t,
        SHIFTOUT1  => ocascade_ms_d,
        SHIFTOUT2  => ocascade_ms_t,
        SHIFTOUT3  => open,
        SHIFTOUT4  => open,
        TRAIN      => '0',
        OCE        => '1',
        CLK0       => clk_in,
        CLK1       => '0',
        CLKDIV     => clk_in_div,
        OQ         => tx,
        TQ         => open,
        IOCE       => serdesstrobe,
        TCE        => '1',
        RST        => rst);


     oserdes2_slave : OSERDES2
       generic map (
         DATA_RATE_OQ   => "SDR",
         DATA_RATE_OT   => "SDR",
         DATA_WIDTH     => 5,
         SERDES_MODE    => "SLAVE",
         TRAIN_PATTERN  => 0,
         OUTPUT_MODE    => "DIFFERENTIAL")
       port map (
        D1         => txd(0),
        D2         => txd(1),
        D3         => txd(2),
        D4         => txd(3),
        T1         => '0',
        T2         => '0',
        T3         => '0',
        T4         => '0',
        SHIFTIN1   => ocascade_ms_d,
        SHIFTIN2   => ocascade_ms_t,
        SHIFTIN3   => '1',
        SHIFTIN4   => '1',
        SHIFTOUT1  => open,
        SHIFTOUT2  => open,
        SHIFTOUT3  => ocascade_sm_d,
        SHIFTOUT4  => ocascade_sm_t,
        TRAIN      => '0',
        OCE        => '1',
        CLK0       => clk_in,
        CLK1       => '0',
        CLKDIV     => clk_in_div,
        OQ         => open,
        TQ         => open,
        IOCE       => serdesstrobe,
        TCE        => '1',
        RST        => rst);

     obufds_inst : OBUFDS
       generic map (
         IOSTANDARD => "TMDS_33")
       port map (
         O          => tx_p,
         OB         => tx_n,
         I          => tx);





end Behavioral;

