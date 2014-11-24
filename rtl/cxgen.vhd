----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:00:01 11/17/2014 
-- Design Name: 
-- Module Name:    cxgen - Behavioral 
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity cxgen is
    Port ( cx_min : in  STD_LOGIC_VECTOR (31 downto 0);
           dx     : in  STD_LOGIC_VECTOR (31 downto 0);
           enable : in  STD_LOGIC;
           clear  : in  STD_LOGIC;
           reset  : in  STD_LOGIC;
           clk    : in  STD_LOGIC;
           cx     : out STD_LOGIC_VECTOR (31 downto 0);
           valid  : out STD_LOGIC);
end cxgen;

architecture Behavioral of cxgen is

component fadd IS
  PORT (
    a : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    b : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    clk : IN STD_LOGIC;
    result : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
  );
END component;

component fsub IS
  PORT (
    a : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    b : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    clk : IN STD_LOGIC;
    result : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
  );
END component;

component fmul IS
  PORT (
    a : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    b : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    clk : IN STD_LOGIC;
    result : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
  );
END component;

signal cnt: integer range 0 to 2047;
signal fadd_a, fadd_b, fadd_result: STD_LOGIC_VECTOR(31 DOWNTO 0);
signal fsub_a, fsub_b, fsub_result: STD_LOGIC_VECTOR(31 DOWNTO 0);
signal fmul_a, fmul_b, fmul_result: STD_LOGIC_VECTOR(31 DOWNTO 0);
signal cx_0, cx_1, cx_2, dx_3: STD_LOGIC_VECTOR(31 DOWNTO 0);

begin
	FADD_I: fadd port map (fadd_a, fadd_b, clk, fadd_result);
	FSUB_I: fsub port map (fsub_a, fsub_b, clk, fsub_result);
	FMUL_I: fadd port map (fadd_a, fadd_b, clk, fmul_result);
	
	proc: process(clk,reset)
	begin
		if reset = '1' then
			cx     <= (others => '0');
			valid  <= '0';
			fadd_a <= (others => '0');
			fadd_b <= (others => '0');
			fsub_a <= (others => '0');
			fsub_b <= (others => '0');
			fmul_a <= (others => '0');
			fmul_b <= (others => '0');
			cx_0   <= (others => '0');
			cx_1   <= (others => '0');
			cx_2   <= (others => '0');
			dx_3   <= (others => '0');
			
		elsif rising_edge(clk) then
			if clear = '1' then
        cx     <= (others => '0');
        valid  <= '0';
        fadd_a <= (others => '0');
        fadd_b <= (others => '0');
        fsub_a <= (others => '0');
        fsub_b <= (others => '0');
        fmul_a <= (others => '0');
        fmul_b <= (others => '0');
        cx_0   <= (others => '0');
        cx_1   <= (others => '0');
        cx_2   <= (others => '0');
        dx_3   <= (others => '0');
			  
			elsif enable = '1' then
				case cnt is
				  when 0 =>
					  fsub_a <= cx_min;
					  fsub_b <= dx;
					  fmul_a <= dx;
					  fmul_b <= "00000000000000000000000000000011";
            cnt    <= cnt + 1;
				  when 3 =>
				    cx_2 <= fsub_result;
					  dx_3 <= fmul_result;
					  fsub_a <= fsub_result;
					  fsub_b <= dx;
				    cnt <= cnt + 1;
				  when 6 =>
				    cx_1 <= fsub_result;
					  fsub_a <= fsub_result;
					  fsub_b <= dx;
				    cnt <= cnt + 1;
				  when 9 =>
				    cx_0 <= fsub_result;
					  fadd_a <= fsub_result;
					  fadd_b <= dx_3;
				    cnt <= cnt + 1;
				  when 10 =>
					  fadd_a <= cx_1;
					  fadd_b <= dx_3;
				    cnt <= cnt + 1;
				  when 11 =>
					  fadd_a <= cx_2;
					  fadd_b <= dx_3;
				    cnt <= cnt + 1;
				  when 12 to 811 =>
					  fadd_a <= fadd_result;
					  fadd_b <= dx_3;
				    valid  <= '1';
					  cx     <= fadd_result;
            cnt <= cnt + 1;
          when 812 =>
            valid <= '0';
            cx <= "00000000000000000000000000000000";
            cnt <= cnt;
				  when others =>
				    cnt <= cnt + 1;
				end case;
			end if;
		end if;
	end process;
	
end Behavioral;

