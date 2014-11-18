----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    07:50:31 09/24/2013 
-- Design Name: 
-- Module Name:    tmdsEncoder - Behavioral 
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

entity tmdsEncoder is
    Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           de : in  STD_LOGIC;
           c1 : in  STD_LOGIC;
           c0 : in  STD_LOGIC;
           d : in  STD_LOGIC_VECTOR (7 downto 0);
           q : out  STD_LOGIC_VECTOR (9 downto 0));
end tmdsEncoder;

architecture Behavioral of tmdsEncoder is

--C0 C1
--0 	0 	0010101011
--0 	1 	0010101010
--1 	0 	1101010100
--1 	1 	1101010101

constant c00code: std_logic_vector(9 downto 0) := "0010101011";
constant c01code: std_logic_vector(9 downto 0) := "0010101010";
constant c10code: std_logic_vector(9 downto 0) := "1101010100";
constant c11code: std_logic_vector(9 downto 0) := "1101010101";

signal cmd: std_logic_vector(1 downto 0);

begin

	cmd <= c0 & c1;
-- dummy
	process
	begin
		wait until rising_edge(clk);
		if de = '0' then
			if cmd = "00" then 
				q <= c00code;
			elsif cmd = "01" then 
				q <= c01code;
			elsif cmd = "10" then 
				q <= c10code;
			else
				q <= c11code;
			end if;
		else
			q <= "00" & d;
		end if;
	end process;

end Behavioral;

