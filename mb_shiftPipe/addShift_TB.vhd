library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity addShift_TB is
end entity;

architecture beh of addShift_TB is

	component addShift
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
	end component;

	signal tbres : std_logic := '0';
	signal tbclk : std_logic := '0';

	--signal cmp : std_logic := '0';
	--signal valid : std_logic := '0';

	signal cin : std_logic_vector(3 downto 0) := (others => '0');
	signal cout : std_logic_vector(3 downto 0) := (others => '0');

	signal cmp : std_logic := '0';
	signal cmpcin : std_logic := '0';
	signal cmpcout : std_logic := '0';

	signal valin : std_logic := '0';
	signal valout : std_logic := '0';

	signal add : std_logic_vector(3 downto 0) := X"1";

	-- tb stuff
	constant clk_period: time := 100 ns;

begin

	uut: addShift
	generic map( width => 4 )
	port map
	(
		tbclk, tbres, cin, cout, cmp, cmpcin, cmpcout, valin, valout, add
	);

	clk_proc: process
	begin
		tbclk <= '0';
		wait for clk_period/2;
		tbclk <= '1';
		wait for clk_period/2;
	end process;

	stim_proc: process
	begin

		tbres <= '1';
		wait for clk_period;
		tbres <= '0';
		wait for clk_period;

		cmp	<= '0';
		cin		<= (others => '0');

		-- shift and add
		add <= X"1";
		for i in 0 to 10 loop

			wait for clk_period*8;
			cmp <= '1';
			wait for clk_period*1;
			cmp <= '0';

		end loop;

		-- shift only
		add <= X"0";
		for i in 0 to 10 loop

			wait for clk_period*8;
			cmp <= '1';
			wait for clk_period*1;
			cmp <= '0';

		end loop;

		-- shift and add (no compare signal)
		add <= X"1";
		cmp <= '0';
		wait for clk_period*9;

		-- the other signals
		for i in 0 to 10 loop

			wait for clk_period*3;
			cmpcin <= '1';
			valin <= '1';
			wait for clk_period*1;
			cmpcin <= '0';
			valin <= '0';

		end loop;

		-- eos
		wait;
	end process;

end beh;

