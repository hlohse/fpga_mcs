----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:10:55 12/13/2014 
-- Design Name: 
-- Module Name:    ColorConverter_4_24 - Behavioral 
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

entity ColorConverter_4_24 is
    Port ( clock : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           color_in : in  STD_LOGIC_VECTOR (3 downto 0);
           color_out : out  STD_LOGIC_VECTOR (23 downto 0);
           valid_in: in std_logic;
           valid_out: out std_logic);
end ColorConverter_4_24;

architecture Behavioral of ColorConverter_4_24 is

begin

	process( clock, reset )
	begin
		if( reset = '0' ) then
			color_out <= (others => '0');
      valid_out <= '0';
		elsif( rising_edge( clock ) ) then
			case color_in is
				when "0000" => color_out <= X"FF0000";
				when "0001" => color_out <= X"FF0000";
				when "0010" => color_out <= X"FF0000";
				when "0011" => color_out <= X"BF3F00";
				when "0100" => color_out <= X"7F7F00";
				when "0101" => color_out <= X"3FBF00";
				when "0110" => color_out <= X"00FF00";
				when "0111" => color_out <= X"00FF00";
				when "1000" => color_out <= X"00FF00";
				when "1001" => color_out <= X"00FF00";
				when "1010" => color_out <= X"00BF3F";
				when "1011" => color_out <= X"007F7F";
				when "1100" => color_out <= X"003FBF";
				when "1101" => color_out <= X"0000FF";
				when "1110" => color_out <= X"0000FF";
				when "1111" => color_out <= X"0000FF";
				when others => color_out <= (others => 'X');
			end case;
      valid_out <= valid_in;
		end if;
	end process;


end Behavioral;

