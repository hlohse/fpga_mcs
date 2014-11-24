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

signal cnt_q: STD_LOGIC_VECTOR(10 DOWNTO 0);
signal cnt_enable: STD_LOGIC;
signal fadd_a, fadd_b, fadd_result: STD_LOGIC;
signal fmul_a, fmul_b, fmul_result: STD_LOGIC;

begin
	CNT_I: c_counter_binary_v11_0 port map (clk, cnt_enable, clear, cnt_q);
	FADD_I: fadd port map (fadd_a, fadd_b, clk, fadd_result);
	FMUL_I: fadd port map (fadd_a, fadd_b, clk, fadd_result);
	
	proc: process(clk,reset)
	begin
		if reset = '1' then
			cx               <= (others => '0');
			ready         <= '0';
			cnt_enable <= '0';
			fadd_a        <= '0';
			fmul_b        <= '0';
			fadd_a        <= '0';
			fmul_b        <= '0';
			
		elsif rising_edge(clk) then
			if clear = '1' then
			  cx               <= (others => '0');
			  ready         <= '0';
			  cnt_enable <= '0';
			  fadd_a        <= '0';
			  fmul_b        <= '0';
			  fadd_a        <= '0';
			  fmul_b        <= '0';
			  
			elsif enable = '1' then
				cnt_enable <= '1';
				
				case to_integer(unsigned(cnt_q)) is
					when others => ready <= '1';
				end case;
				
			end if;
		end if;
	end process;
	
end Behavioral;

