----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    07:50:31 09/24/2013 
-- Design Name: 
-- Module Name:    tmdsEncoder - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
-- use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity tmdsEncoder is
    Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           de : in  STD_LOGIC;
           c1 : in  STD_LOGIC;
           c0 : in  STD_LOGIC;
           d : in  STD_LOGIC_VECTOR (7 downto 0);
           q : out  STD_LOGIC_VECTOR (9 downto 0));
end tmdsEncoder;

architecture Behavioral of tmdsEncoder is

constant c00code: std_logic_vector(9 downto 0) := "1101010100";
constant c01code: std_logic_vector(9 downto 0) := "0010101011";
constant c10code: std_logic_vector(9 downto 0) := "0101010100";
constant c11code: std_logic_vector(9 downto 0) := "1010101011";

signal n1d: std_logic_vector(3 downto 0);
signal d_q: std_logic_vector(7 downto 0);

signal decision1: std_logic;
signal q_m: std_logic_vector(8 downto 0);

signal n1q_m, n0q_m: std_logic_vector(3 downto 0);

signal cnt: std_logic_vector(4 downto 0);
signal decision2, decision3: std_logic;

signal de_q, de_reg: std_logic;
signal c0_q, c1_q: std_logic;
signal c0_reg, c1_reg: std_logic;
signal q_m_reg: std_logic_vector(8 downto 0);

signal concat: std_logic_vector(1 downto 0);

begin

    process (clk)
    begin
        if rising_edge(clk) then
            n1d <= ("000"&d(0)) + ("000"&d(1)) + ("000"&d(2))
                   + ("000"&d(3)) + ("000"&d(4)) + ("000"&d(5))
                   + ("000"&d(6)) + ("000"&d(7)) after 1 ps;
            d_q <= d after 1 ps;
        end if;
    end process;

    decision1 <= '1' when (n1d > X"4") else '1' when ((n1d = X"4") and (d_q(0) = '0')) else '0';

    q_m(0) <= d_q(0);
    q_m(1) <= (q_m(0) xnor d_q(1)) when decision1 = '1' else (q_m(0) xor d_q(1));
    q_m(2) <= (q_m(1) xnor d_q(2)) when decision1 = '1' else (q_m(1) xor d_q(2));
    q_m(3) <= (q_m(2) xnor d_q(3)) when decision1 = '1' else (q_m(2) xor d_q(3));
    q_m(4) <= (q_m(3) xnor d_q(4)) when decision1 = '1' else (q_m(3) xor d_q(4));
    q_m(5) <= (q_m(4) xnor d_q(5)) when decision1 = '1' else (q_m(4) xor d_q(5));
    q_m(6) <= (q_m(5) xnor d_q(6)) when decision1 = '1' else (q_m(5) xor d_q(6));
    q_m(7) <= (q_m(6) xnor d_q(7)) when decision1 = '1' else (q_m(6) xor d_q(7));
    q_m(8) <= not decision1;

    process (clk)
    begin
        if rising_edge(clk) then
            n1q_m <= ("000"&q_m(0)) + ("000"&q_m(1)) + ("000"&q_m(2))
                   + ("000"&q_m(3)) + ("000"&q_m(4)) + ("000"&q_m(5))
                   + ("000"&q_m(6)) + ("000"&q_m(7)) after 1 ps;
            n0q_m <= "1000" - (("000"&q_m(0)) + ("000"&q_m(1)) + ("000"&q_m(2))
                   + ("000"&q_m(3)) + ("000"&q_m(4)) + ("000"&q_m(5))
                   + ("000"&q_m(6)) + ("000"&q_m(7))) after 1 ps;
        end if;
    end process;


    decision2 <= '1' when (cnt = "00000") else '1' when (n1q_m = n0q_m) else '0';
    decision3 <= '1' when ((cnt(4) = '0') and (n1q_m > n0q_m)) else '1' when ((cnt(4) = '1') and (n0q_m > n1q_m)) else '0';

    process -- (clk)
    begin
        wait until rising_edge(clk);
        de_q <= de after 1 ps;
        de_reg <= de_q after 1 ps;
        c0_q <= c0 after 1 ps;
        c0_reg <= c0_q after 1 ps;
        c1_q <= c1 after 1 ps;
        c1_reg <= c1_q after 1 ps;
        q_m_reg <= q_m after 1 ps;
    end process;

    concat <= c1_reg & c0_reg;

    -- 10-bit out disparity counter
    process (clk, rst)
    begin
        if rst = '1' then
            q <= (others => '0');
            cnt <= (others => '0');
        elsif rising_edge(clk) then 
            if (de_reg = '1') then
                if (decision2 = '1') then
                    q(9) <= not q_m_reg(8) after 1 ps;
                    q(8) <= q_m_reg(8) after 1 ps;

                    if q_m_reg(8) = '1' then
                        q(7 downto 0) <= q_m_reg(7 downto 0) after 1 ps;
                    else
                        q(7 downto 0) <= not q_m_reg(7 downto 0) after 1 ps;
                    end if;

                    if (q_m_reg(8) = '0') then
                        cnt <= (cnt + n0q_m - n1q_m) after 1 ps;
                    else
                        cnt <= (cnt + n1q_m - n0q_m) after 1 ps;
                    end if;
                else
                    if (decision3 = '1') then
                        q(9) <= '1' after 1 ps;
                        q(8) <= q_m_reg(8) after 1 ps;
                        q(7 downto 0) <= not q_m_reg(7 downto 0) after 1 ps;

                        if (n0q_m > n1q_m) then
                            cnt <= cnt + (q_m_reg(8) & '0') + (n0q_m - n1q_m) after 1 ps;
                        else
                            cnt <= cnt + (q_m_reg(8) & '0') - (n0q_m - n1q_m) after 1 ps;
                        end if;
                    else
                        q(9) <= '0' after 1 ps;
                        q(8) <= q_m_reg(8) after 1 ps;
                        q(7 downto 0) <= q_m_reg(7 downto 0) after 1 ps;

                        if (n1q_m > n0q_m) then
                            cnt <= cnt - (not q_m_reg(8) & '0') + (n1q_m - n0q_m) after 1 ps;
                        else
                            cnt <= cnt - (not q_m_reg(8) & '0') - (n1q_m - n0q_m) after 1 ps;
                        end if;
                    end if;
                end if;
            else
                case (concat) is
                    when "00" => q <= c00code after 1 ps;
                    when "01" => q <= c01code after 1 ps;
                    when "10" => q <= c10code after 1 ps;
                    when others => q <= c11code after 1 ps;
                end case;
                cnt <= "00000" after 1 ps;
            end if;
        end if;
    end process;

end Behavioral;

