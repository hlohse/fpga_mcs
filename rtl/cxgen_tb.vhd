--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   10:42:44 12/04/2014
-- Design Name:   
-- Module Name:   /home/fel/Desktop/mcs/rtl/cxgen_tb.vhd
-- Project Name:  mcs
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: cxgen
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
use ieee.numeric_std.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY cxgen_tb IS
END cxgen_tb;
 
ARCHITECTURE behavior OF cxgen_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT cxgen
    PORT(
         cx_min: IN   std_logic_vector(31 downto 0);
         dx:     IN   std_logic_vector(31 downto 0);
         enable: IN   std_logic;
         clear:  IN   std_logic;
         reset:  IN   std_logic;
         clk:    IN   std_logic;
         cx:     OUT  std_logic_vector(31 downto 0);
         valid:  OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal cx_min: std_logic_vector(31 downto 0) := (others => '0');
   signal dx:     std_logic_vector(31 downto 0) := (others => '0');
   signal enable: std_logic := '0';
   signal clear:  std_logic := '0';
   signal reset:  std_logic := '0';
   signal clk:    std_logic := '0';

 	--Outputs
   signal cx:     std_logic_vector(31 downto 0);
   signal valid:  std_logic;

   -- Clock period definitions
   constant clk_period: time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: cxgen PORT MAP (
          cx_min => cx_min,
          dx     => dx,
          enable => enable,
          clear  => clear,
          reset  => reset,
          clk    => clk,
          cx     => cx,
          valid  => valid
        );

   -- Clock process definitions
   clk_process: process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      reset <= '1';
      wait for 100 ns;	
      reset <= '0';
      wait for clk_period*10;

      -- insert stimulus here 
      
      cx_min <= "01000010110010000000000000000000"; -- float 100
      dx     <= "00111111110000000000000000000000"; -- float 1.5
      clear  <= '0';
      enable <= '1';
      
      wait for   1*clk_period;
      assert cx    = "00000000000000000000000000000000" report "CX after 1 cycle must be 0!";
      assert valid = '0' report "valid after 1 cycle must be false!";
      
      wait for  11*clk_period;
      assert cx    = "00000000000000000000000000000000" report "CX after 12 cycles must be 0!";
      assert valid = '0'report "valid after 12 cycles must be false!";
      
      wait for   1*clk_period;
      assert cx    = "01000010110010000000000000000000" report "CX after 13 cycles must be 100!";
      assert valid = '1' report "valid after 13 cycles must be true!";
      
      wait for   1*clk_period;
      assert cx = "01000010110010110000000000000000" report "CX after 14 cycles must be 101.5!";
      wait for   1*clk_period;
      assert cx = "01000010110011100000000000000000" report "CX after 15 cycles must be 103.0!";
      wait for   1*clk_period;
      assert cx = "01000010110100010000000000000000" report "CX after 16 cycles must be 104.5!";
      wait for   1*clk_period;
      assert cx = "01000010110101000000000000000000" report "CX after 17 cycles must be 106.0!";
      
      wait for 795*clk_period;
      assert cx = "01000100101000100101000000000000" report "CX after 812 cycles must be 1298.5!";
      wait for   1*clk_period;
      assert cx    = "00000000000000000000000000000000" report "CX after 813 cycles must be 0!";
      assert valid = '0'report "valid after 813 cycles must be false!";

      wait;
   end process;

END;
