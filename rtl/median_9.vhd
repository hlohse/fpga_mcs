library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- 9 input values, 9 cycles latency, pipelined
entity median_9 is
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
end median_9;

architecture behavior of median_9 is
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

    component shift_1 is
        generic (WIDTH     : integer := 8);
        Port    (clk       : in  std_logic;
                 reset     : in  std_logic;
                 input     : in  std_logic_vector((WIDTH - 1) downto 0);
                 valid_in  : in  std_logic;
                 output    : out std_logic_vector((WIDTH - 1) downto 0);
                 valid_out : out std_logic);
    end component;
    
    type array_vector_19 is array(0 to 18) of
        std_logic_vector((WIDTH - 1) downto 0);
    type array_vector_17 is array(0 to 16) of
        std_logic_vector((WIDTH - 1) downto 0);

    signal c_higher     : array_vector_19;
    signal c_lower      : array_vector_19;
    signal c_valid_out  : std_logic_vector(18 downto 0);
    
    signal s_output     : array_vector_17;
    signal s_valid_out  : std_logic_vector(16 downto 0);

    signal c_and_0_s0   : std_logic;
    signal c_and_s3_1   : std_logic;
    signal c_and_3_s2   : std_logic;
    signal c_and_s4_4   : std_logic;
    signal c_and_6_s2   : std_logic;
    signal c_and_s5_7   : std_logic;
    signal c_and_2_5    : std_logic;
    signal c_and_s7_s8  : std_logic;
    signal c_and_9_s9   : std_logic;
    signal c_and_10_s10 : std_logic;
    signal c_and_s11_11 : std_logic;
    signal c_and_s12_13 : std_logic;
    signal c_and_s13_15 : std_logic;
    signal c_and_16_s15 : std_logic;
    signal c_and_s16_17 : std_logic;

