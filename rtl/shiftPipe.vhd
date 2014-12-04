library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity shiftPipe is
	generic (width: integer := 4; depth: integer := 16);
	port
	(
		clk, reset:	in std_logic;
		iCmpVector:	in std_logic_vector(depth-1 downto 0);
		iValid:		in std_logic;
		
		oColor:		out std_logic_vector(width-1 downto 0);
		oValid:		out std_logic
	);
end entity;

architecture imp of shiftPipe is

component shiftStage
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
end component;

type sig1 is array (depth-1 downto 0) of std_logic;
type sig4 is array (depth-1 downto 0) of std_logic_vector(width-1 downto 0);
signal color: sig4;
signal cmp: sig1;
signal valid: sig1;

signal validReg: std_logic := '0';

begin

	pipeStage0: shiftStage
	generic map( width => width )
	port map
	(
		clk			=> clk,
		reset		=> reset,
		iColorValue	=> (others => '0'),
		iValid		=> iValid,
		iCmpCarry	=> '0',
		iCmpSig		=> iCmpVector(0),
		oColorValue	=> color(0),
		oValid		=> valid(0),
		oCmpCarry	=> cmp(0)
	);

	GEN: for i in 1 to depth-2 generate
	begin
		pipeStageX: shiftStage
		generic map( width => width )
		port map
		(
			clk			=> clk,
			reset		=> reset,
			iColorValue	=> color(i-1),
			iValid		=> valid(i-1),
			iCmpCarry	=> cmp(i-1),
			iCmpSig		=> iCmpVector(i),
			oColorValue	=> color(i),
			oValid		=> valid(i),
			oCmpCarry	=> cmp(i)
		);
	end generate GEN;
	
	pipeStageN: shiftStage
	generic map( width => width )
	port map
	(
		clk			=> clk,
		reset		=> reset,
		iColorValue	=> color(depth-2),
		iValid		=> valid(depth-2),
		iCmpCarry	=> cmp(depth-2),
		iCmpSig		=> iCmpVector(depth-1),
		oColorValue	=> oColor,
		oValid		=> validReg,
		oCmpCarry	=> open
	);
	
	-- delay valid signal one more clock
	-- see: addShift.vhd
	process(clk)
	begin
		if rising_edge(clk) then
			oValid <= validReg;
		end if;
	end process;

end imp;
