library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity shiftStage is
	generic (width: integer := 4);
	port
	(
		clk, reset:		in std_logic;
		
		iColorValue:	in std_logic_vector(width-1 downto 0);
		iValid:			in std_logic;
		iCmpCarry:		in std_logic;
		iCmpSig:		in std_logic;

		oColorValue:	out std_logic_vector(width-1 downto 0);
		oValid:			out std_logic;
		oCmpCarry:		out std_logic
	);
end entity;

architecture imp of shiftStage is

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
	
	type sig1 is array (7 downto 0) of std_logic;
	type sig4 is array (7 downto 0) of std_logic_vector(width-1 downto 0);
	signal color: sig4;
	signal cmp: sig1;
	signal valid: sig1;
	
begin

	stage0: addShift
	generic map( width => width )
	port map
	(
		clk					=> clk,
		reset				=> reset,
		colorVal_in			=> iColorValue,
		colorVal_out		=> color(0),
		cmpFlag				=> '0',
		cmpFlagCarry_in		=> '0',
		cmpFlagCarry_out	=> cmp(0),
		validFlag_in		=> iValid,
		validFlag_out		=> valid(0),
		addValue			=> X"0"
	);

	GEN: for i in 1 to 7 generate
	begin
		stageX: addShift
		generic map( width => width )
		port map
		(
			clk					=> clk,
			reset				=> reset,
			colorVal_in			=> color(i-1),
			colorVal_out		=> color(i),
			cmpFlag				=> '0',
			cmpFlagCarry_in		=> cmp(i-1),
			cmpFlagCarry_out	=> cmp(i),
			validFlag_in		=> valid(i-1),
			validFlag_out		=> valid(i),
			addValue			=> X"0"
		);
	end generate GEN;
	
	stage8: addShift
	generic map( width => width )
	port map
	(
		clk					=> clk,
		reset				=> reset,
		colorVal_in			=> color(7),
		colorVal_out		=> oColorValue,
		cmpFlag				=> iCmpSig,
		cmpFlagCarry_in		=> cmp(7),
		cmpFlagCarry_out	=> oCmpCarry,
		validFlag_in		=> valid(7),
		validFlag_out		=> oValid,
		addValue			=> X"1"
	);

end imp;
