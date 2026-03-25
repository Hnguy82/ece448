library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity square_root is
    generic (
        W : positive := 16
    );
    port (
        clock     : in  std_logic;
        reset     : in  std_logic;
        in_data   : in  std_logic_vector(W - 1 downto 0);
        in_valid  : in  std_logic;
        in_ready  : out std_logic;
        out_sqrt  : out std_logic_vector((W + 1) / 2 - 1 downto 0); -- ceil(W / 2) bits
        out_rem   : out std_logic_vector((W + 1) / 2 downto 0);     -- ceil(W / 2) + 1 bits
        out_valid : out std_logic;
        out_ready : in  std_logic
    );
end entity;

architecture structural of square_root is

signal sel : std_logic;
signal a_en : std_logic;
signal s_en : std_logic;
signal e_en : std_logic;
signal mdgt0 : std_logic;
signal eq : std_logic;
signal gt : std_logic;
signal stgten : std_logic;

begin

dtpt: entity work.datapath(mixed)
generic map(
    W => W
)
port map(
    clock => clock,
    in_data => in_data,
    s_en => s_en,
    a_en => a_en,
    e_en => e_en,
    sel => sel,
    mdgt0 => mdgt0,
    eq => eq,
    gt => gt,
    stgten => stgten,
    out_rem => out_rem,
    out_sqrt => out_sqrt
);

ctlr: entity work.controller(behavioral)
port map(
    clock => clock,
    reset => reset,
    in_valid => in_valid,
    in_ready => in_ready,
    out_valid => out_valid,
    out_ready => out_ready,
    s_en => s_en,
    a_en => a_en,
    e_en => e_en,
    sel => sel,
    mdgt0 => mdgt0,
    eq => eq,
    gt => gt,
    stgten => stgten
);


end structural;