--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   10:30:27 09/27/2013
-- Design Name:   
-- Module Name:   /home/kugel/daten/work/vhdl/mbIp/sp6/ise/fpTest_tb.vhd
-- Project Name:  mcs_top
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: fpTest
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

library std;
use std.textio.all;

-- fp simulation lib
LIBRARY ieee_proposed;
use ieee_proposed.float_pkg.all;  
 
 
ENTITY fpTest_tb IS
END fpTest_tb;
 
ARCHITECTURE behavior OF fpTest_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT fpTest
    PORT(
         in1 : IN  std_logic_vector(31 downto 0);
         in2 : IN  std_logic_vector(31 downto 0);
         in3 : IN  std_logic_vector(31 downto 0);
         in4 : IN  std_logic_vector(31 downto 0);
         out1 : OUT  std_logic_vector(31 downto 0);
         Clk : IN  std_logic;
         Rst : IN  std_logic
        );
    END COMPONENT;
    

   --Inputs
	type int16 is record 
		s: std_logic;
		i: std_logic_vector(14 downto 0);
		f: std_logic_vector(15 downto 0);
	end record;
	function to_std_logic_vector(i: in int16) return std_logic_vector is
	begin
		return i.s & i.i & i.f;
	end function;

	function to_int16(i: in std_logic_vector) return int16 is
		variable j: int16;
	begin
		j.s := i(31);
		j.i := i(30 downto 16);
		j.f := i(15 downto  0);
		return j;
	end function;
	
--   signal i1 : int16 := ('0', (others => '0'), X"0000");
--   signal i2 : int16 := ('0', (others => '0'), X"0000");
--   signal i3 : int16 := ('0', (others => '0'), X"0000");
--   signal i4 : int16 := ('0', (others => '0'), X"0000");
   signal Clk : std_logic := '0';
   signal Rst : std_logic := '0';
   signal i1 : real := 0.0;
   signal i2 : real := 0.0;
   signal i3 : real := 0.0;
   signal i4 : real := 0.0;
   signal inf1 : float32;
   signal inf2 : float32;
   signal inf3 : float32;
   signal inf4 : float32;
   signal in1 : std_logic_vector(31 downto 0) := (others => '0');
   signal in2 : std_logic_vector(31 downto 0) := (others => '0');
   signal in3 : std_logic_vector(31 downto 0) := (others => '0');
   signal in4 : std_logic_vector(31 downto 0) := (others => '0');

 	--Outputs
   signal out1 : std_logic_vector(31 downto 0);
	signal outf1: float32;
	signal o1: real;

	signal fm1, fa1, fs1, eval: real;
	signal fc1: boolean;

   -- Clock period definitions
   constant Clk_period : time := 10 ns;
 
 
BEGIN

	evalProc: process (i1, i2, i3, i4, fm1, fa1, fs1)
	begin
		fm1 <= i1 * i2;
		fa1 <= fm1 + i4;
		fs1 <= fm1 - i3;
		fc1 <= fa1 < fs1;
		-- eval <= fa1;
		if fc1 then 
			eval <= fa1;
		else 
			eval <= fs1;
		end if;
	end process;
 
	-- Instantiate the Unit Under Test (UUT)
   uut: fpTest PORT MAP (
          in1 => in1,
          in2 => in2,
          in3 => in3,
          in4 => in4,
          out1 => out1,
          Clk => Clk,
          Rst => Rst
        );

   -- Clock process definitions
   Clk_process :process
   begin
		Clk <= '0';
		wait for Clk_period/2;
		Clk <= '1';
		wait for Clk_period/2;
   end process;

	-- map inputs
	process (i1,i2,i3,i4)
	begin
		inf1 <= to_float(i1,inf1);
		inf2 <= to_float(i2,inf2);
		inf3 <= to_float(i3,inf3);
		inf4 <= to_float(i4,inf4);
		in1 <= to_slv(inf1);
		in2 <= to_slv(inf2);
		in3 <= to_slv(inf3);
		in4 <= to_slv(inf4);
	end process;
 
	-- map outputs
	outf1 <= to_float(out1);
	o1 <= to_real(outf1);

