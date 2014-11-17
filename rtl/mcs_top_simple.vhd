
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
library UNISIM;
use UNISIM.VComponents.all;

entity mcs_top is
  generic (
		hasDram: boolean := 1;
		simulation: integer := 0;
		trace: integer := 1  -- use chipscope
  );
  port (
    Clk : IN STD_LOGIC;
    Rst_n : IN STD_LOGIC;
    UART_Rx : IN STD_LOGIC;
    UART_Tx : OUT STD_LOGIC;
    GPO1 : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
    GPI1 : IN STD_LOGIC_VECTOR(7 DOWNTO 0)
  );

end entity;
  
architecture rtl of mcs_top is

-- the core with trace option enabled
COMPONENT mblaze
  PORT (
    Clk : IN STD_LOGIC;
    Reset : IN STD_LOGIC;
    IO_Addr_Strobe : OUT STD_LOGIC;
    IO_Read_Strobe : OUT STD_LOGIC;
    IO_Write_Strobe : OUT STD_LOGIC;
    IO_Address : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    IO_Byte_Enable : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
    IO_Write_Data : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    IO_Read_Data : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    IO_Ready : IN STD_LOGIC;
    UART_Rx : IN STD_LOGIC;
    UART_Tx : OUT STD_LOGIC;
    UART_Interrupt : OUT STD_LOGIC;
    FIT1_Interrupt : OUT STD_LOGIC;
    FIT1_Toggle : OUT STD_LOGIC;
    FIT2_Interrupt : OUT STD_LOGIC;
    FIT2_Toggle : OUT STD_LOGIC;
    PIT1_Interrupt : OUT STD_LOGIC;
    PIT1_Toggle : OUT STD_LOGIC;
    PIT2_Enable : IN STD_LOGIC;
    PIT2_Interrupt : OUT STD_LOGIC;
    PIT2_Toggle : OUT STD_LOGIC;
    GPO1 : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
    GPI1 : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    GPI1_Interrupt : OUT STD_LOGIC;  -- GPI Interrupts are not enabled in MCS design
    INTC_Interrupt : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
    INTC_IRQ : OUT STD_LOGIC;
    Trace_Instruction : OUT STD_LOGIC_VECTOR(0 TO 31);
    Trace_Valid_Instr : OUT STD_LOGIC;
    Trace_PC : OUT STD_LOGIC_VECTOR(0 TO 31);
    Trace_Reg_Write : OUT STD_LOGIC;
    Trace_Reg_Addr : OUT STD_LOGIC_VECTOR(0 TO 4);
    Trace_MSR_Reg : OUT STD_LOGIC_VECTOR(0 TO 14);
    Trace_New_Reg_Value : OUT STD_LOGIC_VECTOR(0 TO 31);
    Trace_Jump_Taken : OUT STD_LOGIC;
    Trace_Delay_Slot : OUT STD_LOGIC;
    Trace_Data_Address : OUT STD_LOGIC_VECTOR(0 TO 31);
    Trace_Data_Access : OUT STD_LOGIC;
    Trace_Data_Read : OUT STD_LOGIC;
    Trace_Data_Write : OUT STD_LOGIC;
    Trace_Data_Write_Value : OUT STD_LOGIC_VECTOR(0 TO 31);
    Trace_Data_Byte_Enable : OUT STD_LOGIC_VECTOR(0 TO 3);
    Trace_MB_Halted : OUT STD_LOGIC
  );
END COMPONENT;

-- chipscope 
component trace_icon
  PORT (
    CONTROL0 : INOUT STD_LOGIC_VECTOR(35 DOWNTO 0);
    CONTROL1 : INOUT STD_LOGIC_VECTOR(35 DOWNTO 0)
	 );
end component;

component trace_ila
  PORT (
    CONTROL : INOUT STD_LOGIC_VECTOR(35 DOWNTO 0);
    CLK : IN STD_LOGIC;
    TRIG0 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    TRIG1 : IN STD_LOGIC_VECTOR(33 DOWNTO 0);
    TRIG2 : IN STD_LOGIC_VECTOR(8 DOWNTO 0)
	 );
end component;

