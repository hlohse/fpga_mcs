
---------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity dram_reader is
  generic (
		xga: integer := 1; -- xga or 720p on hdmi
		simulation: integer := 0
  );
    Port ( 
		clk : in  STD_LOGIC;
		rst : in  STD_LOGIC;
		hsync : in  STD_LOGIC;
		vsync : in  STD_LOGIC;
		fsync : in  STD_LOGIC;
		hsync_out : out  STD_LOGIC;
		vsync_out : out  STD_LOGIC;
		active_out : out std_logic;
		frameBase: std_logic_vector(29 downto 0) := (others => '0');
		active : in  STD_LOGIC;
		cmd : out  STD_LOGIC_VECTOR (2 downto 0);
		cmdEn : out  STD_LOGIC;
		cmdFull : in  STD_LOGIC;
		cmdBl : out  STD_LOGIC_vector(5 downto 0);
		addr : out  STD_LOGIC_VECTOR (29 downto 0);
		rdEn : out  STD_LOGIC;
		rdEmpty : in  STD_LOGIC;
		rdFull : in  STD_LOGIC;
		rdData : in  STD_LOGIC_VECTOR (31 downto 0);
		data : out  STD_LOGIC_VECTOR (31 downto 0)
	);
END entity;

architecture arch of dram_reader is

constant rdCmd: STD_LOGIC_VECTOR (2 downto 0) := "011";
constant rdSize: integer := 32; -- burst length
constant burstLength :  STD_LOGIC_vector(5 downto 0) := std_logic_vector(to_unsigned(rdSize - 1, 6));


-- 1Gbit ram => 128MB => 27 bit for byte => 25 bit for word
constant addrSize: integer := 25;
-- row offset in memory = pixel per row
constant rowOffsetXga: integer := 1024;
constant rowOffset720: integer := 1280;

function getRowOffset return integer is
begin
	if xga /= 0 then
		return rowOffsetXga;
	else
		return rowOffset720;
	end if;
end function;

signal rowAddr: std_logic_vector(addrSize - 1 downto 0);
signal cmdAddr: std_logic_vector(addrSize - 1 downto 0);

signal cmdEn_i : STD_LOGIC := '0';

signal newFrame, newRow, newCmd: std_logic;
signal hsync_r: std_logic;

signal rst_r0, rst_r1: std_logic;

------------
component reader
   PORT( 
      Empty  : IN     std_logic;
      active : IN     std_logic;
      clk    : IN     std_logic;
      newRow : IN     std_logic;
      rst    : IN     std_logic;
      cmdEn  : OUT    std_logic;
      readEn : OUT    std_logic
   );
end component;

constant useFsm : boolean := true;

begin
	
	-- delayed reset
	process(rst, clk)
	begin
		if rst = '1' then 
			rst_r0 <= '1';
			rst_r1 <= '1';
		elsif rising_edge(clk) then
			rst_r0 <= '0';
			rst_r1 <= rst_r0;
		end if;
	end process;

	-- static/ directly mapped stuff
	cmdEn <= cmdEn_i;
	cmd <= rdCmd;
	cmdBl <= burstLength;
	addr <= "000" & cmdAddr & "00";
	
	-- sync and data pipeline
	process
	begin
		wait until rising_edge(clk);
		hsync_out <= hsync;
		vsync_out <= vsync;
		active_out <= active;
		data <= rdData;
	end process;
	
	-- detect rising edges on sync
	process
	begin
		wait until rising_edge(clk);
		hsync_r <= hsync;
	end process;
	newRow   <= '1' when (hsync = '1') and (hsync_r = '0') else '0';
	newFrame <= '1' when (fsync = '1') and (newRow = '1') else '0';
	
	-- capture/generate row base address
	process
	begin
		wait until rising_edge(clk);
		if (newFrame = '1') or (rst_r1 = '1') then
			rowAddr <= frameBase(addrSize + 1 downto 2); 
		elsif newRow = '1' then
			rowAddr <= rowAddr + getRowOffset; --rowOffset;
		end if;
	end process;

	-- capture/update cmd address during data phase
	process
	begin
		wait until rising_edge(clk);
		if active = '0' or rst_r1 = '1' then
			cmdAddr <= rowAddr;
		elsif cmdEn_i = '1' then
			cmdAddr <= cmdAddr + rdSize;
		end if;
	end process;
	
	noFsm: if not useFsm generate
	begin
	-- Control FSM  -- dummy yet!
		process (clk, rst_r1)
		begin
			if rst_r1 = '1' then
				cmdEn_i <= '0';
			elsif rising_edge(clk) then
				if (active = '1') and (cmdEn_i = '0') and (cmdFull = '0') and (rdEmpty = '1') then 
					cmdEn_i <= '1';
				else	
					cmdEn_i <= '0';
				end if;
			end if;
		end process;

		-- make sure we read all data after end of row
		-- rdEn <= '1' when (rst_r1 = '0') and ((active = '1' and ((rdEmpty = '0'))) or ((active = '0') and (rdEmpty = '0'))) else '0';
		rdEn <= '1' when ((rst_r1 = '0') and ((active = '1') or (rdEmpty = '0'))) else '0';
	end generate;

	withFsm: if useFsm generate
	begin
	-- Control FSM 
		fsmInst: reader
		PORT map( 
			Empty  => rdEmpty,
			active => active,
			clk    => clk,
			newRow => newRow,
			rst    => newFrame, -- rst_r1,
			cmdEn  => cmdEn_i,
			readEn => rdEn
		);
	end generate;


end arch;
