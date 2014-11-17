--------------------------------------------------------------------------------
--    This file is owned and controlled by Xilinx and must be used solely     --
--    for design, simulation, implementation and creation of design files     --
--    limited to Xilinx devices or technologies. Use with non-Xilinx          --
--    devices or technologies is expressly prohibited and immediately         --
--    terminates your license.                                                --
--                                                                            --
--    XILINX IS PROVIDING THIS DESIGN, CODE, OR INFORMATION "AS IS" SOLELY    --
--    FOR USE IN DEVELOPING PROGRAMS AND SOLUTIONS FOR XILINX DEVICES.  BY    --
--    PROVIDING THIS DESIGN, CODE, OR INFORMATION AS ONE POSSIBLE             --
--    IMPLEMENTATION OF THIS FEATURE, APPLICATION OR STANDARD, XILINX IS      --
--    MAKING NO REPRESENTATION THAT THIS IMPLEMENTATION IS FREE FROM ANY      --
--    CLAIMS OF INFRINGEMENT, AND YOU ARE RESPONSIBLE FOR OBTAINING ANY       --
--    RIGHTS YOU MAY REQUIRE FOR YOUR IMPLEMENTATION.  XILINX EXPRESSLY       --
--    DISCLAIMS ANY WARRANTY WHATSOEVER WITH RESPECT TO THE ADEQUACY OF THE   --
--    IMPLEMENTATION, INCLUDING BUT NOT LIMITED TO ANY WARRANTIES OR          --
--    REPRESENTATIONS THAT THIS IMPLEMENTATION IS FREE FROM CLAIMS OF         --
--    INFRINGEMENT, IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A   --
--    PARTICULAR PURPOSE.                                                     --
--                                                                            --
--    Xilinx products are not intended for use in life support appliances,    --
--    devices, or systems.  Use in such applications are expressly            --
--    prohibited.                                                             --
--                                                                            --
--    (c) Copyright 1995-2014 Xilinx, Inc.                                    --
--    All rights reserved.                                                    --
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
--    Generated from core with identifier: xilinx.com:ip:microblaze_mcs:1.4   --
--                                                                            --
--    MicroBlaze Micro Controller System (MCS) is a light-weight general      --
--    purpose micro controller system, based on the MicroBlaze processor.     --
--    It is primarily intended for simple control applications, where a       --
--    hardware solution would be less flexible and more difficult to          --
--    implement. Software development with the Xilinx Software Development    --
--    Kit (SDK) is supported, including a software driver for the             --
--    peripherals. Debugging is available either via SDK or directly with     --
--    the Xilinx Microprocessor Debugger.                                     --
--                                                                            --
--    The MCS consists of the processor itself, local memory with sizes       --
--    ranging from 4KB to 64KB, up to 4 Fixed Interval Timers, up to 4        --
--    Programmable Interval Timers, up to 4 32-bit General Purpose Output     --
--    ports, up to 4 32-bit General Purpose Input ports, and an Interrupt     --
--    Controller with up to 16 external interrupt inputs.                     --
--                                                                            --
--------------------------------------------------------------------------------

-- Interfaces:
--    IO_BUS
--        MicroBlaze MCS IO Bus Interface
--    TRACE
--        MicroBlaze MCS Trace Interface

-- The following code must appear in the VHDL architecture header:

------------- Begin Cut here for COMPONENT Declaration ------ COMP_TAG
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
    GPI1_Interrupt : OUT STD_LOGIC;
    GPI2 : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
    GPI2_Interrupt : OUT STD_LOGIC;
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
-- COMP_TAG_END ------ End COMPONENT Declaration ------------

-- The following code must appear in the VHDL architecture
-- body. Substitute your own instance name and net names.

------------- Begin Cut here for INSTANTIATION Template ----- INST_TAG
your_instance_name : mblaze
  PORT MAP (
    Clk => Clk,
    Reset => Reset,
    IO_Addr_Strobe => IO_Addr_Strobe,
    IO_Read_Strobe => IO_Read_Strobe,
    IO_Write_Strobe => IO_Write_Strobe,
    IO_Address => IO_Address,
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
    GPO1 => GPO1,
    GPI1 => GPI1,
    GPI1_Interrupt => GPI1_Interrupt,
    GPI2 => GPI2,
    GPI2_Interrupt => GPI2_Interrupt,
    INTC_Interrupt => INTC_Interrupt,
    INTC_IRQ => INTC_IRQ,
    Trace_Instruction => Trace_Instruction,
    Trace_Valid_Instr => Trace_Valid_Instr,
    Trace_PC => Trace_PC,
    Trace_Reg_Write => Trace_Reg_Write,
    Trace_Reg_Addr => Trace_Reg_Addr,
    Trace_MSR_Reg => Trace_MSR_Reg,
    Trace_New_Reg_Value => Trace_New_Reg_Value,
    Trace_Jump_Taken => Trace_Jump_Taken,
    Trace_Delay_Slot => Trace_Delay_Slot,
    Trace_Data_Address => Trace_Data_Address,
    Trace_Data_Access => Trace_Data_Access,
    Trace_Data_Read => Trace_Data_Read,
    Trace_Data_Write => Trace_Data_Write,
    Trace_Data_Write_Value => Trace_Data_Write_Value,
    Trace_Data_Byte_Enable => Trace_Data_Byte_Enable,
    Trace_MB_Halted => Trace_MB_Halted
  );
-- INST_TAG_END ------ End INSTANTIATION Template ------------

-- You must compile the wrapper file mblaze.vhd when simulating
-- the core, mblaze. When compiling the wrapper file, be sure to
-- reference the XilinxCoreLib VHDL simulation library. For detailed
-- instructions, please refer to the "CORE Generator Help".

