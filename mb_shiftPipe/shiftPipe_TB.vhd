--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   00:05:45 11/27/2014
-- Design Name:   
-- Module Name:   /home/fel/Uni/FPGA/mb_shiftPipe/shiftPipe_TB.vhd
-- Project Name:  shiftPipe
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: shiftPipe
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
 
ENTITY shiftPipe_TB IS
END shiftPipe_TB;
 
ARCHITECTURE behavior OF shiftPipe_TB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT shiftPipe
	generic (width: integer := 4; depth: integer := 16);
	port
	(
		clk, reset:	in std_logic;
		iCmpVector:	in std_logic_vector(depth-1 downto 0);
		iValid:		in std_logic;
		
		oColor:		out std_logic_vector(width-1 downto 0);
		oValid:		out std_logic
	);
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';
   signal iCmpVector : std_logic_vector(15 downto 0) := (others => '0');
   signal iValid : std_logic := '0';

 	--Outputs
   signal oColor : std_logic_vector(3 downto 0);
   signal oValid : std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: shiftPipe
   generic map (width => 4, depth => 16)
   PORT MAP (
          clk => clk,
          reset => reset,
          iCmpVector => iCmpVector,
          iValid => iValid,
          oColor => oColor,
          oValid => oValid
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

		reset <= '1';
		iValid <= '0';
		iCmpVector <= (others => '0');
		wait for clk_period*100;
		wait until rising_edge(clk);

		reset <= '0';
		wait for clk_period*100;

		iValid <= '1';
		for i in 0 to 15 loop
		--iCmpVector <= std_logic_vector(to_unsigned(i, iCmpVector'length));
		iCmpVector <= X"0001";
		wait for clk_period*9;
		end loop;
	  
		iValid <= '0';
		iCmpVector <= X"0000";

	wait;
	end process;

END;
