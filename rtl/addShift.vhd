library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity addShift is
	generic (width: integer := 4);
	port
	(
		clk, reset:			in std_logic;
		
		colorVal_in:		in std_logic_vector(width-1 downto 0);
		colorVal_out:		out std_logic_vector(width-1 downto 0);
		
		cmpFlag:			in std_logic;
		cmpFlagCarry_in:	in std_logic;
		cmpFlagCarry_out:	out std_logic;
		
		validFlag_in:		in std_logic;
		validFlag_out:		out std_logic;
		
		addValue:			in std_logic_vector(width-1 downto 0)
	);
end entity;

architecture imp of addShift is
begin

	process(clk, reset)
	begin

		if (reset = '1') then

			cmpFlagCarry_out	<= '0';
			validFlag_out		<= '0';
			colorVal_out		<= (others => '0');

		elsif rising_edge(clk) then
			
			if (cmpFlag = '1' and unsigned(colorVal_in) < X"FF") then
				-- add & shift
				colorVal_out	<= std_logic_vector(unsigned(colorVal_in) + unsigned(addValue));
			else
				-- shift only
				colorVal_out	<= colorVal_in;
			end if;
			
			cmpFlagCarry_out	<= cmpFlag or cmpFlagCarry_in;
			validFlag_out		<= validFlag_in;
			
			-- attention:
			-- the valid signal needs to be registered after the
			-- last pipeline stage in the TOP level!!!
			
		end if;
	end process;
	
end imp;
