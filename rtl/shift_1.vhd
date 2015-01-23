library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity shift_1 is
    generic (WIDTH     : integer := 8);
    Port    (clk       : in  std_logic;
             reset     : in  std_logic;
             input     : in  std_logic_vector((WIDTH - 1) downto 0);
             valid_in  : in  std_logic;
             output    : out std_logic_vector((WIDTH - 1) downto 0);
             valid_out : out std_logic);
end shift_1;

architecture behaviour of shift_1 is begin
    proc: process begin
    wait until rising_edge(clk);
        if reset = '1' then
            output    <= (others => '0');
            valid_out <= '0';
        else
            if valid_in = '1' then
                output    <= input;
                valid_out <= '1';
            else
                valid_out <= '0';
            end if;
        end if;
    end process;
end behaviour;

