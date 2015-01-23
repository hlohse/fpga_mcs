library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity comparator is
    generic (WIDTH     : integer := 8);
    Port    (clk       : in  std_logic;
             reset     : in  std_logic;
             a         : in  std_logic_vector((WIDTH - 1) downto 0);
             b         : in  std_logic_vector((WIDTH - 1) downto 0);
             valid_in  : in  std_logic;
             higher    : out std_logic_vector((WIDTH - 1) downto 0);
             lower     : out std_logic_vector((WIDTH - 1) downto 0);
             valid_out : out std_logic);
end comparator;

architecture behavior of comparator is begin
    proc: process begin
    wait until rising_edge(clk);
        if reset = '1' then
            higher    <= (others => '0');
            lower     <= (others => '0');
            valid_out <= '0';
        else
            if valid_in = '1' then
                if unsigned(a) > unsigned(b) then
                    higher <= a;
                    lower  <= b;
                else
                    higher <= b;
                    lower  <= a;
                end if;
                valid_out <= '1';
            else
                valid_out <= '0';
            end if;
        end if;
    end process;
end behavior;

