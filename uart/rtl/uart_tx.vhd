library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity uart_tx is
  generic (
    g_CLKS_PER_BIT : integer := 115 -- Sampling speed for each bit sent. Needs to be set correctly.
  );
  port (
    i_clk           : in std_logic;
    i_tx_data_valid : in std_logic;
    i_tx_byte       : in std_logic_vector(7 downto 0);
    o_tx_active     : out std_logic;
    o_tx_serial     : out std_logic;
    o_tx_done       : out std_logic
  );
end uart_tx;

architecture RTL of uart_tx is

  type t_fsm_main is (s_idle, s_tx_start_bit, s_tx_data_bits,
    s_tx_stop_bit, s_cleanup); -- FSM states

  signal r_fsm_main : t_sm_main := s_idle; -- Current state of the FSM

  signal r_clk_count : integer range 0 to g_CLKS_PER_BIT - 1 := 0; -- Clock pulse counter for each bit sent

  signal r_bit_index : integer range 0 to 7 := 0; -- Index of the bit being sent

  signal r_tx_data : std_logic_vector(7 downto 0) := (others => '0'); -- Bits to be sent

  signal r_tx_done : std_logic := '0'; -- Done flag

begin

  p_uart_tx : process (i_clk)
  begin
    if rising_edge(i_clk) then

      case t_fsm_main is
        when s_idle =>
          o_tx_active = '0'; -- UART is not active
          o_tx_serial = '1'; -- UART idle state is high
          r_tx_done = '0'; -- Not done because hasn't started yet
          r_clk_count = '0'; -- Not transmitting yet
          r_bit_index = '0'; -- Not transmitting yet
          if i_tx_data_valid = '1' then
            r_tx_data  <= i_tx_byte;
            r_fsm_main <= s_tx_start_bit;
          else
            r_fsm_main <= s_idle;
          end if;

        when s_tx_start_bit =>
      end case;
    end if;
  end process;

end architecture;
