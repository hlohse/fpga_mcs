--------------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
USE ieee.numeric_std.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- inner loop of mandelbroot
-- cx is parameter from higher level
-- zx = 0.0; 
-- zy = 0.0; 
-- n = 0;
-- while ((zx*zx + zy*zy < 4.0) && (n != UCHAR_MAX)) {
--   new_zx = zx*zx - zy*zy + cx;
--   zy = 2.0*zx*zy + cy;
--   zx = new_zx;
--   n++;
-- }

-- input  is standard single precision float (sign, 8 bit exponent, 23 bit fraction)
-- all fp comps have 3 cycles latency for max speed just above 100MHz
-- does work with 2 cycles up to 80MHz


 
ENTITY mbrot IS
generic (maxDsp: integer := 1; latency: integer := 3);
port (

	cx   : in STD_LOGIC_VECTOR(31 DOWNTO 0) := (others => '0');
	cy   : in STD_LOGIC_VECTOR(31 DOWNTO 0) := (others => '0');
	nmax : in STD_LOGIC_VECTOR(31 DOWNTO 0) := (others => '0');
	n    : out STD_LOGIC_VECTOR(31 DOWNTO 0) := (others => '0');
	done : out std_logic;
	clk  : in std_logic := '0';
	rst  : in std_logic := '1'
);
END mbrot;
 
ARCHITECTURE behavior OF mbrot IS 


COMPONENT itof
  PORT (
    a : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    clk : IN STD_LOGIC;
    result : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
  );
END COMPONENT;
COMPONENT fcmpless
  PORT (
    a : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    b : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    clk : IN STD_LOGIC;
    result : OUT STD_LOGIC_VECTOR(0 DOWNTO 0)
  );
END COMPONENT;

COMPONENT fsub
  PORT (
    a : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    b : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    clk : IN STD_LOGIC;
    result : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
  );
END COMPONENT;
COMPONENT fmul
  PORT (
    a : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    b : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    clk : IN STD_LOGIC;
    result : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
  );
END COMPONENT;
COMPONENT fadd
  PORT (
    a : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    b : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    clk : IN STD_LOGIC;
    result : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
  );
END COMPONENT;

COMPONENT itof_l3
  PORT (
    a : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    clk : IN STD_LOGIC;
    result : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
  );
END COMPONENT;
COMPONENT fsub_l3
  PORT (
    a : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    b : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    clk : IN STD_LOGIC;
    result : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
  );
END COMPONENT;
COMPONENT fmul_l3
  PORT (
    a : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    b : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    clk : IN STD_LOGIC;
    result : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
  );
END COMPONENT;
COMPONENT fmul_nd_l3 -- no dsp
  PORT (
    a : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    b : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    clk : IN STD_LOGIC;
    result : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
  );
END COMPONENT;
COMPONENT fadd_l3
  PORT (
    a : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    b : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    clk : IN STD_LOGIC;
    result : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
  );
END COMPONENT;


constant cmax: STD_LOGIC_VECTOR(31 DOWNTO 0) := (2 => '1', others => '0'); -- 4
constant cmul2: STD_LOGIC_VECTOR(31 DOWNTO 0) := (1 => '1', others => '0'); -- 2
constant cnull: STD_LOGIC_VECTOR(31 DOWNTO 0) := (others => '0'); -- 

signal fmax: STD_LOGIC_VECTOR(31 DOWNTO 0);
signal fmul2: STD_LOGIC_VECTOR(31 DOWNTO 0);
signal fnull: STD_LOGIC_VECTOR(31 DOWNTO 0);
signal fnull_r1: STD_LOGIC_VECTOR(31 DOWNTO 0); -- make registered copy
signal fnull_r2: STD_LOGIC_VECTOR(31 DOWNTO 0);

signal zx   : STD_LOGIC_VECTOR(31 DOWNTO 0) := (others => '0');
signal zy   : STD_LOGIC_VECTOR(31 DOWNTO 0) := (others => '0');
signal xsqr, ysqr: STD_LOGIC_VECTOR(31 DOWNTO 0);
signal xy, xy2: STD_LOGIC_VECTOR(31 DOWNTO 0);
signal sqrsum, sqrdiff: STD_LOGIC_VECTOR(31 DOWNTO 0);
signal cxdiff, cymul: STD_LOGIC_VECTOR(31 DOWNTO 0);
signal n_i : STD_LOGIC_VECTOR(15 DOWNTO 0) := (others => '0');
signal nmax_i : STD_LOGIC_VECTOR(15 DOWNTO 0) := (others => '0');
signal cmpless :STD_LOGIC_VECTOR(0 DOWNTO 0);
signal cmpless_0 :STD_LOGIC_VECTOR(0 DOWNTO 0);
signal done_i: std_logic;
signal update: std_logic;

signal cnt: integer range 0 to 15;

constant maxCnt_l2: integer := 6;
constant maxCnt_l3: integer := 9;

function getMaxCnt return integer is
begin
	if latency = 2 then
		return maxCnt_l2;
	elsif latency = 3 then
		return maxCnt_l3;
	else
		assert false report "Invalid latency" severity error;
		return 0;
	end if;
end function; 

BEGIN

