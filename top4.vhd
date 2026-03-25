library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


-- top-Level Module
entity top is
    generic (
        K : positive := 8;
        LOG2K: positive := 3
    );
    port (
    clk   : in STD_LOGIC;
    reset   : in STD_LOGIC;
    start  : in STD_LOGIC;
    a_in  : in STD_LOGIC_VECTOR(K-1 downto 0);
    g_in  : in STD_LOGIC_VECTOR(K-1 downto 0);
    r_in  : in STD_LOGIC_VECTOR(K-1 downto 0);
    b_out : out STD_LOGIC_VECTOR(K-1 downto 0);
    done  : out STD_LOGIC
    );
end entity;

architecture Structural of top is
    signal ldk, enk, enO1, enO2, enO3, enG1, enG2, enG3, enX, enT, sel, zk : STD_LOGIC;

begin
    U1: entity work.datapath
    generic map (
        K => K,
        LOG2K => LOG2K
    )
    port map (
        clk   => clk,
        reset   => reset,
        a_in => a_in,
        g_in => g_in,
        r_in => r_in,
        sel => sel,
        ldk   => ldk,
        enk   => enk,
        enO1   => enO1,
        enO2   => enO2,
        enO3   => enO3,
        enG1   => enG1,
        enG2   => enG2,
        enG3   => enG3,
        enX   => enX,
        enT   => enT,
        zk => zk,
        b_out => b_out
    );

    U2: entity work.controller
    port map (
        clk   => clk,
        reset   => reset,
        start => start,
        done => done,
        sel => sel,
        ldk   => ldk,
        enk   => enk,
        enO1   => enO1,
        enO2   => enO2,
        enO3   => enO3,
        enG1   => enG1,
        enG2   => enG2,
        enG3   => enG3,
        enX   => enX,
        enT   => enT,
        zk => zk
    );

end architecture;

