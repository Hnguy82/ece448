library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Controller
entity controller is
    port (
    clk   : in STD_LOGIC;
    reset   : in STD_LOGIC;
    start  : in STD_LOGIC;
    done  : out STD_LOGIC;
    sel : out std_logic;
    ldk: out std_logic;
    enk : out std_logic;
    enO1 : out std_logic; 
    enO2 : out std_logic;
    enO3 : out std_logic;
    enG1 : out std_logic;
    enG2 : out std_logic;
    enG3 : out std_logic;
    enX : out std_logic;
    enT : out std_logic;
    zk : in std_logic
    );
end entity;

architecture FSM of controller is
    type state_type is (S0, S1, S2, S3, S4);
    signal state_reg, state_next : state_type;

begin
    process(clk, reset)
    begin
    if reset = '1' then
        state_reg <= S0;
    elsif rising_edge(clk) then
        state_reg <= state_next;
    end if;
    end process;

    process(state_reg, start, zk)
    begin
        state_next <= state_reg;
        sel<='-';
        ldk<='0';
        enk<='0';
        enO1<='0';
        enO2<='0';
        enO3<='0';
        enG1<='0';
        enG2<='0';
        enG3<='0';
        enX<='0';
        enT<='0';
   
        done<='0';
        case state_reg is
            when S0 =>
                if start = '1' then
                    state_next <= S1;
                    enG1<='1';
                    enO1<='1';
                    enX<='1';
                    enT<='1';
                    ldk<='1';
                    sel<='0';
                end if;
            when S1 =>
                enG2<='1';
                enO2<='1';
                state_next <= S2;
            when S2=>
                enG3<='1';
                enO3<='1';
                state_next <= S3;
            when S3 =>
                sel<='1';
                enT<='1';
                if zk='1' then
                    state_next<=S4;
                else
                    enk<='1';
                    state_next <= S2;
                end if;
            when S4 =>
                done<='1';
                state_next<=S0;
            when others =>
                state_next<=S0;
        end case;
    end process;
end architecture;