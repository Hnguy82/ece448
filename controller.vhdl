library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.all;

entity controller is
    port(
        clock     : in  std_logic;
        reset     : in  std_logic;
        in_valid  : in  std_logic;
        in_ready  : out std_logic;
        out_valid : out std_logic;
        out_ready : in  std_logic;
        s_en : out std_logic;
        e_en : out std_logic;
        a_en : out std_logic;
        sel : out std_logic;
        mdgt0 : in std_logic;
        eq : in std_logic;
        gt : in std_logic;
        stgten : in std_logic
    );
end controller;

architecture behavioral of controller is

TYPE state is (IDLE,COMPUTE,DONE);
signal state_reg, state_next: state;

begin

    reg: process(clock, reset)
    begin
        if reset = '1' then
            state_reg <= IDLE; 
        elsif rising_edge(clock) then
            state_reg <= state_next;
        end if;
    end process;

    logic: process (state_reg, in_valid, mdgt0, eq, stgten, gt, out_ready)--put in state_reg and all inputs into sensitive list 
    begin
        --at begin nextstate = current stage and all outputs =0
		state_next <= state_reg;
        in_ready <= '0';
        out_valid <= '0';
        sel <= '0';
        s_en <= '0';
        a_en <= '0';
        e_en <= '0';
        case state_reg is
            when IDLE =>
                in_ready <= '1';
                if in_valid = '1' then
                    a_en <= '1';
                    s_en <= '1';
                    e_en <= '1';
                    state_next <= COMPUTE; -- start computation
                end if;
            when COMPUTE =>
                sel <= '1';
                if stgten = '1' then 
                    state_next <= DONE;
                elsif mdgt0 = '0' or (mdgt0 = '1' and eq = '1') then
                    a_en <= '1';
                    state_next <= DONE;
                elsif gt = '1' then
                    a_en <= '1';
                    s_en <= '1';
                else
                    e_en <= '1';
                end if;
            when DONE =>
                out_valid <= '1';
                if out_ready = '1' then
                    state_next <= IDLE; -- output was consumed, back to idle
                end if;
        end case;
    end process;

end behavioral;