--bdd0e560 bf743958 (-0.102000, -0.954000) :26
--3cc49ba0 bf558106 (0.024000, -0.834000) :b
--bfc872b0 3bc49ba6 (-1.566000, 0.006000) :c
--3e9374bc 3bc49ba6 (0.288000, 0.006000) :f

   -- Stimulus process
   stim_proc: process
		file outfile: text; -- two files
		variable f_status: FILE_OPEN_STATUS;
		variable buf_out: LINE;
   begin		
	
		-- file_open(f_status, outfile, "STD_OUTPUT", write_mode);
		file_open(f_status, outfile, "./fp.log", write_mode);

      -- hold reset state for 100 ns.
      wait for 100 ns;	

		-- integer format is S15.16 
      wait until rising_edge(clk);
		i1 <= -2.5;
		i2 <= 3.0;
		i3 <= 0.65;
		i4 <= -0.5;
		
      wait until rising_edge(clk);
			write(buf_out, "Eval: ");
			write(buf_out, eval);
			write(buf_out, ", FC: ");
			write(buf_out, fc1);
			write(buf_out, ", Out: ");
			write(buf_out, o1);
			writeline(outfile, buf_out);
		i1 <= i1 + 0.5;

      wait until rising_edge(clk);
			write(buf_out, "Eval: ");
			write(buf_out, eval);
			write(buf_out, ", FC: ");
			write(buf_out, fc1);
			write(buf_out, ", Out: ");
			write(buf_out, o1);
			writeline(outfile, buf_out);
		i1 <= i1 + 0.5;
      wait until rising_edge(clk);
			write(buf_out, "Eval: ");
			write(buf_out, eval);
			write(buf_out, ", FC: ");
			write(buf_out, fc1);
			write(buf_out, ", Out: ");
			write(buf_out, o1);
			writeline(outfile, buf_out);
		i1 <= i1 + 0.5;
      wait until rising_edge(clk);
			write(buf_out, "Eval: ");
			write(buf_out, eval);
			write(buf_out, ", FC: ");
			write(buf_out, fc1);
			write(buf_out, ", Out: ");
			write(buf_out, o1);
			writeline(outfile, buf_out);
		i1 <= i1 + 0.5;
      wait until rising_edge(clk);
			write(buf_out, "Eval: ");
			write(buf_out, eval);
			write(buf_out, ", FC: ");
			write(buf_out, fc1);
			write(buf_out, ", Out: ");
			write(buf_out, o1);
			writeline(outfile, buf_out);
		i1 <= i1 + 0.5;
		i3 <= 0.25;
      wait until rising_edge(clk);
			write(buf_out, "Eval: ");
			write(buf_out, eval);
			write(buf_out, ", FC: ");
			write(buf_out, fc1);
			write(buf_out, ", Out: ");
			write(buf_out, o1);
			writeline(outfile, buf_out);
		i1 <= i1 + 0.5;
      wait until rising_edge(clk);
			write(buf_out, "Eval: ");
			write(buf_out, eval);
			write(buf_out, ", FC: ");
			write(buf_out, fc1);
			write(buf_out, ", Out: ");
			write(buf_out, o1);
			writeline(outfile, buf_out);
		i1 <= i1 + 0.5;
      wait until rising_edge(clk);
			write(buf_out, "Eval: ");
			write(buf_out, eval);
			write(buf_out, ", FC: ");
			write(buf_out, fc1);
			write(buf_out, ", Out: ");
			write(buf_out, o1);
			writeline(outfile, buf_out);
		i1 <= i1 + 0.5;
      wait until rising_edge(clk);
			write(buf_out, "Eval: ");
			write(buf_out, eval);
			write(buf_out, ", FC: ");
			write(buf_out, fc1);
			write(buf_out, ", Out: ");
			write(buf_out, o1);
			writeline(outfile, buf_out);
		i1 <= i1 + 0.5;
      wait until rising_edge(clk);
			write(buf_out, "Eval: ");
			write(buf_out, eval);
			write(buf_out, ", FC: ");
			write(buf_out, fc1);
			write(buf_out, ", Out: ");
			write(buf_out, o1);
			writeline(outfile, buf_out);
		i2 <= -i2; -- negative
      wait until rising_edge(clk);
			write(buf_out, "Eval: ");
			write(buf_out, eval);
			write(buf_out, ", FC: ");
			write(buf_out, fc1);
			write(buf_out, ", Out: ");
			write(buf_out, o1);
			writeline(outfile, buf_out);
		i2 <= i2 - 18.0;
      wait until rising_edge(clk);

		for i in 1 to 10 loop
			write(buf_out, "Eval: ");
			write(buf_out, eval);
			write(buf_out, ", FC: ");
			write(buf_out, fc1);
			write(buf_out, ", Out: ");
			write(buf_out, o1);
			writeline(outfile, buf_out);
      wait until rising_edge(clk);
		end loop;
		
      -- insert stimulus here 

		file_close(outfile);
      wait;
   end process;

END;
