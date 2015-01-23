library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity median_9_tb is
    generic (WIDTH : integer := 8);
end median_9_tb;

architecture behaviour of median_9_tb is
    component median_9 is
        generic (WIDTH     : integer := 8);
        Port    (clk       : in  std_logic;
                 reset     : in  std_logic;
                 input_0   : in  std_logic_vector((WIDTH - 1) downto 0);
                 input_1   : in  std_logic_vector((WIDTH - 1) downto 0);
                 input_2   : in  std_logic_vector((WIDTH - 1) downto 0);
                 input_3   : in  std_logic_vector((WIDTH - 1) downto 0);
                 input_4   : in  std_logic_vector((WIDTH - 1) downto 0);
                 input_5   : in  std_logic_vector((WIDTH - 1) downto 0);
                 input_6   : in  std_logic_vector((WIDTH - 1) downto 0);
                 input_7   : in  std_logic_vector((WIDTH - 1) downto 0);
                 input_8   : in  std_logic_vector((WIDTH - 1) downto 0);
                 valid_in  : in  std_logic;
                 median    : out std_logic_vector((WIDTH - 1) downto 0);
                 valid_out : out std_logic);
    end component;
    
    type input_vector is array(0 to 8) of
                         std_logic_vector((WIDTH - 1) downto 0);
        
    signal clk       : std_logic;
    signal reset     : std_logic;
    signal input     : input_vector;
    signal valid_in  : std_logic;
    signal median    : std_logic_vector((WIDTH - 1) downto 0);
    signal valid_out : std_logic;
    
    constant clk_period: time := 10 ns;

begin

    uut: median_9
    generic map(WIDTH => WIDTH)
    port map(
        clk       => clk,
        reset     => reset,
        input_0   => input(0),
        input_1   => input(1),
        input_2   => input(2),
        input_3   => input(3),
        input_4   => input(4),
        input_5   => input(5),
        input_6   => input(6),
        input_7   => input(7),
        input_8   => input(8),
        valid_in  => valid_in,
        median    => median,
        valid_out => valid_out
    );
   
    clk_proc: process begin
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
    end process;

    stim_proc: process begin
        for i in 0 to 8 loop
            input(i) <= (others => '0');
        end loop;
        valid_in <= '0';
        reset    <= '1';
        wait for 10*clk_period;
        reset    <= '0';
        wait for 9*clk_period;

        assert unsigned(median) = 0 report "median must be 0!";
        assert valid_out = '0' report "valid_out must be false!";

        -- median 1 @ cycle 9
        for i in 0 to 8 loop
            input(i) <= std_logic_vector(to_unsigned(1, WIDTH));
        end loop;
        valid_in <= '1';
        
        wait for clk_period; -- 1

        -- median 4 @ cycle 10
        for i in 0 to 8 loop
            input(i) <= std_logic_vector(to_unsigned(i, WIDTH));
        end loop;
        
        wait for clk_period; -- 2
        valid_in <= '0';
        wait for clk_period; -- 3

        -- median 5 @ cycle 12
        input(0) <= std_logic_vector(to_unsigned(  2, WIDTH));
        input(1) <= std_logic_vector(to_unsigned(  5, WIDTH));
        input(2) <= std_logic_vector(to_unsigned(  7, WIDTH));
        input(3) <= std_logic_vector(to_unsigned(  3, WIDTH));
        input(4) <= std_logic_vector(to_unsigned(255, WIDTH));
        input(5) <= std_logic_vector(to_unsigned( 15, WIDTH));
        input(6) <= std_logic_vector(to_unsigned(  6, WIDTH));
        input(7) <= std_logic_vector(to_unsigned(  1, WIDTH));
        input(8) <= std_logic_vector(to_unsigned(  0, WIDTH));
        valid_in <= '1';
        
        wait for clk_period; -- 4
        valid_in <= '0';
        wait for 5*clk_period; -- 9

        assert unsigned(median) = 1 report "median must be 1!";
        assert valid_out = '1' report "valid_out must be true!";
        
        wait for clk_period; -- 10

        assert unsigned(median) = 4 report "median must be 4!";
        assert valid_out = '1' report "valid_out must be true!";
        
        wait for clk_period; -- 11

        assert valid_out = '0' report "valid_out must be false!";
        
        wait for clk_period; -- 12

        assert unsigned(median) = 5 report "median must be 5!";
        assert valid_out = '1' report "valid_out must be true!";
        
        wait for clk_period; -- 13

        assert valid_out = '0' report "valid_out must be false!";
        
        assert false report "DONE SIMULATING" severity failure;
    end process;

end behaviour;