begin

    c_and_0_s0   <= c_valid_out(0)  and s_valid_out(0);
    c_and_s3_1   <= s_valid_out(3)  and c_valid_out(1);
    c_and_3_s2   <= c_valid_out(3)  and s_valid_out(2);
    c_and_s4_4   <= s_valid_out(4)  and c_valid_out(4);
    c_and_6_s2   <= c_valid_out(6)  and s_valid_out(2);
    c_and_s5_7   <= s_valid_out(5)  and c_valid_out(7);
    c_and_2_5    <= c_valid_out(2)  and c_valid_out(5);
    c_and_s7_s8  <= s_valid_out(7)  and s_valid_out(8);
    c_and_9_s9   <= c_valid_out(9)  and s_valid_out(9);
    c_and_10_s10 <= c_valid_out(10) and s_valid_out(10);
    c_and_s11_11 <= s_valid_out(11) and c_valid_out(11);
    c_and_s12_13 <= s_valid_out(12) and c_valid_out(13);
    c_and_s13_15 <= s_valid_out(13) and c_valid_out(15);
    c_and_16_s15 <= c_valid_out(16) and s_valid_out(15);
    c_and_s16_17 <= s_valid_out(16) and c_valid_out(17);

    c0: comparator generic map(WIDTH => WIDTH) port map(
        clk       => clk,
        reset     => reset,
        a         => input_0,
        b         => input_1,
        valid_in  => valid_in,
        higher    => c_higher(0),
        lower     => c_lower(0),
        valid_out => c_valid_out(0));
    c1: comparator generic map(WIDTH => WIDTH) port map(
        clk       => clk,
        reset     => reset,
        a         => c_lower(0),
        b         => s_output(0),
        valid_in  => c_and_0_s0,
        higher    => c_higher(1),
        lower     => c_lower(1),
        valid_out => c_valid_out(1));
    c2: comparator generic map(WIDTH => WIDTH) port map(
        clk       => clk,
        reset     => reset,
        a         => s_output(3),
        b         => c_higher(1),
        valid_in  => c_and_s3_1,
        higher    => c_higher(2),
        lower     => c_lower(2),
        valid_out => c_valid_out(2));
    c3: comparator generic map(WIDTH => WIDTH) port map(
        clk       => clk,
        reset     => reset,
        a         => input_3,
        b         => input_4,
        valid_in  => valid_in,
        higher    => c_higher(3),
        lower     => c_lower(3),
        valid_out => c_valid_out(3));
    c4: comparator generic map(WIDTH => WIDTH) port map(
        clk       => clk,
        reset     => reset,
        a         => c_lower(3),
        b         => s_output(1),
        valid_in  => c_and_3_s2,
        higher    => c_higher(4),
        lower     => c_lower(4),
        valid_out => c_valid_out(4));
    c5: comparator generic map(WIDTH => WIDTH) port map(
        clk       => clk,
        reset     => reset,
        a         => s_output(4),
        b         => c_higher(4),
        valid_in  => c_and_s4_4,
        higher    => c_higher(5),
        lower     => c_lower(5),
        valid_out => c_valid_out(5));
    c6: comparator generic map(WIDTH => WIDTH) port map(
        clk       => clk,
        reset     => reset,
        a         => input_6,
        b         => input_7,
        valid_in  => valid_in,
        higher    => c_higher(6),
        lower     => c_lower(6),
        valid_out => c_valid_out(6));
    c7: comparator generic map(WIDTH => WIDTH) port map(
        clk       => clk,
        reset     => reset,
        a         => c_lower(6),
        b         => s_output(2),
        valid_in  => c_and_6_s2,
        higher    => c_higher(7),
        lower     => c_lower(7),
        valid_out => c_valid_out(7));
    c8: comparator generic map(WIDTH => WIDTH) port map(
        clk       => clk,
        reset     => reset,
        a         => s_output(5),
        b         => c_higher(7),
        valid_in  => c_and_s5_7,
        higher    => c_higher(8),
        lower     => c_lower(8),
        valid_out => c_valid_out(8));
    c9: comparator generic map(WIDTH => WIDTH) port map(
        clk       => clk,
        reset     => reset,
        a         => c_higher(2),
        b         => c_higher(5),
        valid_in  => c_and_2_5,
        higher    => c_higher(9),
        lower     => c_lower(9),
        valid_out => c_valid_out(9));
    c10: comparator generic map(WIDTH => WIDTH) port map(
        clk       => clk,
        reset     => reset,
        a         => c_lower(2),
        b         => c_lower(5),
        valid_in  => c_and_2_5,
        higher    => c_higher(10),
        lower     => c_lower(10),
        valid_out => c_valid_out(10));
    c11: comparator generic map(WIDTH => WIDTH) port map(
        clk       => clk,
        reset     => reset,
        a         => s_output(7),
        b         => s_output(8),
        valid_in  => c_and_s7_s8,
        higher    => c_higher(11),
        lower     => c_lower(11),
        valid_out => c_valid_out(11));
    c12: comparator generic map(WIDTH => WIDTH) port map(
        clk       => clk,
        reset     => reset,
        a         => c_lower(9),
        b         => s_output(9),
        valid_in  => c_and_9_s9,
        higher    => c_higher(12),
        lower     => c_lower(12),
        valid_out => c_valid_out(12));
    c13: comparator generic map(WIDTH => WIDTH) port map(
        clk       => clk,
        reset     => reset,
        a         => c_lower(10),
        b         => s_output(10),
        valid_in  => c_and_10_s10,
        higher    => c_higher(13),
        lower     => c_lower(13),
        valid_out => c_valid_out(13));
    c14: comparator generic map(WIDTH => WIDTH) port map(
        clk       => clk,
        reset     => reset,
        a         => s_output(11),
        b         => c_higher(11),
        valid_in  => c_and_s11_11,
        higher    => c_higher(14),
        lower     => c_lower(14),
        valid_out => c_valid_out(14));
    c15: comparator generic map(WIDTH => WIDTH) port map(
        clk       => clk,
        reset     => reset,
        a         => s_output(12),
        b         => c_higher(13),
        valid_in  => c_and_s12_13,
        higher    => c_higher(15),
        lower     => c_lower(15),
        valid_out => c_valid_out(15));
    c16: comparator generic map(WIDTH => WIDTH) port map(
        clk       => clk,
        reset     => reset,
        a         => s_output(13),
        b         => c_lower(15),
        valid_in  => c_and_s13_15,
        higher    => c_higher(16),
        lower     => c_lower(16),
        valid_out => c_valid_out(16));
    c17: comparator generic map(WIDTH => WIDTH) port map(
        clk       => clk,
        reset     => reset,
        a         => c_lower(16),
        b         => s_output(15),
        valid_in  => c_and_16_s15,
        higher    => c_higher(17),
        lower     => c_lower(17),
        valid_out => c_valid_out(17));
    c18: comparator generic map(WIDTH => WIDTH) port map(
        clk       => clk,
        reset     => reset,
        a         => s_output(16),
        b         => c_higher(17),
        valid_in  => c_and_s16_17,
        higher    => c_higher(18),
        lower     => median,
        valid_out => valid_out);

    s0: shift_1 generic map(WIDTH => WIDTH) port map(
        clk       => clk,
        reset     => reset,
        input     => input_2,
        valid_in  => valid_in,
        output    => s_output(0),
        valid_out => s_valid_out(0));
    s1: shift_1 generic map(WIDTH => WIDTH) port map(
        clk       => clk,
        reset     => reset,
        input     => input_5,
        valid_in  => valid_in,
        output    => s_output(1),
        valid_out => s_valid_out(1));
    s2: shift_1 generic map(WIDTH => WIDTH) port map(
        clk       => clk,
        reset     => reset,
        input     => input_8,
        valid_in  => valid_in,
        output    => s_output(2),
        valid_out => s_valid_out(2));
    s3: shift_1 generic map(WIDTH => WIDTH) port map(
        clk       => clk,
        reset     => reset,
        input     => c_higher(0),
        valid_in  => c_valid_out(0),
        output    => s_output(3),
        valid_out => s_valid_out(3));
    s4: shift_1 generic map(WIDTH => WIDTH) port map(
        clk       => clk,
        reset     => reset,
        input     => c_higher(3),
        valid_in  => c_valid_out(3),
        output    => s_output(4),
        valid_out => s_valid_out(4));
    s5: shift_1 generic map(WIDTH => WIDTH) port map(
        clk       => clk,
        reset     => reset,
        input     => c_higher(6),
        valid_in  => c_valid_out(6),
        output    => s_output(5),
        valid_out => s_valid_out(5));
    s6: shift_1 generic map(WIDTH => WIDTH) port map(
        clk       => clk,
        reset     => reset,
        input     => c_lower(1),
        valid_in  => c_valid_out(1),
        output    => s_output(6),
        valid_out => s_valid_out(6));
    s7: shift_1 generic map(WIDTH => WIDTH) port map(
        clk       => clk,
        reset     => reset,
        input     => c_lower(4),
        valid_in  => c_valid_out(4),
        output    => s_output(7),
        valid_out => s_valid_out(7));
    s8: shift_1 generic map(WIDTH => WIDTH) port map(
        clk       => clk,
        reset     => reset,
        input     => c_lower(7),
        valid_in  => c_valid_out(7),
        output    => s_output(8),
        valid_out => s_valid_out(8));
    s9: shift_1 generic map(WIDTH => WIDTH) port map(
        clk       => clk,
        reset     => reset,
        input     => c_higher(8),
        valid_in  => c_valid_out(8),
        output    => s_output(9),
        valid_out => s_valid_out(9));
    s10: shift_1 generic map(WIDTH => WIDTH) port map(
        clk       => clk,
        reset     => reset,
        input     => c_lower(8),
        valid_in  => c_valid_out(8),
        output    => s_output(10),
        valid_out => s_valid_out(10));
    s11: shift_1 generic map(WIDTH => WIDTH) port map(
        clk       => clk,
        reset     => reset,
        input     => s_output(6),
        valid_in  => s_valid_out(6),
        output    => s_output(11),
        valid_out => s_valid_out(11));
    s12: shift_1 generic map(WIDTH => WIDTH) port map(
        clk       => clk,
        reset     => reset,
        input     => c_higher(10),
        valid_in  => c_valid_out(10),
        output    => s_output(12),
        valid_out => s_valid_out(12));
    s13: shift_1 generic map(WIDTH => WIDTH) port map(
        clk       => clk,
        reset     => reset,
        input     => c_lower(12),
        valid_in  => c_valid_out(12),
        output    => s_output(13),
        valid_out => s_valid_out(13));
    s14: shift_1 generic map(WIDTH => WIDTH) port map(
        clk       => clk,
        reset     => reset,
        input     => c_higher(14),
        valid_in  => c_valid_out(14),
        output    => s_output(14),
        valid_out => s_valid_out(14));
    s15: shift_1 generic map(WIDTH => WIDTH) port map(
        clk       => clk,
        reset     => reset,
        input     => s_output(14),
        valid_in  => s_valid_out(14),
        output    => s_output(15),
        valid_out => s_valid_out(15));
    s16: shift_1 generic map(WIDTH => WIDTH) port map(
        clk       => clk,
        reset     => reset,
        input     => c_higher(16),
        valid_in  => c_valid_out(16),
        output    => s_output(16),
        valid_out => s_valid_out(16));

end behavior;

