--*****************************************************************************
-- (c) Copyright 2009 Xilinx, Inc. All rights reserved.
--
-- This file contains confidential and proprietary information
-- of Xilinx, Inc. and is protected under U.S. and
-- international copyright and other intellectual property
-- laws.
--
-- DISCLAIMER
-- This disclaimer is not a license and does not grant any
-- rights to the materials distributed herewith. Except as
-- otherwise provided in a valid license issued to you by
-- Xilinx, and to the maximum extent permitted by applicable
-- law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
-- WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
-- AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
-- BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
-- INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
-- (2) Xilinx shall not be liable (whether in contract or tort,
-- including negligence, or under any other theory of
-- liability) for any loss or damage of any kind or nature
-- related to, arising under or in connection with these
-- materials, including for any direct, or any indirect,
-- special, incidental, or consequential loss or damage
-- (including loss of data, profits, goodwill, or any type of
-- loss or damage suffered as a result of any action brought
-- by a third party) even if such damage or loss was
-- reasonably foreseeable or Xilinx had been advised of the
-- possibility of the same.
--
-- CRITICAL APPLICATIONS
-- Xilinx products are not designed or intended to be fail-
-- safe, or for use in any application requiring fail-safe
-- performance, such as life-support or safety devices or
-- systems, Class III medical devices, nuclear facilities,
-- applications related to the deployment of airbags, or any
-- other applications that could lead to death, personal
-- injury, or severe property or environmental damage
-- (individually and collectively, "Critical
-- Applications"). Customer assumes the sole risk and
-- liability of any use of Xilinx products in Critical
-- Applications, subject only to applicable laws and
-- regulations governing limitations on product liability.
--
-- THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
-- PART OF THIS FILE AT ALL TIMES.
--
--*****************************************************************************
--   ____  ____
--  /   /\/   /
-- /___/  \  /    Vendor             : Xilinx
-- \   \   \/     Version            : 3.92
--  \   \         Application        : MIG
--  /   /         Filename           : dp_mem_infrastructure.vhd
-- /___/   /\     Date Last Modified : $Date: 2011/06/02 07:16:56 $
-- \   \  /  \    Date Created       : Jul 03 2009
--  \___\/\___\
--
--Device           : Spartan-6
--Design Name      : DDR/DDR2/DDR3/LPDDR
--Purpose          : Clock generation/distribution and reset synchronization
--Reference        :
--Revision History :
--*****************************************************************************
library ieee;
use ieee.std_logic_1164.all;
library unisim;
use unisim.vcomponents.all;

entity dp_mem_infrastructure is
  generic (
		hasDram: integer := 1;
		simulation: integer := 0;
		trace: integer := 1  -- use chipscope
  );
port
(
    clkIn       	: in std_logic;		-- 100 MHz input
    clkSys      	: out std_logic;		-- 100 MHz constantly running
	 stopCpu			: in std_logic;		-- stops cpu clock
    clkCpu      	: out std_logic;		-- 100 MHz gated
    clk125        : out std_logic;		-- 120M Hz 
    clkDrp        : out std_logic;		-- 50M Hz 
    clkMem2x    	: out std_logic;		-- 500 MHz
    clkMem2x180 	: out std_logic;		-- 500 MHz
    memPll_ce_0 	: out std_logic;		-- 
    memPll_ce_90  : out std_logic;
    memPll_lock   : out std_logic;
	 
    extRstIn_n	   : in std_logic;	-- from switch
    intRstIn	   : in std_logic;	-- from chipscope
    areset        : out std_logic;	-- early reset, clocked with input clock
    dreset        : out std_logic	-- delayed, synchronous reset
	 
);
end entity;
architecture syn of dp_mem_infrastructure is

	component mcsPll_500_125_100_50
	port
	 (-- Clock in ports
	  CLK_IN           : in     std_logic;
	  CLKFB_IN          : in     std_logic;
	  -- Clock out ports
	  CLK_500          : out    std_logic;
	  CLK_500_n          : out    std_logic;
	  CLK_125          : out    std_logic;
	  CLK_100s          : out    std_logic;
	  CLK_100c          : out    std_logic;
	  CLK_50_CE       : in     std_logic;
	  CLK_50          : out    std_logic;
	  CLKFB_OUT         : out    std_logic;
	  -- Status and control signals
	  RESET             : in     std_logic;
	  LOCKED            : out    std_logic
	 );
	end component;

	component mcsPll_600_125_100_50
	port
	 (-- Clock in ports
	  CLK_IN           : in     std_logic;
	  CLKFB_IN          : in     std_logic;
	  -- Clock out ports
	  CLK_500          : out    std_logic;
	  CLK_500_n          : out    std_logic;
	  CLK_125          : out    std_logic;
	  CLK_100s          : out    std_logic;
	  CLK_100c          : out    std_logic;
	  CLK_50_CE       : in     std_logic;
	  CLK_50          : out    std_logic;
	  CLKFB_OUT         : out    std_logic;
	  -- Status and control signals
	  RESET             : in     std_logic;
	  LOCKED            : out    std_logic
	 );
	end component;

	component mcsPll_600_125_50_50
	port
	 (-- Clock in ports
	  CLK_IN           : in     std_logic;
	  CLKFB_IN          : in     std_logic;
	  -- Clock out ports
	  CLK_500          : out    std_logic;
	  CLK_500_n          : out    std_logic;
	  CLK_125          : out    std_logic;
	  CLK_100s          : out    std_logic;
	  CLK_100c          : out    std_logic;
	  CLK_50_CE       : in     std_logic;
	  CLK_50          : out    std_logic;
	  CLKFB_OUT         : out    std_logic;
	  -- Status and control signals
	  RESET             : in     std_logic;
	  LOCKED            : out    std_logic
	 );
	end component;

signal extRstIn: std_logic;

signal CLK_IN          :     std_logic;
signal CLK_500         :     std_logic;
signal CLK_500_n       :    std_logic;
signal CLK_100s        :     std_logic;
signal CLK_100c        :     std_logic;
signal CLK_50          :      std_logic;
signal CLKFB           :     std_logic;

signal pll_LOCKED      :     std_logic;
signal bufpll_LOCKED   :     std_logic;
	 
signal localRst        :      std_logic;
signal localClk        :     std_logic;

constant RST_SYNC_NUM   : integer := 25;
signal   rstDelay   : std_logic_vector(RST_SYNC_NUM-1 downto 0);

begin 

	extRstIn <= not extRstIn_n;
	
	inClkBuf: bufg port map (i => clkIn, o => CLK_IN);

	-- clkGen : mcsPll_500_125_100_50
	clkGen : mcsPll_600_125_100_50
	  port map
		(-- Clock in ports
		 CLK_IN => clk_in,
		 CLKFB_IN => CLKFB,
		 -- Clock out ports
		 CLK_500 => CLK_500,
		 CLK_500_n => CLK_500_n,
		 CLK_125 => clk125,
		 CLK_100s => CLK_100s,
		 CLK_100c => CLK_100c,
		 CLK_50_CE => pll_LOCKED, --CLK_50_CE,
		 CLK_50 => CLK_50,
		 CLKFB_OUT => CLKFB,
		 -- Status and control signals
		 RESET  => extRstIn,
		 LOCKED => pll_LOCKED);

	sysClkBuf: bufg port map (i => CLK_100s, o => localClk);
	clkSys <= localClk;
	
	clkDrp <= CLK_50;

	withTace: if trace /= 0 generate
	begin
		cpuClkBuf: bufgmux port map (s => stopCpu, i0 => CLK_100c, i1 => '0', o => clkCpu);
	end generate;
	
	noTace: if trace = 0 generate
	begin
		clkCpu <= localClk;
	end generate;

	------------------------------------------------------------

	-- generate internal reset until drp clock running
	-- do not reset MCM from chipscope (intreset)
	process (CLK_50, extRstIn)
	begin
		if(extRstIn = '1') then
			localRst <= '1';
		elsif (CLK_50'event and CLK_50 = '1') then
			if (bufpll_locked = '1') then
				localRst <= '0';
			end if;
		end if;
	end process;      
	
	areset <= localRst;
		
	-- synchonisze output reset with system clock with minimal duration
   process (localClk, extRstIn, intRstIn, localRst)
   begin
      if (intRstIn = '1') or (localRst = '1') then
         rstDelay <= (others => '1');		-- reset active
      elsif (localClk'event and localClk = '1') then
			rstDelay <= rstDelay(RST_SYNC_NUM-2 downto 0) & '0';  -- logical left shift by one (pads with 0)
      end if;
   end process;      

	dreset <= rstDelay(RST_SYNC_NUM - 1); -- use MSB as reset

	------------------------------------------------------------
	
	withDram: if hasDram /= 0 generate
	begin
	
		BUFPLL_MCB_INST : BUFPLL_MCB
		port map
		( IOCLK0         => clkMem2x,	
		  IOCLK1         => clkMem2x180, 
		  LOCKED         => pll_locked,
		  GCLK           => CLK_50,
		  SERDESSTROBE0  => memPll_ce_0, 
		  SERDESSTROBE1  => memPll_ce_90, 
		  PLLIN0         => CLK_500,  
		  PLLIN1         => CLK_500_n,
		  LOCK           => bufpll_locked 
		  );

		memPll_lock <= bufpll_locked;
	
	end generate;
	
	

end architecture syn;

