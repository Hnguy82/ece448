library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.all;

entity datapath is
    generic(
        W:integer := 16
    );
    port(
        clock : in  std_logic;
        in_data : in  std_logic_vector(W - 1 downto 0);
        s_en : in std_logic;
        e_en : in std_logic;
        a_en : in std_logic;
        sel: in std_logic;
        mdgt0 : out std_logic;
        stgten : out std_logic;
        eq : out std_logic;
        gt : out std_logic;
        out_sqrt : out std_logic_vector((W + 1) / 2 - 1 downto 0);
        out_rem : out std_logic_vector((W + 1) / 2 downto 0)   
    );
end datapath;

architecture mixed of datapath is
	--number of reg = number of reg signal, temp signal 
    signal start_reg, end_reg, ans_reg, rem_reg, mid_temp, start_temp, end_temp, sqd, rem_temp, ans_temp : std_logic_vector(W - 1 downto 0);

begin

    mid_temp <= std_logic_vector((unsigned(start_reg) + unsigned(end_reg)) srl 1);
    mdgt0 <= '1' when unsigned(mid_temp) > 0 else '0';
    sqd <= std_logic_vector(resize(unsigned(in_data) / unsigned(mid_temp), sqd'length)) when mdgt0='1' else (others => '0');
    rem_temp <= std_logic_vector(resize(unsigned(in_data) - resize(unsigned(mid_temp) * unsigned(mid_temp), in_data'length), in_data'length)) when mdgt0='1' else (others=>'0');
    start_temp <= std_logic_vector(unsigned(mid_temp) + 1) when sel='1' else (others=>'0');
    end_temp <= std_logic_vector(unsigned(mid_temp) - 1) when sel='1' else in_data;
    ans_temp <= mid_temp when mdgt0='1' else in_data;
    eq <= '1' when unsigned(sqd) = unsigned(mid_temp) else '0';
    gt <= '1' when unsigned(sqd) > unsigned(mid_temp) else '0';
    stgten <= '1' when unsigned(start_reg) > unsigned(end_reg) else '0';


    start_reg_inst : PROCESS(clock)
    begin
        if rising_edge(clock) then
            if s_en = '1' then
                   start_reg <= start_temp;
            end if;
        end if;
    end process;

    end_reg_inst : PROCESS(clock)
    begin
        if rising_edge(clock) then
            if e_en = '1' then
                end_reg <= end_temp;
            end if;
        end if;
    end process;

    ans_reg_inst : PROCESS(clock)
    begin
        if rising_edge(clock) then
            if a_en = '1' then
                ans_reg <= ans_temp;
            end if;
        end if;
    end process;

    rem_reg_inst : PROCESS(clock)
    begin
        if rising_edge(clock) then
            if a_en = '1' then
                rem_reg <= rem_temp;
            end if;
        end if;
    end process;

    out_sqrt <= std_logic_vector(ans_reg((W + 1) / 2 - 1 downto 0));
    out_rem  <= std_logic_vector(rem_reg((W + 1) / 2 downto 0));

end mixed;