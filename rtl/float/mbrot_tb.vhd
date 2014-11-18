--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   14:35:40 10/01/2013
-- Design Name:   
-- Module Name:   /home/kugel/daten/work/vhdl/mbIp/sp6/rtl/float/mbrot_tb.vhd
-- Project Name:  fltest
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: mbrot
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_arith.ALL;
use IEEE.math_real.all;
 
ENTITY mbrot_tb IS
END mbrot_tb;
 
ARCHITECTURE behavior OF mbrot_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT mbrot
    PORT(
         cx : IN  std_logic_vector(31 downto 0);
         cy : IN  std_logic_vector(31 downto 0);
         nmax : IN  std_logic_vector(7 downto 0);
         n : OUT  std_logic_vector(7 downto 0);
         done : OUT  std_logic;
         clk : IN  std_logic;
         rst : IN  std_logic
        );
    END COMPONENT;
    

   --Inputs
--   signal cx : std_logic_vector(31 downto 0) := X"40200000"; -- +2.5 --(others => '0');
--   signal cy : std_logic_vector(31 downto 0) := X"bfc00000"; -- -1.5 -- (others => '0');
   signal cx : std_logic_vector(31 downto 0) := (others => '0'); -- = float 0
   signal cy : std_logic_vector(31 downto 0) := (others => '0');
   signal nmax : std_logic_vector(7 downto 0) := X"3f";
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';

 	--Outputs
   signal n : std_logic_vector(7 downto 0);
   signal done : std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;


BEGIN
 

	-- Instantiate the Unit Under Test (UUT)
   uut: mbrot PORT MAP (
          cx => cx,
          cy => cy,
          nmax => nmax,
          n => n,
          done => done,
          clk => clk,
          rst => rst
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
		rst <= '1';
		wait until rising_edge(clk);
		wait until rising_edge(clk);
		wait until rising_edge(clk);
		wait until rising_edge(clk);
		wait until rising_edge(clk);
		wait until rising_edge(clk);
		rst <= '0';
		cx <= X"40200000"; -- +2.5 --(others => '0');
		cy <= X"bfc00000"; -- -1.5 -- (others => '0');

		wait until rising_edge(clk);
		wait until done = '1';

		wait until rising_edge(clk);
		rst <= '1';
		wait until rising_edge(clk);
		rst <= '0';
		cx <= X"bddd2f18"; -- +2.5 --(others => '0');
		cy <= X"bf743958"; -- -1.5 -- (others => '0');
		wait until rising_edge(clk);
		wait until done = '1';

		wait until rising_edge(clk);
		rst <= '1';
		wait until rising_edge(clk);
		rst <= '0';
		cx <= X"bdd0e560"; -- +2.5 --(others => '0');
		cy <= X"bf743958"; -- -1.5 -- (others => '0');
		wait until rising_edge(clk);
		wait until done = '1';

		wait until rising_edge(clk);
		rst <= '1';
		wait until rising_edge(clk);
		rst <= '0';
		cx <= X"bde978d8"; -- +2.5 --(others => '0');
		cy <= X"bf743958"; -- -1.5 -- (others => '0');
		wait until rising_edge(clk);
		wait until done = '1';

		wait until rising_edge(clk);
		rst <= '1';
		wait until rising_edge(clk);
		rst <= '0';
		cx <= X"bd9fbe78"; -- +2.5 --(others => '0');
		cy <= X"bf75c290"; -- -1.5 -- (others => '0');
		wait until rising_edge(clk);
		wait until done = '1';

		wait until rising_edge(clk);
		rst <= '1';
		wait until rising_edge(clk);
		rst <= '0';
		cx <= X"bddd2f18"; -- +2.5 --(others => '0');
		cy <= X"bf75c290"; -- -1.5 -- (others => '0');
		wait until rising_edge(clk);
		wait until done = '1';

		wait until rising_edge(clk);
		rst <= '1';
		wait until rising_edge(clk);
		rst <= '0';
		cx <= X"be1374bc"; -- +2.5 --(others => '0');
		cy <= X"bf75c290"; -- -1.5 -- (others => '0');
		wait until rising_edge(clk);
		wait until done = '1';


		wait until rising_edge(clk);

		wait;
		-- wait until rising_edge(clk);

	
   end process;

-- examples
--bddd2f18 bf743958:11
--be1374bc bf75c290:b
--bddd2f18 bf75c290:21
--bd9fbe78 bf75c290:f
--bde978d8 bf743958:e
--bdd0e560 bf743958:26

--bddd2f18 bf743958 (-0.108000, -0.954000) :11
--be1374bc bf75c290 (-0.144000, -0.960000) :b
--bddd2f18 bf75c290 (-0.108000, -0.960000) :21
--bd9fbe78 bf75c290 (-0.078000, -0.960000) :f
--bde978d8 bf743958 (-0.114000, -0.954000) :e
--bdd0e560 bf743958 (-0.102000, -0.954000) :26
--3bc49b80 bf558106 (0.006000, -0.834000) :11
--3c449bc0 bf558106 (0.012000, -0.834000) :e
--3c9374c0 bf558106 (0.018000, -0.834000) :c
--3cc49ba0 bf558106 (0.024000, -0.834000) :b
--bfcb851f 3bc49ba6 (-1.590000, 0.006000) :c
--bfcac083 3bc49ba6 (-1.584000, 0.006000) :c
--bfc9fbe8 3bc49ba6 (-1.578000, 0.006000) :f
--bfc9374c 3bc49ba6 (-1.572000, 0.006000) :e
--bfc872b0 3bc49ba6 (-1.566000, 0.006000) :c
--3e8d4fe0 3bc49ba6 (0.276000, 0.006000) :15
--3e906250 3bc49ba6 (0.282000, 0.006000) :11
--3e9374bc 3bc49ba6 (0.288000, 0.006000) :f
--3e96872c 3bc49ba6 (0.294000, 0.006000) :d
--3e999998 3bc49ba6 (0.300000, 0.006000) :c
--3e9cac08 3bc49ba6 (0.306000, 0.006000) :c
--

END;
