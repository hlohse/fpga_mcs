--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   16:49:16 12/04/2014
-- Design Name:   
-- Module Name:   /home/fel/Desktop/mcs/rtl/mbrot_pipe_tb.vhd
-- Project Name:  mcs
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: mbrot_pipe
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
 
ENTITY mbrot_pipe_tb IS
END mbrot_pipe_tb;
 
ARCHITECTURE behavior OF mbrot_pipe_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT mbrot_pipe
    PORT(
         clk:       IN   std_logic;
         reset:     IN   std_logic;
         clear:     IN   std_logic;
         valid_in:  IN   std_logic;
         cx:        IN   std_logic_vector(31 downto 0);
         cy:        IN   std_logic_vector(31 downto 0);
         zx:        OUT  std_logic_vector(31 downto 0);
         zy:        OUT  std_logic_vector(31 downto 0);
         valid_out: OUT  std_logic;
         compare:   OUT  std_logic_vector(15 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk:       std_logic := '0';
   signal reset:     std_logic := '0';
   signal clear:     std_logic := '0';
   signal valid_in:  std_logic := '0';
   signal cx:        std_logic_vector(31 downto 0) := (others => '0');
   signal cy:        std_logic_vector(31 downto 0) := (others => '0');

 	--Outputs
   signal zx:        std_logic_vector(31 downto 0);
   signal zy:        std_logic_vector(31 downto 0);
   signal valid_out: std_logic;
   signal compare:   std_logic_vector(15 downto 0);

   -- Clock period definitions
   constant clk_period: time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: mbrot_pipe PORT MAP (
          clk       => clk,
          reset     => reset,
          clear     => clear,
          valid_in  => valid_in,
          cx        => cx,
          cy        => cy,
          zx        => zx,
          zy        => zy,
          valid_out => valid_out,
          compare   => compare
        );

   -- Clock process definitions
   clk_process :process
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
      clear    <= '0';
      valid_in <= '1';
      cy       <= "00111101110011001100110011001101"; -- float 0.1
      
      -- INPUT
      cx <= "00111101110011001100110011001101"; -- float 0.1
      wait for clk_period;
      cx <= "00111110010011001100110011001101"; -- float 0.2
      wait for clk_period;
      cx <= "00111110110011001100110011001101"; -- float 0.4
      wait for clk_period;
      cx <= "00111111010011001100110011001101"; -- float 0.8
      wait for clk_period;
      cx <= "00111111110011001100110011001101"; -- float 1.6
      wait for clk_period;
      cx <= "01000000010011001100110011001101"; -- float 3.2
      wait for clk_period;
      cx <= "01000000110011001100110011001101"; -- float 6.4
      wait for clk_period;
      cx <= "01000001010011001100110011001101"; -- float 12.8
      wait for clk_period;
      cx <= "01000001110011001100110011001101"; -- float 25.6
      wait for clk_period;
      valid_in <= '0';
      
      wait for (15*9 - 1)*clk_period;
      assert valid_out = '0' report "valid_out must be false after 143 cycles!";
      
      wait for clk_period;
      assert valid_out = '1' report "valid_out must be true after 144 cycles!";

      wait;
   end process;

END;
