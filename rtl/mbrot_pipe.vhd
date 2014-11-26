library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mbrot_pipe is
  generic( num_cx     : integer := 800;
           num_stages : integer := 16);
    Port ( clk        : in   STD_LOGIC;
           reset      : in   STD_LOGIC;
           clear      : in   STD_LOGIC;
           valid_in   : in   STD_LOGIC;
           cx         : in   STD_LOGIC_VECTOR (31 downto 0);
           cy         : in   STD_LOGIC_VECTOR (31 downto 0);
           zx         : out  STD_LOGIC_VECTOR (31 downto 0);
           zy         : out  STD_LOGIC_VECTOR (31 downto 0);
           valid_out  : out  STD_LOGIC;
           compare    : out  STD_LOGIC_VECTOR ((num_stages-1) downto 0));
end mbrot_pipe;

architecture Behavioral of mbrot_pipe is

component mbrot_pipe_element is
  generic( num_cx    : integer := 800);
    Port ( clk       : in   STD_LOGIC;
           reset     : in   STD_LOGIC;
           clear     : in   STD_LOGIC;
           valid_in  : in   STD_LOGIC;
           cx        : in   STD_LOGIC_VECTOR (31 downto 0);
           cy        : in   STD_LOGIC_VECTOR (31 downto 0);
           zx_in     : in   STD_LOGIC_VECTOR (31 downto 0);
           zy_in     : in   STD_LOGIC_VECTOR (31 downto 0);
           zx_out    : out  STD_LOGIC_VECTOR (31 downto 0);
           zy_out    : out  STD_LOGIC_VECTOR (31 downto 0);
           compare   : out  STD_LOGIC;
           valid_out : out  STD_LOGIC);
end component;

type e_out is array ((num_stages-1) downto 0) of STD_LOGIC_VECTOR(31 downto 0);
signal e_zx_out, e_zy_out: e_out;
signal e_valid_out: STD_LOGIC_VECTOR((num_stages-1) downto 0);

begin

GEN_ELEMENTS: for i in 0 to (num_stages-1) generate

  FIRST: if i = 0 generate
    MBROT_PIPE_ELEMENT_I: mbrot_pipe_element
      generic map (num_cx => num_cx)
      port map    (clk       => clk,
                   reset     => reset,
                   clear     => clear,
                   valid_in  => valid_in,
                   cx        => cx,
                   cy        => cy,
                   zx_in     => cx,
                   zy_in     => cy,
                   zx_out    => e_zx_out(i),
                   zy_out    => e_zy_out(i),
                   compare   => compare(i),
                   valid_out => e_valid_out(i));
  end generate FIRST;
  
  MIDDLE: if i > 0 and i < (num_stages-1) generate
    MBROT_PIPE_ELEMENT_I: mbrot_pipe_element
      generic map (num_cx => num_cx)
      port map    (clk       => clk,
                   reset     => reset,
                   clear     => clear,
                   valid_in  => e_valid_out(i-1),
                   cx        => cx,
                   cy        => cy,
                   zx_in     => e_zx_out(i-1),
                   zy_in     => e_zy_out(i-1),
                   zx_out    => e_zx_out(i),
                   zy_out    => e_zy_out(i),
                   compare   => compare(i),
                   valid_out => e_valid_out(i));
  end generate MIDDLE;
  
  LAST: if i = (num_stages-1) generate
    MBROT_PIPE_ELEMENT_I: mbrot_pipe_element
      generic map (num_cx => num_cx)
      port map    (clk       => clk,
                   reset     => reset,
                   clear     => clear,
                   valid_in  => e_valid_out(i-1),
                   cx        => cx,
                   cy        => cy,
                   zx_in     => e_zx_out(i-1),
                   zy_in     => e_zy_out(i-1),
                   zx_out    => zx,
                   zy_out    => zy,
                   compare   => compare(i),
                   valid_out => valid_out);
  end generate LAST;
  
end generate GEN_ELEMENTS;

end Behavioral;
