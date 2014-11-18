--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   11:26:09 09/11/2013
-- Design Name:   
-- Module Name:   /home/kugel/daten/work/vhdl/mbIp/sp6/sim/mcs_top_tb.vhd
-- Project Name:  mcs_top
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: mcs_top
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
 
library unisim;
use unisim.vcomponents.all;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
USE ieee.numeric_std.ALL;
use ieee.std_logic_unsigned.all;
 
ENTITY mcs_top_tb IS
END mcs_top_tb;
 
ARCHITECTURE behavior OF mcs_top_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT mcs_top
	  generic (
			hasDram: integer := 1;
			simulation: integer := 0;
			trace: integer := 0
	  );
    PORT(
         Clk : IN  std_logic;
         Rst_n : IN  std_logic;
         UART_Rx : IN  std_logic;
			 ----- DRAM ports -------------------
			mcb3_dram_ck          : out std_logic;
			mcb3_dram_ck_n        : out std_logic;
			mcb3_dram_a           : out std_logic_vector(12 downto 0);
			mcb3_dram_ba          : out std_logic_vector(2 downto 0);
			mcb3_dram_ras_n       : out std_logic;
			mcb3_dram_cas_n       : out std_logic;
			mcb3_dram_we_n        : out std_logic;
			mcb3_dram_odt         : out std_logic;
			mcb3_dram_cke         : out std_logic;
			mcb3_dram_dq          : inout std_logic_vector(15 downto 0);
			mcb3_dram_dqs         : inout std_logic;
			mcb3_dram_dqs_n : inout std_logic;
			mcb3_dram_udqs   : inout std_logic;
			mcb3_dram_udm    : out std_logic; 
			mcb3_dram_udqs_n : inout std_logic;
			mcb3_dram_dm : out std_logic;
			mcb3_rzq                             : inout std_logic;
			mcb3_zio                              : inout std_logic;
			----- HDMI out ports ---------------
			hdmiTx0_p : OUT std_logic;
			hdmiTx0_n : OUT std_logic;
			hdmiTx1_p : OUT std_logic;
			hdmiTx1_n : OUT std_logic;
			hdmiTx2_p : OUT std_logic;
			hdmiTx2_n : OUT std_logic;
			hdmiTx3_p : OUT std_logic;
			hdmiTx3_n : OUT std_logic;
			----- HDMI in ports ----------------
			hdmiRx_p : IN std_logic_vector(3 downto 0);
			hdmiRx_n : IN std_logic_vector(3 downto 0);
			------------------------------------
         UART_Tx : OUT  std_logic;
         GPO1 : OUT  std_logic_vector(7 downto 0);
         GPI1 : IN  std_logic_vector(7 downto 0);
         GPI2 : IN  std_logic_vector(4 downto 0)
        );
    END COMPONENT;
    
	 constant hasDram: integer:= 1;

   --Inputs
   signal Clk : std_logic := '0';
   signal Rst_n : std_logic := '0';
   signal UART_Rx : std_logic := '0';
   signal GPI1 : std_logic_vector(7 downto 0) := (0 => '1', others => '0');
   signal GPI2 : std_logic_vector(4 downto 0) := (others => '0');

 	--Outputs
   signal UART_Tx : std_logic;
   signal GPO1 : std_logic_vector(7 downto 0);

   -- Clock period definitions
   constant Clk_period : time := 10 ns;
	
	-------------------------------------
	-- memory stuff ----------
	-------------------------------------
   component ddr2_model_c3 is
    port (
      ck      : in    std_logic;
      ck_n    : in    std_logic;
      cke     : in    std_logic;
      cs_n    : in    std_logic;
      ras_n   : in    std_logic;
      cas_n   : in    std_logic;
      we_n    : in    std_logic;
      dm_rdqs : inout std_logic_vector(1 downto 0);
      ba      : in    std_logic_vector(2 downto 0);
      addr    : in    std_logic_vector(12 downto 0);
      dq      : inout std_logic_vector(15 downto 0);
      dqs     : inout std_logic_vector(1 downto 0);
      dqs_n   : inout std_logic_vector(1 downto 0);
      rdqs_n  : out   std_logic_vector(1 downto 0);
      odt     : in    std_logic
      );
  end component;
	
	-- Design-Top Port Map   
   signal mcb3_dram_a : std_logic_vector(12 downto 0);
   signal mcb3_dram_ba : std_logic_vector(2 downto 0);  

   signal  mcb3_dram_ck : std_logic;  
   signal  mcb3_dram_ck_n : std_logic;  
   signal  mcb3_dram_dq : std_logic_vector(15 downto 0);   
   signal  mcb3_dram_dqs   : std_logic;
   signal  mcb3_dram_dqs_n : std_logic;
   signal  mcb3_dram_dm    : std_logic;   
   signal  mcb3_dram_ras_n : std_logic;   
   signal  mcb3_dram_cas_n : std_logic;   
   signal  mcb3_dram_we_n  : std_logic;    
   signal  mcb3_dram_cke   : std_logic;   
   signal  mcb3_dram_odt   : std_logic;  


   signal  mcb3_dram_udqs   : std_logic;
   signal  mcb3_dram_udqs_n : std_logic;
   signal mcb3_dram_dqs_vector : std_logic_vector(1 downto 0);
   signal mcb3_dram_dqs_n_vector : std_logic_vector(1 downto 0);
   signal   mcb3_dram_udm :std_logic;     -- for X16 parts
   signal mcb3_dram_dm_vector : std_logic_vector(1 downto 0);

   signal mcb3_command               : std_logic_vector(2 downto 0);
   signal mcb3_enable1                : std_logic;
   signal mcb3_enable2              : std_logic;

   signal  rzq3     : std_logic;
   signal  zio3     : std_logic;
	

