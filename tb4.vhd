library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity tb is
end tb;

architecture Behavioral of tb is
  constant CLK_PERIOD : time := 10 ns;
  constant K : integer := 8;

  type Matrix is array (0 to 2, 0 to 14) of integer;
  constant TestVectors : Matrix := (
    (45, 55, 65, 45, 55, 65, 45, 55, 65,45, 55, 65,45, 55, 65),
    (10, 8, 15, 8, 65, 15, 85, 10, 95, 1, 5, 8, 12, 11, 18),
    (170, 170, 170, 170, 170, 170, 170, 170, 170,170, 170, 170,170, 170, 170)
    );
  signal clk : std_logic := '0';
  signal reset : std_logic := '0';
  signal start : std_logic := '0';
  signal mat_in_a : std_logic_vector(K - 1 downto 0);
  signal mat_in_g : std_logic_vector(K - 1 downto 0);
  signal mat_in_r : std_logic_vector(K - 1 downto 0);
  signal mat_out : std_logic_vector(K - 1 downto 0);
  signal done : std_logic;

  signal stop_simulation : boolean := false;

begin
  -- Clock generation
  clk <= not clk after CLK_PERIOD / 2 when not stop_simulation;

  -- Reset generation
  reset <= '1', '0' after CLK_PERIOD;

  -- Instantiate the DUT
  UUT : entity work.top
    port map(
      clk     => clk,
      reset     => reset,
      start   => start,
      a_in    => mat_in_a,
      g_in    => mat_in_g,
      r_in    => mat_in_r,
      b_out => mat_out,
      done    => done
    );

  -- Test process
  test_process : process
    variable errors : integer := 0;
    variable a_val, r_val, g_val, expected_out : unsigned(K - 1 downto 0);
  begin
    wait for CLK_PERIOD;

    for i in 0 to 14 loop
      a_val := to_unsigned(TestVectors(0, i), K);
      g_val := to_unsigned(TestVectors(1, i), K);
      r_val := to_unsigned(TestVectors(2, i), K);

      expected_out := (a_val + r_val) xor r_val;

      wait until falling_edge(clk);
      mat_in_a <= std_logic_vector(a_val);
      mat_in_g <= std_logic_vector(g_val);
      mat_in_r <= std_logic_vector(r_val);
      start <= '1';

--      wait until rising_edge(clk);
--      start <= '0';

      wait until rising_edge(clk) and done = '1';

      if (unsigned(mat_out) xor r_val) /= (a_val + r_val) then
        errors := errors + 1;
        report "Error: Output mismatched at test " & integer'image(i + 1) & LF &
          "    Expected output: " & integer'image(to_integer(expected_out)) &
          " Actual output:" & integer'image(to_integer(unsigned(mat_out))) & LF severity error;
      else
        report "Output matched at test " & integer'image(i + 1) severity note;
      end if;

      --  OR:
      -- assert (unsigned(mat_out) xor r_val) = (a_val + r_val)
      -- report "Error: Output mismatched at test " & integer'image(i + 1) & LF &
      --   "    Expected output: " & integer'image(to_integer(expected_out)) &
      --   " Actual output:" & integer'image(to_integer(unsigned(mat_out))) & LF severity failure;

    end loop;

    report "Test completed with " & integer'image(errors) & " errors.";

    stop_simulation <= true;
    wait;
  end process;
end Behavioral;