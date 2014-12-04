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
  generic( num_cx  : integer := 800);
    Port ( clk       : in   STD_LOGIC;
           reset     : in   STD_LOGIC;
           clear     : in   STD_LOGIC;
           valid_in  : in   STD_LOGIC;
           cx        : in   STD_LOGIC_VECTOR (31 downto 0);
           cy        : in   STD_LOGIC_VECTOR (31 downto 0);
           zx_in     : in   STD_LOGIC_VECTOR (31 downto 0);
           zy_in     : in   STD_LOGIC_VECTOR (31 downto 0);
           zx_out    : out  STD_LOGIC_VECTOR (31 downto 0);
           zy_out    : out  STD_LOGIC_VECTOR (31 downto 0);
           compare   : out  STD_LOGIC;
           valid_out : out  STD_LOGIC);
end mbrot_pipe_element;

architecture Behavioral of mbrot_pipe_element is

component cx_shift IS
  PORT (
    d:   IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
    clk: IN  STD_LOGIC;
    q:   OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
  );
END component;

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

COMPONENT fcmpless
  PORT (
    a : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    b : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    clk : IN STD_LOGIC;
    result : OUT STD_LOGIC_VECTOR(0 DOWNTO 0)
  );
END COMPONENT;

signal cx_shift_out: STD_LOGIC_VECTOR(31 downto 0);

signal sqr_1_1_result: STD_LOGIC_VECTOR(31 downto 0);
signal mul_1_result:   STD_LOGIC_VECTOR(31 downto 0);
signal sqr_1_2_result: STD_LOGIC_VECTOR(31 downto 0);

signal sub_2_result: STD_LOGIC_VECTOR(31 downto 0);
signal mul_2_const_2, mul_2_result: STD_LOGIC_VECTOR(31 downto 0);
signal add_2_result: STD_LOGIC_VECTOR(31 downto 0);

signal cmp_3_const_4:  STD_LOGIC_VECTOR(31 downto 0);
signal cmp_3_result:   STD_LOGIC_VECTOR(0 DOWNTO 0);

signal counter: integer range 0 to 9;

begin

  CX_SHIFT_I: cx_shift port map (cx, clk, cx_shift_out);

  FSQR_1_1_I: fmul     port map (zx_in,          zx_in,          clk, sqr_1_1_result);
  FMUL_1_I:   fmul     port map (zx_in,          zy_in,          clk, mul_1_result);
  FSQR_1_2_I: fmul     port map (zy_in,          zy_in,          clk, sqr_1_2_result);
  
  FSUB_2_I:   fsub     port map (sqr_1_1_result, sqr_1_2_result, clk, sub_2_result);
  FMUL_2_I:   fmul     port map (mul_2_const_2,  mul_1_result,   clk, mul_2_result);
  FADD_2_I:   fadd     port map (sqr_1_1_result, sqr_1_2_result, clk, add_2_result);
  
  FADD_3_1_I: fadd     port map (cx_shift_out,   sub_2_result,   clk, zx_out);
  FADD_3_2_I: fadd     port map (cy,             mul_2_result,   clk, zy_out);
  FCMP_3_I:   fcmpless port map (add_2_result,   cmp_3_const_4,  clk, cmp_3_result);

  proc: process begin
    wait until rising_edge(clk);
    if reset = '1' then
      compare       <= '0';
      valid_out     <= '0';
      mul_2_const_2 <= "01000000000000000000000000000000";
      cmp_3_const_4 <= "01000000100000000000000000000000";
      counter       <= 0;
      
    else
      if clear = '1' then
        compare   <= '0';
        valid_out <= '0';
        counter   <= 0;
         
      elsif valid_in = '1' then
        if counter = 8 then
          valid_out <= '1';
          compare   <= cmp_3_result(0);
        else
          counter <= counter + 1;
        end if;
      end if;
    end if;
  end process;

end Behavioral;