----- HDMI out ports ---------------
   signal  hdmiTx0_p :  std_logic;
   signal  hdmiTx0_n :  std_logic;
   signal  hdmiTx1_p :  std_logic;
   signal  hdmiTx1_n :  std_logic;
   signal  hdmiTx2_p :  std_logic;
   signal  hdmiTx2_n :  std_logic;
   signal  hdmiTx3_p :  std_logic;
   signal  hdmiTx3_n :  std_logic;

signal hdmiRx_p : std_logic_vector(3 downto 0);
signal hdmiRx_n : std_logic_vector(3 downto 0);



  --------------------------------------------------------
  

BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: mcs_top 
	generic map (hasDram => hasDram, simulation => 1, trace => 0)
	PORT MAP (
          Clk => Clk,
          Rst_n => Rst_n,
			 ------------------------------
			mcb3_dram_dq     =>      mcb3_dram_dq,  
			mcb3_dram_a      =>      mcb3_dram_a,  
			mcb3_dram_ba     =>      mcb3_dram_ba,
			mcb3_dram_ras_n  =>      mcb3_dram_ras_n,                        
			mcb3_dram_cas_n  =>      mcb3_dram_cas_n,                        
			mcb3_dram_we_n   =>      mcb3_dram_we_n,                          
			mcb3_dram_odt    =>      mcb3_dram_odt,
			mcb3_dram_cke    =>      mcb3_dram_cke,                          
			mcb3_dram_ck     =>      mcb3_dram_ck,                          
			mcb3_dram_ck_n   =>      mcb3_dram_ck_n,       
			mcb3_dram_dqs_n  =>      mcb3_dram_dqs_n,
			mcb3_dram_udqs  =>       mcb3_dram_udqs,    -- for X16 parts           
			mcb3_dram_udqs_n    =>   mcb3_dram_udqs_n,  -- for X16 parts
			mcb3_dram_udm  =>        mcb3_dram_udm,     -- for X16 parts
			mcb3_dram_dm  =>       mcb3_dram_dm,
			mcb3_rzq        =>            rzq3,
			mcb3_zio        =>            zio3,
			mcb3_dram_dqs    =>      mcb3_dram_dqs,
			 ------------------------------
			hdmiTx0_p => hdmiTx0_p,
			hdmiTx0_n => hdmiTx0_n,
			hdmiTx1_p => hdmiTx1_p,
			hdmiTx1_n => hdmiTx1_n,
			hdmiTx2_p => hdmiTx2_p,
			hdmiTx2_n => hdmiTx2_n,
			hdmiTx3_p => hdmiTx3_p,
			hdmiTx3_n => hdmiTx3_n,
			 ------------------------------
			 hdmiRx_p => hdmiRx_p,
			 hdmiRx_n => hdmiRx_n,
			 ------------------------------
          UART_Rx => UART_Rx,
          UART_Tx => UART_Tx,
          GPO1 => GPO1,
          GPI1 => GPI1,
          GPI2 => GPI2
        );

	hdmiRx_p(0) <= hdmiTx0_p;
	hdmiRx_p(1) <= hdmiTx1_p;
	hdmiRx_p(2) <= hdmiTx2_p;
	hdmiRx_p(3) <= hdmiTx3_p;

	hdmiRx_n(0) <= hdmiTx0_n;
	hdmiRx_n(1) <= hdmiTx1_n;
	hdmiRx_n(2) <= hdmiTx2_n;
	hdmiRx_n(3) <= hdmiTx3_n;
	
   -- Clock process definitions
   Clk_process :process
   begin
		Clk <= '0';
		wait for Clk_period/2;
		Clk <= '1';
		wait for Clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
		rst_n <= '0';
      wait for 100 ns;	
		rst_n <= '1';

      wait for Clk_period*10;

      -- insert stimulus here 

		wait for 50 us;
		
		rst_n <= '0';
      wait for 2 us ;	
		rst_n <= '1';

      wait for Clk_period*10;

      wait;
   end process;

	-- memory stuff --------
	withDram: if hasDram /= 0 generate
	begin
		-- The PULLDOWN component is connected to the ZIO signal primarily to avoid the
			-- unknown state in simulation. In real hardware, ZIO should be a no connect(NC) pin.
		zio_pulldown3 : PULLDOWN port map(O => zio3);
		rzq_pulldown3 : PULLDOWN port map(O => rzq3);