component trace_vio
  PORT (
    CONTROL : INOUT STD_LOGIC_VECTOR(35 DOWNTO 0);
    CLK : IN STD_LOGIC;
    ASYNC_OUT : OUT STD_LOGIC_VECTOR(1 downto 0);
    SYNC_OUT : OUT STD_LOGIC_VECTOR(31 DOWNTO 0));

end component;

component trace_dcm
port
 (-- Clock in ports
  CLK_IN1           : in     std_logic;
  CLKFB_IN          : in     std_logic;
  -- Clock out ports
  CLK_OUT1          : out    std_logic;
  CLK_OUT2          : out    std_logic;
  CLKFB_OUT         : out    std_logic;
  -- Status and control signals
  RESET             : in     std_logic
 );
end component;

-- signals ------------
signal CS_CONTROL0 :  STD_LOGIC_VECTOR(35 DOWNTO 0);
signal CS_CONTROL1 :  STD_LOGIC_VECTOR(35 DOWNTO 0);
signal CS_TRIG0 : STD_LOGIC_VECTOR(31 DOWNTO 0);
signal CS_TRIG1 :  STD_LOGIC_VECTOR(33 DOWNTO 0);
signal CS_TRIG2 :  STD_LOGIC_VECTOR(8 DOWNTO 0);
signal CS_VIO0 :  STD_LOGIC_VECTOR(1 DOWNTO 0);
signal CS_VIO1 :  STD_LOGIC_VECTOR(31 DOWNTO 0);
signal cs_rst: std_logic;
signal cs_stop: std_logic;

-- address range
constant addrBits: integer := 2;
subtype ADDR is std_logic_vector(addrBits - 1 downto 0);

constant idReg: integer := 0;
constant ctlReg: integer := 1;
constant statReg: integer := 2;
constant miscReg: integer := 3;

constant idAddr:   ADDR :=  std_logic_vector(to_unsigned(idReg,addrBits));
constant ctlAddr:  ADDR :=  std_logic_vector(to_unsigned(ctlReg,addrBits));
constant statAddr: ADDR :=  std_logic_vector(to_unsigned(statReg,addrBits));
constant miscAddr: ADDR :=  std_logic_vector(to_unsigned(miscReg,addrBits));

-- register set 
type regSet is array(2**addrBits - 1 downto 0) of std_logic_vector(31 downto 0);
signal regs: regSet := (idReg => X"00000001", statReg => X"01020304", others => X"00000000");

-- basic core signals
signal IO_Addr_Strobe :  STD_LOGIC;
signal IO_Read_Strobe :  STD_LOGIC;
signal IO_Write_Strobe :  STD_LOGIC;
signal IO_Byte_Address :  STD_LOGIC_VECTOR(31 DOWNTO 0);  -- full address 
signal IO_Address :  STD_LOGIC_VECTOR(addrBits - 1 DOWNTO 0);  -- effective word address 
signal IO_Byte_Enable :  STD_LOGIC_VECTOR(3 DOWNTO 0);
signal IO_Write_Data :  STD_LOGIC_VECTOR(31 DOWNTO 0);
signal IO_Read_Data :  STD_LOGIC_VECTOR(31 DOWNTO 0);
signal IO_Ready :  STD_LOGIC;
signal UART_Interrupt :  STD_LOGIC;
signal FIT1_Interrupt :  STD_LOGIC;
signal FIT2_Interrupt :  STD_LOGIC;
signal PIT1_Interrupt :  STD_LOGIC;
signal PIT2_Interrupt :  STD_LOGIC;
signal GPI1_Interrupt :  STD_LOGIC;
signal INTC_Interrupt :  STD_LOGIC_VECTOR(3 DOWNTO 0);

signal FIT1_Toggle :  STD_LOGIC;
signal PIT1_Toggle :  STD_LOGIC;
signal FIT2_Toggle :  STD_LOGIC;
signal PIT2_Toggle :  STD_LOGIC;
signal PIT2_Enable :  STD_LOGIC;
signal EXT_Interrupt :  STD_LOGIC_VECTOR(2 DOWNTO 0) := (others => '0');
signal INTC_IRQ :  STD_LOGIC;

