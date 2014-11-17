--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   09:57:41 09/27/2013
-- Design Name:   
-- Module Name:   /home/kugel/daten/work/vhdl/mbIp/sp6/ise/fpTest.vhd
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
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;


-- input/output integer format is sign(1) - int(11) - fract(21)
-- all fp comps have 2 cycles latency
-- max speed is just below 100MHz. Use 80MHz in UCF to comply with HDMI timing (65MHz)
 
ENTITY fpTest IS
port (

	in1 :in STD_LOGIC_VECTOR(31 DOWNTO 0) := (others => '0');
	in2 :in STD_LOGIC_VECTOR(31 DOWNTO 0) := (others => '0');
	in3 :in STD_LOGIC_VECTOR(31 DOWNTO 0) := (others => '0');
	in4 :in STD_LOGIC_VECTOR(31 DOWNTO 0) := (others => '0');
	out1 :out STD_LOGIC_VECTOR(31 DOWNTO 0) := (others => '1');
	Clk : in std_logic := '0';
	Rst : in std_logic := '1'
);
END fpTest;
 
ARCHITECTURE behavior OF fpTest IS 

	
COMPONENT itof16_l3
  PORT (
    a : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    clk : IN STD_LOGIC;
    result : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
  );
END COMPONENT;
COMPONENT ftoi16_l3
  PORT (
    a : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    clk : IN STD_LOGIC;
    result : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
  );
END COMPONENT;

COMPONENT fsub_l3
  PORT (
    a : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    b : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    clk : IN STD_LOGIC;
    result : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
  );
END COMPONENT;
COMPONENT fmul_l3
  PORT (
    a : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    b : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    clk : IN STD_LOGIC;
    result : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
  );
END COMPONENT;
COMPONENT fcmpless
  PORT (
    a : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    b : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    clk : IN STD_LOGIC;
    result : OUT STD_LOGIC_VECTOR(0 DOWNTO 0)
  );
END COMPONENT;
COMPONENT fadd_l3
  PORT (
    a : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    b : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    clk : IN STD_LOGIC;
    result : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
  );
END COMPONENT;

signal fi1 :STD_LOGIC_VECTOR(31 DOWNTO 0);
signal fi2 :STD_LOGIC_VECTOR(31 DOWNTO 0);
signal fi3 :STD_LOGIC_VECTOR(31 DOWNTO 0);
signal fi4 :STD_LOGIC_VECTOR(31 DOWNTO 0);
signal fo1 :STD_LOGIC_VECTOR(31 DOWNTO 0);
signal fm1 :STD_LOGIC_VECTOR(31 DOWNTO 0);
signal fa1 :STD_LOGIC_VECTOR(31 DOWNTO 0);
signal fs1 :STD_LOGIC_VECTOR(31 DOWNTO 0);

-- delay fi3,4
signal fi3_r0 :STD_LOGIC_VECTOR(31 DOWNTO 0);
signal fi3_r1 :STD_LOGIC_VECTOR(31 DOWNTO 0);
signal fi3_r2 :STD_LOGIC_VECTOR(31 DOWNTO 0);
signal fi4_r0 :STD_LOGIC_VECTOR(31 DOWNTO 0);
signal fi4_r1 :STD_LOGIC_VECTOR(31 DOWNTO 0);
signal fi4_r2 :STD_LOGIC_VECTOR(31 DOWNTO 0);


signal fc1 :STD_LOGIC_VECTOR(0 DOWNTO 0);
signal fc2, fc3 :STD_LOGIC; -- delays for latency
 
BEGIN

--itof_1 : itof16_l3
--  PORT MAP (
--    a => in1,
--    clk => clk,
--    result => fi1
--  );
--itof_2 : itof16_l3
--  PORT MAP (
--    a => in2,
--    clk => clk,
--    result => fi2
--  );
--itof_3 : itof16_l3
--  PORT MAP (
--    a => in3,
--    clk => clk,
--    result => fi3
--  );
--itof_4 : itof16_l3
--  PORT MAP (
--    a => in4,
--    clk => clk,
--    result => fi4
--  );

	fi1 <= in1;
	fi2 <= in2;
	fi3_r0 <= in3;
	fi4_r0 <= in4;
	
	-- delay fi3 andfi4
	process
	begin
		wait until rising_edge(clk);
		fi3_r1 <= fi3_r0;
		fi3_r2 <= fi3_r1;
		fi3 <= fi3_r2;
		fi4_r1 <= fi4_r0;
		fi4_r2 <= fi4_r1;
		fi4 <= fi4_r2;
	end process;
	
fmul_1 : fmul_l3
  PORT MAP (
    a => fi1,
    b => fi2,
    clk => clk,
    result => fm1
  );


fadd_1 : fadd_l3
  PORT MAP (
    a => fm1,
    b => fi4,
    clk => clk,
    result => fa1
  );

fsub_1 : fsub_l3
  PORT MAP (
    a => fm1,
    b => fi3,
    clk => clk,
    result => fs1
  );

fcmp_1 : fcmpless
  PORT MAP (
    a => fa1,
    b => fs1,
    clk => clk,
    result => fc1
  );
  -- deleay cmp decision by 2 cycles
  process
  begin
	wait until rising_edge(clk);
	fc2 <= fc1(0);
	fc3 <= fc2;
  end process;
  -- decision mux
	-- fo1 <= fa1 when fc3 = '1' else fs1;
	fo1 <= fa1 when fc2 = '1' else fs1;
	-- fo1 <= fa1; 


--ftoi_1 : ftoi16_l3
--  PORT MAP (
--    a => fo1,
--    clk => clk,
--    result => out1
--  );

	out1 <= fo1;
 
END;