-- ========================================================================== --
-- Memory model instances                                                     -- 
-- ========================================================================== --

    mcb3_command <= (mcb3_dram_ras_n & mcb3_dram_cas_n & mcb3_dram_we_n);

    process(mcb3_dram_ck)
    begin
      if (rising_edge(mcb3_dram_ck)) then
        if (rst_n = '0') then
          mcb3_enable1   <= '0';
          mcb3_enable2 <= '0';
        elsif (mcb3_command = "100") then
          mcb3_enable2 <= '0';
        elsif (mcb3_command = "101") then
          mcb3_enable2 <= '1';
        else
          mcb3_enable2 <= mcb3_enable2;
        end if;
        mcb3_enable1     <= mcb3_enable2;
      end if;
    end process;

-----------------------------------------------------------------------------
--read
-----------------------------------------------------------------------------
    mcb3_dram_dqs_vector(1 downto 0)               <= (mcb3_dram_udqs & mcb3_dram_dqs)
                                                           when (mcb3_enable2 = '0' and mcb3_enable1 = '0')
							   else "ZZ";
    mcb3_dram_dqs_n_vector(1 downto 0)             <= (mcb3_dram_udqs_n & mcb3_dram_dqs_n)
                                                           when (mcb3_enable2 = '0' and mcb3_enable1 = '0')
							   else "ZZ";
    
-----------------------------------------------------------------------------
--write
-----------------------------------------------------------------------------
    mcb3_dram_dqs          <= mcb3_dram_dqs_vector(0)
                              when ( mcb3_enable1 = '1') else 'Z';

    mcb3_dram_udqs          <= mcb3_dram_dqs_vector(1)
                              when (mcb3_enable1 = '1') else 'Z';


     mcb3_dram_dqs_n        <= mcb3_dram_dqs_n_vector(0)
                              when (mcb3_enable1 = '1') else 'Z';
    mcb3_dram_udqs_n         <= mcb3_dram_dqs_n_vector(1)
                              when (mcb3_enable1 = '1') else 'Z';

   
   
mcb3_dram_dm_vector <= (mcb3_dram_udm & mcb3_dram_dm);

     u_mem_c3 : ddr2_model_c3 port map(
        ck        => mcb3_dram_ck,
        ck_n      => mcb3_dram_ck_n,
        cke       => mcb3_dram_cke,
        cs_n      => '0',
        ras_n     => mcb3_dram_ras_n,
        cas_n     => mcb3_dram_cas_n,
        we_n      => mcb3_dram_we_n,
        dm_rdqs   => mcb3_dram_dm_vector ,
        ba        => mcb3_dram_ba,
        addr      => mcb3_dram_a,
        dq        => mcb3_dram_dq,
        dqs       => mcb3_dram_dqs_vector,
        dqs_n     => mcb3_dram_dqs_n_vector,
        rdqs_n    => open,
        odt       => mcb3_dram_odt
      );

	end generate;  -- dram

	-------------------------------------

END;
