----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:00:01 11/17/2014 
-- Design Name: 
-- Module Name:    cxgen - Behavioral 
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

entity cxgen is
    Port ( cx_min : in  STD_LOGIC_VECTOR (31 downto 0);
           dx : in  STD_LOGIC_VECTOR (31 downto 0);
           enable : in  STD_LOGIC;
           clear : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           clk : in  STD_LOGIC;
           cx : out  STD_LOGIC_VECTOR (31 downto 0);
           ready : out  STD_LOGIC);
end cxgen;

architecture Behavioral of cxgen is

component c_counter_binary_v11_0 IS
  PORT (
    clk : IN STD_LOGIC;
    ce : IN STD_LOGIC;
    sclr : IN STD_LOGIC;
    q : OUT STD_LOGIC_VECTOR(10 DOWNTO 0)
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

component fmul IS
  PORT (
    a : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    b : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    clk : IN STD_LOGIC;
    result : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
  );
END component;

signal count: STD_LOGIC_VECTOR(10 DOWNTO 0);
signal fadd_a, fadd_b, fadd_result: STD_LOGIC;
signal fmul_a, fmul_b, fmul_result: STD_LOGIC;

begin
	CNT_I: c_counter_binary_v11_0 port map (clk, enable, clear, count);
	FADD_I: fadd port map (fadd_a, fadd_b, clk, fadd_result);
	FMUL_I: fadd port map (fadd_a, fadd_b, clk, fadd_result);
end Behavioral;

