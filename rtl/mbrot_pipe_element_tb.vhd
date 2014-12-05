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
      clear    <= '0';
      valid_in <= '1';
      cy       <= "00111101110011001100110011001101"; -- float 0.1
      zy_in    <= "00111101110011001100110011001101"; -- float 0.1
      
      -- INPUT
      
      cx       <= "00111101110011001100110011001101"; -- float 0.1
      zx_in    <= "00111101110011001100110011001101"; -- float 0.1
      
      wait for clk_period;
      assert valid_out = '0' report "valid_out must be false after 1 cycle!";
      cx       <= "00111110010011001100110011001101"; -- float 0.2
      zx_in    <= "00111110010011001100110011001101"; -- float 0.2
      
      wait for clk_period;
      assert valid_out = '0' report "valid_out must be false after 2 cycles!";
      cx       <= "00111110110011001100110011001101"; -- float 0.4
      zx_in    <= "00111110110011001100110011001101"; -- float 0.4
      
      wait for clk_period;
      assert valid_out = '0' report "valid_out must be false after 3 cycles!";
      cx       <= "00111111010011001100110011001101"; -- float 0.8
      zx_in    <= "00111111010011001100110011001101"; -- float 0.8
      
      wait for clk_period;
      assert valid_out = '0' report "valid_out must be false after 4 cycles!";
      cx       <= "00111111110011001100110011001101"; -- float 1.6
      zx_in    <= "00111111110011001100110011001101"; -- float 1.6
      
      wait for clk_period;
      assert valid_out = '0' report "valid_out must be false after 5 cycles!";
      cx       <= "01000000010011001100110011001101"; -- float 3.2
      zx_in    <= "01000000010011001100110011001101"; -- float 3.2
      
      wait for clk_period;
      assert valid_out = '0' report "valid_out must be false after 6 cycles!";
      cx       <= "01000000110011001100110011001101"; -- float 6.4
      zx_in    <= "01000000110011001100110011001101"; -- float 6.4
      
      wait for clk_period;
      assert valid_out = '0' report "valid_out must be false after 7 cycles!";
      cx       <= "01000001010011001100110011001101"; -- float 12.8
      zx_in    <= "01000001010011001100110011001101"; -- float 12.8
      
      wait for clk_period;
      assert valid_out = '0' report "valid_out must be false after 8 cycles!";
      cx       <= "01000001110011001100110011001101"; -- float 25.6
      zx_in    <= "01000001110011001100110011001101"; -- float 25.6
      
      -- OUTPUT
      
      wait for clk_period; -- 0.1
      assert zx_out = "00111101110011001100110011001101" report "zx_out must be 0.1 after 9 cycles!";
      assert zy_out = "00111101111101011100001010010000" report "zy_out must be 0.12 after 9 cycles!";
                       
      assert compare   = '1' report "compare must be true after 9 cycles!";
      assert valid_out = '1' report "valid_out must be true after 9 cycles!";
      
      wait for clk_period; -- 0.2
      assert zx_out = "00111110011010111000010100011111" report "zx_out must be 0.23 after 10 cycles!";
      assert zy_out = "00111110000011110101110000101001" report "zy_out must be 0.14 after 10 cycles!";
      assert compare   = '1' report "compare must be true after 10 cycles!";
      assert valid_out = '1' report "valid_out must be true after 10 cycles!";
      
      wait for clk_period; -- 0.4
      assert zx_out = "00111111000011001100110011001101" report "zx_out must be 0.55 after 11 cycles!";
      assert zy_out = "00111110001110000101000111101100" report "zy_out must be 0.18 after 11 cycles!";
      assert compare   = '1' report "compare must be true after 11 cycles!";
      assert valid_out = '1' report "valid_out must be true after 11 cycles!";
      
      wait for clk_period; -- 0.8
      assert zx_out = "00111111101101110000101000111110" report "zx_out must be 1.43 after 12 cycles!";
      assert zy_out = "00111110100001010001111010111001" report "zy_out must be 0.26 after 12 cycles!";
      assert compare   = '1' report "compare must be true after 12 cycles!";
      assert valid_out = '1' report "valid_out must be true after 12 cycles!";
      
      wait for clk_period; -- 1.6
      assert zx_out = "01000000100001001100110011001101" report "zx_out must be 4.15 after 13 cycles!";
      assert zy_out = "00111110110101110000101000111110" report "zy_out must be 0.42 after 13 cycles!";
      assert compare   = '0' report "compare must be false after 13 cycles!";
      assert valid_out = '1' report "valid_out must be true after 13 cycles!";
      
      wait for clk_period; -- 3.2
      assert zx_out = "01000001010101101110000101001000" report "zx_out must be 13.43 after 14 cycles!";
      assert zy_out = "00111111001111010111000010100101" report "zy_out must be 0.74 after 14 cycles!";
      assert compare   = '0' report "compare must be false after 14 cycles!";
      assert valid_out = '1' report "valid_out must be true after 14 cycles!";
      
      wait for clk_period; -- 6.4
      assert zx_out = "01000010001111010110011001101000" report "zx_out must be 47.35 after 15 cycles!";
      assert zy_out = "00111111101100001010001111011000" report "zy_out must be 1.38 after 15 cycles!";
      assert compare   = '0' report "compare must be false after 15 cycles!";
      assert valid_out = '1' report "valid_out must be true after 15 cycles!";
      
      wait for clk_period; -- 12.8
      assert zx_out = "01000011001100001010000101001001" report "zx_out must be 176.63 after 16 cycles!";
      assert zy_out = "01000000001010100011110101110001" report "zy_out must be 2.66 after 16 cycles!";
      assert compare   = '0' report "compare must be false after 16 cycles!";
      assert valid_out = '1' report "valid_out must be true after 16 cycles!";
      
      wait for clk_period; -- 25.6
      assert zx_out = "01000100001010100011110011001101" report "zx_out must be 680.95 after 17 cycles!";
      assert zy_out = "01000000101001110000101000111110" report "zy_out must be 5.22 after 17 cycles!";
      assert compare   = '0' report "compare must be false after 17 cycles!";
      assert valid_out = '1' report "valid_out must be true after 17 cycles!";

      wait;
   end process;

END;