signal GPO1_i :  STD_LOGIC_VECTOR(7 DOWNTO 0);
signal GPO1_r :  STD_LOGIC_VECTOR(7 DOWNTO 0);  -- pipeline register
signal GPI1_r :  STD_LOGIC_VECTOR(7 DOWNTO 0);  -- pipeline register


-- reset
signal reset: std_logic := '1';

-- additional logic

signal wrRdy, rdRdy: std_logic;

-- simulation bit
signal simStat: std_logic;

-- tracing
signal Trace_PC : STD_LOGIC_VECTOR(0 TO 31);
signal Trace_Instruction : STD_LOGIC_VECTOR(0 TO 31);
signal Trace_Valid_Instr : STD_LOGIC;
signal Trace_Jump_Taken : STD_LOGIC;

signal clk_i, clk_1, clk_2, clk_3: std_logic;
signal sysClk, csClk: std_logic;
signal stopClk: std_logic := '0';



begin

  -- simulation mode detection
  simMode: if simulation /= 0 generate
  begin
	simStat <= '1';
  end generate;
  impMode: if simulation = 0 generate
  begin
	simStat <= '0';
  end generate;

	-- primary input clk
	clkBuf: bufg port map (i => clk, o => clk_i);

  -- synchronize reset
  rsProc: process(clk_i, rst_n, cs_rst)
  begin
		if (rst_n = '0') or (cs_rst = '1') then
			reset <= '1';
		elsif rising_edge(clk_i) then
			reset <= '0';
		end if;
  end process;

	-------------------------------
	-------------------------------
	-- use the instance name as given in xco file. Otherwise edit .bmm file 
	
  mcs_0 : mblaze
  PORT MAP (
	 Clk => sysClk,
	 Reset => Reset,
	 IO_Addr_Strobe => IO_Addr_Strobe,
	 IO_Read_Strobe => IO_Read_Strobe,
	 IO_Write_Strobe => IO_Write_Strobe,
	 IO_Address => IO_Byte_Address,
	 IO_Byte_Enable => IO_Byte_Enable,
	 IO_Write_Data => IO_Write_Data,
	 IO_Read_Data => IO_Read_Data,
	 IO_Ready => IO_Ready,
	 UART_Rx => UART_Rx,
	 UART_Tx => UART_Tx,
	 UART_Interrupt => UART_Interrupt,
	 FIT1_Interrupt => FIT1_Interrupt,
	 FIT1_Toggle => FIT1_Toggle,
	 FIT2_Interrupt => FIT2_Interrupt,
	 FIT2_Toggle => FIT2_Toggle,
	 PIT1_Interrupt => PIT1_Interrupt,
	 PIT1_Toggle => PIT1_Toggle,
	 PIT2_Enable => PIT2_Enable,
	 PIT2_Interrupt => PIT2_Interrupt,
	 PIT2_Toggle => PIT2_Toggle,
	 GPO1 => GPO1_i,
	 GPI1 => GPI1_r,
	 GPI1_Interrupt => GPI1_Interrupt,
	 INTC_Interrupt => EXT_Interrupt,
	 INTC_IRQ => INTC_IRQ,
	 Trace_Instruction => Trace_Instruction,
	 Trace_Valid_Instr => Trace_Valid_Instr,
	 Trace_Jump_Taken => Trace_Jump_Taken,
	 Trace_PC => Trace_PC
  );

	-- with trace enabled, we can add logic to set HW breakpoints and stop the clock
	withTrace: if trace /= 0 generate
	begin
		trace_clockSource : trace_dcm
	  port map
		(-- Clock in ports
		 CLK_IN1 => clk_i,
		 CLKFB_IN => clk_3,
		 -- Clock out ports
		 CLK_OUT1 => clk_1,
		 CLK_OUT2 => clk_2,
		 CLKFB_OUT => clk_3,
		 -- Status and control signals
		 RESET  => '0');
		
		sysClkBuf: bufgmux port map (s => stopClk, i0 => clk_1, i1 => '0', o => sysClk);
		-- insert chipscope if not in simulation mode
		withChipscope: if simulation = 0 generate
		begin
			csClkBuf: bufg port map (i => clk_2, o => csClk);

			csCtl : trace_icon
			  port map (
				 CONTROL0 => CS_CONTROL0,
				 CONTROL1 => CS_CONTROL1
				 );
			csIla : trace_ila
			  port map (
				 CONTROL => CS_CONTROL0,
				 CLK => csClk,
				 TRIG0 => CS_TRIG0,
				 TRIG1 => CS_TRIG1,
				 TRIG2 => CS_TRIG2
				 );
			
			cs_trig0 <= Trace_PC;
			cs_trig1 <= Trace_Instruction & Trace_Valid_Instr & Trace_Jump_Taken;
			CS_TRIG2(7 downto 0) <= EXT_Interrupt & UART_Interrupt & FIT1_Interrupt & FIT2_Interrupt & PIT1_Interrupt & PIT2_Interrupt;
			cs_trig2(8) <= INTC_IRQ;
			
			csVio : trace_vio
			  port map (
				 CONTROL => CS_CONTROL1,
				 CLK => csClk,
				 ASYNC_OUT => CS_VIO0,
				 SYNC_OUT => CS_VIO1);
				 
				cs_rst <= CS_VIO0(0);
				-- stop on address match
				cs_stop <= '1' when (cs_vio0(1) = '1') and (CS_VIO1 = Trace_PC) else '0';

		end generate;
		
		noChipscope: if simulation /= 0 generate
		begin
			cs_rst <= '0';	-- force reset to 0
			cs_stop <= '0';
			csClk <= sysClk; 	-- we need the csClk here as well for the memory
		end generate;

		-- no other action at the moment
		stopClk <= cs_stop; 
	end generate;
	
	noTrace: if trace = 0 generate
	begin
		-- pass-through clock
		sysClk <= clk_i;
	end generate;

  -- effective address
  IO_Address <= IO_Byte_Address(addrBits + 1 downto 2); -- make word address
  
  -- ready logic
  IO_Ready <= wrRdy or rdRdy;
  

  -- write control
  wrProc: process
  begin
		wait until rising_edge(sysClk);
		if reset = '1' then
			regs(ctlReg) <= (others => '0');
			regs(miscReg) <= (others => '0');
		else
			if IO_Write_Strobe = '1' then
				wrRdy <= '1';
				
				if IO_Address(addrBits - 1 downto 0) = ctlAddr then
					regs(ctlreg) <= IO_Write_Data;
				elsif IO_Address(addrBits - 1 downto 0) = miscAddr then
					regs(miscReg) <= IO_Write_Data;
				end if;
				
			else
				wrRdy <= '0';
			end if;
		end if;
  end process;
  
  -- status map
  statMap: block
  begin
		 regs(statReg)(31) <= simStat;
		 regs(statReg)(30) <= FIT1_Toggle;
		 regs(statReg)(29) <= INTC_IRQ;
		 regs(statReg)(28 downto 0) <= (others => '0');
  end block;

  -- control map
  ctlMap: block
  begin
		EXT_Interrupt <= regs(ctlReg)(2 downto 0);
		PIT2_Enable <= regs(ctlReg)(3);
  end block;
  
  -- read control
  rdBlock: block
  begin
		-- data mux
		with IO_Address(addrBits - 1 downto 0) select
			IO_Read_Data <= regs(idReg) when idAddr,
								 regs(ctlReg) when ctlAddr,
								 -- simStat & regs(statReg)(30 downto 0) when statAddr,
								 regs(statReg) when statAddr,
								 regs(miscReg) when miscAddr,
								 (others => '0') when others;
		-- ready
		rdRdy <= IO_Read_Strobe;
  end block;
  
  -- input pipeline
  gpinPIpe: process
  begin
		wait until rising_edge(sysClk);
		gpi1_r <= gpi1;
  end process;
  
  -- output pipeline
  gpoutPIpe: process
  begin
		wait until rising_edge(sysClk);
		gpo1 <= gpo1_r;
  end process;

  -- output mux LED vs PI toggle 
  ledMux: block
  begin
		gpo1_r(7 downto 2) <= gpo1_i(7 downto 2);
		gpo1_r(1) <= gpo1_i(1) when regs(ctlReg)(1) = '0' else PIT2_Toggle;
		gpo1_r(0) <= gpo1_i(0) when regs(ctlReg)(0) = '0' else PIT1_Toggle;
  end block;
 
 
end rtl;
