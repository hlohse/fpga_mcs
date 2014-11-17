----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    07:53:20 10/21/2013 
-- Design Name: 
-- Module Name:    memIf - Behavioral 
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity memIf is
    Port ( clk : in  STD_LOGIC;
           writeEn : in  STD_LOGIC;
           addr : in  STD_LOGIC_VECTOR (7 downto 0);
           dataIn : in  STD_LOGIC_VECTOR (7 downto 0);
           dataOut : out  STD_LOGIC_VECTOR (7 downto 0));
end memIf;

architecture Behavioral of memIf is

-- EDID ROM size is 128 bytes
type romType is array (127 downto 0) of std_logic_vector(7 downto 0);
--signal i2crom: romType;

-- Dell sample
--constant i2crom: romType := (
--X"00",X"ff",X"ff",X"ff",X"ff",X"ff",X"ff",X"00",
--X"30",X"e4",X"00",X"00",X"00",X"00",X"00",X"00",
--X"00",X"13",X"01",X"04",X"95",X"22",X"13",X"78",
--X"02",X"15",X"d5",X"9e",X"59",X"50",X"98",X"26",
--X"0e",X"50",X"54",X"00",X"00",X"00",X"01",X"01",
--X"01",X"01",X"01",X"01",X"01",X"01",X"01",X"01",
--X"01",X"01",X"01",X"01",X"01",X"01",X"ca",X"35",
--X"80",X"92",X"70",X"38",X"1f",X"40",X"30",X"20",
--X"35",X"00",X"58",X"c2",X"10",X"00",X"00",X"18",
--X"22",X"24",X"80",X"a0",X"70",X"38",X"1f",X"40",
--X"30",X"20",X"35",X"00",X"58",X"c2",X"10",X"00",
--X"00",X"18",X"00",X"00",X"00",X"fe",X"00",X"44",
--X"48",X"30",X"39",X"31",X"80",X"31",X"35",X"36",
--X"57",X"46",X"31",X"0a",X"00",X"00",X"00",X"00",
--X"00",X"00",X"41",X"31",X"1e",X"00",X"00",X"00",
--X"00",X"09",X"01",X"0a",X"20",X"20",X"00",X"d6"
--);

--
constant i2crom: romType := (
X"00",X"ff",X"ff",X"ff",X"ff",X"ff",X"ff",X"00",
X"30",X"e4",X"00",X"00",X"00",X"00",X"00",X"00",
X"00",X"13",X"01",X"04",X"95",X"22",X"13",X"78",
X"02",X"15",X"d5",X"9e",X"59",X"50",X"98",X"26",
X"0e",X"50",X"54",X"00",X"00",X"00",X"01",X"01",
X"01",X"01",X"01",X"01",X"01",X"01",X"01",X"01",
X"01",X"01",X"01",X"01",X"01",X"01",X"ca",X"35",
X"80",X"92",X"70",X"38",X"1f",X"40",X"30",X"20",
X"35",X"00",X"58",X"c2",X"10",X"00",X"00",X"18",
X"22",X"24",X"80",X"a0",X"70",X"38",X"1f",X"40",
X"30",X"20",X"35",X"00",X"58",X"c2",X"10",X"00",
X"00",X"18",X"00",X"00",X"00",X"fe",X"00",X"44",
X"48",X"30",X"39",X"31",X"80",X"31",X"35",X"36",
X"57",X"46",X"31",X"0a",X"00",X"00",X"00",X"00",
X"00",X"00",X"41",X"31",X"1e",X"00",X"00",X"00",
X"00",X"09",X"01",X"0a",X"20",X"20",X"00",X"d6"
);

begin
	
	-- write
--	process -- (writeEn)
--	begin
--		wait until rising_edge(clk);
--		if writeEn = '1' then
--			i2crom(to_integer(unsigned(addr))) <= dataIn;
--		end if;
--	end process;
	
	-- read
	dataOut <= i2crom(to_integer(unsigned(addr(6 downto 0))));

end Behavioral;

