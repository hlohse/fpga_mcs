----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:10:52 11/24/2014 
-- Design Name: 
-- Module Name:    mbrot_pipe - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity mbrot_pipe_element is
  generic( num_cx  : positiv := 800);
    Port ( clk     : in   STD_LOGIC;
           reset   : in   STD_LOGIC;
           clear   : in   STD_LOGIC;
           enable  : in   STD_LOGIC;
           cx      : in   STD_LOGIC_VECTOR (31 downto 0);
           cy      : in   STD_LOGIC_VECTOR (31 downto 0);
           zx      : out  STD_LOGIC_VECTOR (31 downto 0);
           zy      : out  STD_LOGIC_VECTOR (31 downto 0);
           compare : out  STD_LOGIC;
           valid   : out  STD_LOGIC);
end mbrot_pipe_element;

architecture Behavioral of mbrot_pipe_element is

component fadd IS
  PORT (
    a : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    b : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    clk : IN STD_LOGIC;
    result : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
  );
END component;

component fsub IS
  PORT (
    a : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    b : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    clk : IN STD_LOGIC;
    result : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
  );
END component;

component fmul IS
  PORT (
    a : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    b : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    clk : IN STD_LOGIC;
    result : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
  );
END component;

component fmul IS
  PORT (
    a : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    b : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    clk : IN STD_LOGIC;
    result : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
  );
END component;

COMPONENT fcmpless
  PORT (
    a : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    b : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    clk : IN STD_LOGIC;
    result : OUT STD_LOGIC_VECTOR(0 DOWNTO 0)
  );
END COMPONENT;

signal sqr_1_1_a, sqr_1_1_b, sqr_1_1_result: STD_LOGIC_VECTOR(31 downto 0);
signal mul_1_a,   mul_1_b,   mul_1_result:   STD_LOGIC_VECTOR(31 downto 0);
signal sqr_1_2_a, sqr_1_2_b, sqr_1_2_result: STD_LOGIC_VECTOR(31 downto 0);

signal sub_2_a, sub_2_b, sub_2_result: STD_LOGIC_VECTOR(31 downto 0);
signal mul_2_a, mul_2_b, mul_2_result: STD_LOGIC_VECTOR(31 downto 0);
signal add_2_a, add_2_b, add_2_result: STD_LOGIC_VECTOR(31 downto 0);

signal add_3_1_a, add_3_1_b, add_3_1_result: STD_LOGIC_VECTOR(31 downto 0);
signal add_3_2_a, add_3_2_b, add_3_2_result: STD_LOGIC_VECTOR(31 downto 0);
signal cmp_3_a,   cmp_3_b,   cmp_3_result:   STD_LOGIC_VECTOR(31 downto 0);

signal cnt: integer range 0 to 9;

begin
  FSQR_1_1_I: fmul port map (sqr_1_1_a, sqr_1_1_b, clk, sqr_1_1_result);
  FMUL_1_I:   fmul port map (mul_1_a,   mul_1_b,   clk, mul_1_result);
  FSQR_1_2_I: fmul port map (sqr_1_2_a, sqr_1_2_b, clk, sqr_1_2_result);
  FSUB_2_I:   fsub port map (sub_2_a,   sub_2_b,   clk, sub_2_result);
  FMUL_2_I:   fmul port map (mul_2_a,   mul_2_b,   clk, mul_2_result);
  FADD_2_I:   fadd port map (add_2_a,   add_2_b,   clk, add_2_result);
  FADD_3_1_I: fadd port map (add_3_1_a, add_3_1_b, clk, add_3_1_result);
  FADD_3_2_I: fadd port map (add_3_2_a, add_3_2_b, clk, add_3_2_result);
  FCMP_3_I:   fcmp port map (cmp_3_a,   cmp_3_b,   clk, cmp_3_result);

  proc: process begin
    if reset = '1' then
      zx         <= "00000000000000000000000000000000";
      zy         <= "00000000000000000000000000000000";
      compare    <= '0';
      valid      <= '0';
      
     elsif rising_edge(clk) then
       if clear = '1' then
         zx         <= "00000000000000000000000000000000";
         zy         <= "00000000000000000000000000000000";
         compare    <= '0';
         valid      <= '0';
         
       elsif enable = '1' then
         -- use cnt; beware that enable might be '0' before we output all results
       end if;
    end if;
  end process;

end Behavioral;

