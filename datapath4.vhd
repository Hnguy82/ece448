library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity datapath is
    generic(K: positive := 8; 
            LOG2K: positive := 3);
    port (
        clk   : in STD_LOGIC;
        reset   : in STD_LOGIC;
        a_in  : in STD_LOGIC_VECTOR(K-1 downto 0);
        r_in  : in STD_LOGIC_VECTOR(K-1 downto 0);
        g_in  : in STD_LOGIC_VECTOR(K-1 downto 0); 
        sel : in std_logic;
        ldk: in std_logic;
        enk : in std_logic;
        enO1 : in std_logic;
        enO2 : in std_logic;
        enO3 : in std_logic;
        enG1 : in std_logic;
        enG2 : in std_logic;
        enG3 : in std_logic;
        enX : in std_logic;
        enT : in std_logic;
        b_out : out  STD_LOGIC_VECTOR(K-1 downto 0); 
        zk : out std_logic
    );
end entity;

architecture Behavioral of datapath is
    signal O1_reg, O2_reg, O3_reg, G1_reg, G2_reg, G3_reg, T_reg, TB_reg: std_logic_vector(K-1 downto 0);
    signal O1_next, O2_next, O3_next, G1_next, G2_next, G3_next, T_next, TB_next: std_logic_vector(K-1 downto 0);
    signal T0,T1,initT1, initX : std_logic_vector(K-1 downto 0); 
    signal counter : unsigned(LOG2K-1 downto 0);

    begin
        T0 <= g_in(K-2 downto 0) & '0' ; 
        G1_next <= (T0 xor a_in) xor g_in; 
        O1_next <= g_in and not(r_in); 
        G2_next <= (T0 and a_in);
        O2_next <= (G1_reg and r_in) xor O1_reg; 
        O3_next <= (O2_reg xor G2_reg) xor (T_reg and r_in);
        G3_next <= (T_reg and a_in);
        initT1 <= G3_reg xor O3_reg; 
        T1 <= initT1 (K-2 downto 0) & '0' ;
        initX <=  T0 xor a_in; 
        TB_next <= initX;
        T_next <= T0 when sel='0' else T1;
        b_out <= TB_reg xor T_reg;
        zk <= '1' when to_integer(counter) = K-1 else '0'; 
        
        O1_reg_inst : PROCESS(clk, reset)
        begin
            if reset = '1' then
                O1_reg <= (others => '0');
            elsif rising_edge(clk) then
                if enO1 = '1' then
                    O1_reg <= O1_next;
                end if;
            end if;
        end process;

        O2_reg_inst: PROCESS(clk,reset)
        begin
            if reset = '1' then 
                O2_reg <= (others => '0');
            elsif rising_edge(clk) then
                if enO2 = '1' then
                    O2_reg <= O2_next;
                end if;
            end if;
        end process;

        O3_reg_inst: PROCESS(clk,reset)
        begin
            if reset = '1' then 
                O3_reg <= (others => '0');
            elsif rising_edge(clk) then
                if enO3 = '1' then
                    O3_reg <= O3_next;
                end if;
            end if;
        end process;

        G1_reg_inst : PROCESS(clk, reset)
        begin
            if reset = '1' then
                G1_reg <= (others => '0');
            elsif rising_edge(clk) then
                if enG1 = '1' then
                    G1_reg <= G1_next;
                end if;
            end if;
        end process;

        G2_reg_inst: PROCESS(clk,reset)
        begin
            if reset = '1' then 
                G2_reg <= (others => '0');
            elsif rising_edge(clk) then
                if enG2 = '1' then
                    G2_reg <= G2_next;
                end if;
            end if;
        end process;

        G3_reg_inst: PROCESS(clk,reset)
        begin
            if reset = '1' then 
                G3_reg <= (others => '0');
            elsif rising_edge(clk) then
                if enG3 = '1' then
                    G3_reg <= G3_next;
                end if;
            end if;
        end process;

        TB_reg_inst: PROCESS(clk,reset)
        begin
            if reset = '1' then 
                TB_reg <= (others => '0');
            elsif rising_edge(clk) then
                if enX = '1' then
                    TB_reg <= TB_next;
                end if;
            end if;
        end process;

        T_reg_inst: PROCESS(clk,reset)
        begin
            if reset = '1' then 
                T_reg <= (others => '0');
            elsif rising_edge(clk) then
                if enT = '1' then
                    T_reg <= T_next;
                end if;
            end if;
        end process;

        C_counter: process(clk,reset)
        begin
            if reset = '1' then 
                counter <= (others => '0');
            elsif rising_edge(clk) then
                if ldk = '1' then
                    counter <= (others => '0');
                elsif enk = '1' then
                    counter <= counter + 1;
                end if;          
            end if;
        end process;

    end architecture;
