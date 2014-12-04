--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   11:49:18 12/04/2014
-- Design Name:   
-- Module Name:   /home/fel/Desktop/mcs/mbrot_pipe_element_tb.vhd
-- Project Name:  mcs
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: mbrot_pipe_element
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
--USE ieee.numeric_std.ALL;
 
ENTITY mbrot_pipe_element_tb IS
END mbrot_pipe_element_tb;
 
ARCHITECTURE behavior OF mbrot_pipe_element_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT mbrot_pipe_element
    PORT(
         clk:       IN  std_logic;
         reset:     IN  std_logic;
         clear:     IN  std_logic;
         valid_in:  IN  std_logic;
         cx:        IN  std_logic_vector(31 downto 0);
         cy:        IN  std_logic_vector(31 downto 0);
         zx_in:     IN  std_logic_vector(31 downto 0);
         zy_in:     IN  std_logic_vector(31 downto 0);
         zx_out:    OUT  std_logic_vector(31 downto 0);
         zy_out:    OUT  std_logic_vector(31 downto 0);
         compare:   OUT  std_logic;
         valid_out: OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk:       std_logic := '0';
   signal reset:     std_logic := '0';
   signal clear:     std_logic := '0';
   signal valid_in:  std_logic := '0';
   signal cx:        std_logic_vector(31 downto 0) := (others => '0');
   signal cy:        std_logic_vector(31 downto 0) := (others => '0');
   signal zx_in:     std_logic_vector(31 downto 0) := (others => '0');
   signal zy_in:     std_logic_vector(31 downto 0) := (others => '0');

 	--Outputs
   signal zx_out:    std_logic_vector(31 downto 0);
   signal zy_out:    std_logic_vector(31 downto 0);
   signal compare:   std_logic;
   signal valid_out: std_logic;

   -- Clock period definitions
   constant clk_period: time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: mbrot_pipe_element PORT MAP (
          clk       => clk,
          reset     => reset,
          clear     => clear,
          valid_in  => valid_in,
          cx        => cx,
          cy        => cy,
          zx_in     => zx_in,
          zy_in     => zy_in,
          zx_out    => zx_out,
          zy_out    => zy_out,
          compare   => compare,
          valid_out => valid_out
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

      wait;
   end process;

END;
