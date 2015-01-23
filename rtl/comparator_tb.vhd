library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity comparator_tb is
    generic (WIDTH : integer := 8);
end comparator_tb;

architecture behaviour of comparator_tb is
    component comparator is
        generic (WIDTH     : integer := 8);
        Port    (clk       : in  std_logic;
                 reset     : in  std_logic;
                 a         : in  std_logic_vector((WIDTH - 1) downto 0);
                 b         : in  std_logic_vector((WIDTH - 1) downto 0);
                 valid_in  : in  std_logic;
                 higher    : out std_logic_vector((WIDTH - 1) downto 0);
                 lower     : out std_logic_vector((WIDTH - 1) downto 0);
                 valid_out : out std_logic);
    end component;

    signal clk       : std_logic;
    signal reset     : std_logic;
    signal a         : std_logic_vector((WIDTH - 1) downto 0);
    signal b         : std_logic_vector((WIDTH - 1) downto 0);
    signal valid_in  : std_logic;
    signal higher    : std_logic_vector((WIDTH - 1) downto 0);
    signal lower     : std_logic_vector((WIDTH - 1) downto 0);
    signal valid_out : std_logic;
   
    constant clk_period: time := 10 ns;

begin
    uut: comparator
    generic map(WIDTH => WIDTH)
    port map (
        clk       => clk,
        reset     => reset,
        a         => a,
        b         => b,
        valid_in  => valid_in,
        higher    => higher,
        lower     => lower,
        valid_out => valid_out
    );
   
    clk_proc: process begin
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
    end process;

    stim_proc: process begin
        a        <= (others => '0');
        b        <= (others => '0');
        valid_in <= '0';
        reset    <= '1';
        wait for 10*clk_period;
        reset    <= '0';
        wait for clk_period;
        
        assert unsigned(higher) = 0 report "higher must be 0 after reset!";
        assert unsigned(lower)  = 0 report "lower must be 0 after reset!";
        assert valid_out = '0' report "valid_out must be false after reset!";

        a        <= (1 downto 0 => '1', others => '0'); -- 2
        b        <= (1 => '1', others => '0');          -- 1
        valid_in <= '1';
        wait for clk_period;

        assert unsigned(higher) = unsigned(a) report "higher must be 2!";
        assert unsigned(lower)  = unsigned(b) report "lower must be 1!";
        assert valid_out = '1' report "valid_out must be true!";

        a        <= (1 => '1', others => '0');          -- 1
        b        <= (1 downto 0 => '1', others => '0'); -- 2
        wait for clk_period;

        assert unsigned(higher) = unsigned(b) report "higher must be 2!";
        assert unsigned(lower)  = unsigned(a) report "lower must be 1!";
        assert valid_out = '1' report "valid_out must be true!";

        a        <= (1 downto 0 => '1', others => '0'); -- 2
        b        <= (1 downto 0 => '1', others => '0'); -- 2
        wait for clk_period;

        assert unsigned(higher) = unsigned(lower) report "higher and lower must be equal!";
        assert unsigned(higher) = unsigned(a) report "higher must be 2!";
        assert unsigned(lower)  = unsigned(b) report "lower must be 2!";
        assert valid_out = '1' report "valid_out must be true!";

        valid_in <= '0';
        wait for clk_period;
        
        assert valid_out = '0' report "valid_out must be false!";

        assert false report "DONE SIMULATING" severity failure;
    end process;

end behaviour;

