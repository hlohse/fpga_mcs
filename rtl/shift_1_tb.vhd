library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity shift_1_tb is
    generic (WIDTH : integer := 8);
end shift_1_tb;

architecture behaviour of shift_1_tb is
    component shift_1 is
        generic (WIDTH     : integer := 8);
        Port    (clk       : in  std_logic;
                 reset     : in  std_logic;
                 input     : in  std_logic_vector((WIDTH - 1) downto 0);
                 valid_in  : in  std_logic;
                 output    : out std_logic_vector((WIDTH - 1) downto 0);
                 valid_out : out std_logic);
    end component;

    signal clk       : std_logic;
    signal reset     : std_logic;
    signal input     : std_logic_vector((WIDTH - 1) downto 0);
    signal valid_in  : std_logic;
    signal output    : std_logic_vector((WIDTH - 1) downto 0);
    signal valid_out : std_logic;
    
    constant clk_period: time := 10 ns;

begin

    uut: shift_1
    generic map(WIDTH => WIDTH)
    port map(
        clk       => clk,
        reset     => reset,
        input     => input,
        valid_in  => valid_in,
        output    => output,
        valid_out => valid_out
    );
   
    clk_proc: process begin
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
    end process;

    stim_proc: process begin
        input    <= (others => '0');
        valid_in <= '0';
        reset    <= '1';
        wait for 10*clk_period;
        reset    <= '0';
        wait for clk_period;

        assert unsigned(output) = 0 report "output must be 0 after reset!";
        assert valid_out = '0' report "valid_out must be false after reset!";
        
        input    <= (0 => '1', others => '0');
        valid_in <= '1';
        wait for clk_period;

        assert unsigned(output) = 1 report "output must be 1!";
        assert valid_out = '1' report "valid_out must be true!";
        
        valid_in <= '0';
        wait for clk_period;
        
        assert valid_out = '0' report "valid_out must be false!";

        assert false report "DONE SIMULATING" severity failure;
    end process;

end behaviour;