-- loop control
process
begin
	wait until rising_edge(clk);
	if rst = '1' then
		cnt <= 1;
		done_i <= '0';
		update <= '0';
		n_i <= (others => '0');
		--zx <= fnull;
		--zy <= fnull;
	elsif done_i = '0' then
		cnt <= cnt + 1;
		if cnt = getMaxCnt then
			cnt <= 1;
			-- zx <= cxdiff;
			-- zy <= cymul;
			n_i <= n_i + 1;
			update <= '1'; -- allow update after 2st iteration
		elsif cnt = 1 then
			if ((cmpless(0) = '0') and (update = '1')) or (n_i = nmax_i) then -- -- terminate on compare not less
				done_i <= '1';
				n_i <= n_i - 1;	-- correction
			end if;
		end if;
	end if;
end process;

-- copy null value to registers to improve timing
process
begin
	wait until rising_edge(clk);
	fnull_r1 <= fnull;
	fnull_r2 <= fnull;
end process;

-- update mux
	zx <= cxdiff when update = '1' else fnull_r1;
	zy <= cymul when  update = '1' else fnull_r2;

-- output map
	nmax_i <= nmax(15 downto 0);
	n <= X"0000" & n_i;
	done <= done_i;


itof_1 : itof_l3
  PORT MAP (
    a => cmax,
    clk => clk,
    result => fmax
  );
itof_2 : itof_l3
  PORT MAP (
    a => cmul2,
    clk => clk,
    result => fmul2
  );
itof_3 : itof_l3
  PORT MAP (
    a => cnull,
    clk => clk,
    result => fnull
  );



latency3: if latency = 3 generate
begin
-- use no-dsp multipler for squares and constant

withoutDsp: if maxDsp = 0 generate
	begin
	fmul_1 : fmul_nd_l3
	  PORT MAP (
		 a => zx,
		 b => zx,
		 clk => clk,
		 result => xsqr
	  );

	fmul_2 : fmul_nd_l3
	  PORT MAP (
		 a => zy,
		 b => zy,
		 clk => clk,
		 result => ysqr
	  );

	fmul_3 : fmul_nd_l3
	  PORT MAP (
		 a => xy,
		 b => fmul2,
		 clk => clk,
		 result => xy2
	  );
end generate;

noDsp: if maxDsp /= 0 generate
	begin
	fmul_1 : fmul_l3
	  PORT MAP (
		 a => zx,
		 b => zx,
		 clk => clk,
		 result => xsqr
	  );

	fmul_2 : fmul_l3
	  PORT MAP (
		 a => zy,
		 b => zy,
		 clk => clk,
		 result => ysqr
	  );

	fmul_3 : fmul_l3
	  PORT MAP (
		 a => xy,
		 b => fmul2,
		 clk => clk,
		 result => xy2
	  );
end generate;

fmul_4 : fmul_l3
  PORT MAP (
    a => zx,
    b => zy,
    clk => clk,
    result => xy
  );



fadd_1 : fadd_l3
  PORT MAP (
    a => xsqr,
    b => ysqr,
    clk => clk,
    result => sqrsum
  );

fadd_2 : fadd_l3
  PORT MAP (
    a => xy2,
    b => cy,
    clk => clk,
    result => cymul
  );

fadd_3 : fadd_l3
  PORT MAP (
    a => sqrdiff,
    b => cx,
    clk => clk,
    result => cxdiff
  );

fsub_1 : fsub_l3
  PORT MAP (
    a => xsqr,
    b => ysqr,
    clk => clk,
    result => sqrdiff
  );

-- compare has only 2 cycles. need additional delay
fcmp_1 : fcmpless
  PORT MAP (
    a => sqrsum,
    b => fmax,
    clk => clk,
    result => cmpless_0
  );
  process
  begin
    wait until rising_edge(clk);
    cmpless <= cmpless_0;
  end process;
  
end generate;

latency2: if latency = 2 generate
begin
fmul_1 : fmul
  PORT MAP (
    a => zx,
    b => zx,
    clk => clk,
    result => xsqr
  );

fmul_2 : fmul
  PORT MAP (
    a => zy,
    b => zy,
    clk => clk,
    result => ysqr
  );

fmul_3 : fmul
  PORT MAP (
    a => zx,
    b => zy,
    clk => clk,
    result => xy
  );

fmul_4 : fmul
  PORT MAP (
    a => xy,
    b => fmul2,
    clk => clk,
    result => xy2
  );


fadd_1 : fadd
  PORT MAP (
    a => xsqr,
    b => ysqr,
    clk => clk,
    result => sqrsum
  );

fadd_2 : fadd
  PORT MAP (
    a => xy2,
    b => cy,
    clk => clk,
    result => cymul
  );

fadd_3 : fadd
  PORT MAP (
    a => sqrdiff,
    b => cx,
    clk => clk,
    result => cxdiff
  );

fsub_1 : fsub
  PORT MAP (
    a => xsqr,
    b => ysqr,
    clk => clk,
    result => sqrdiff
  );

fcmp_1 : fcmpless
  PORT MAP (
    a => sqrsum,
    b => fmax,
    clk => clk,
    result => cmpless
  );
end generate;


 
 
END;
