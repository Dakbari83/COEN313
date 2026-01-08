library IEEE;
use ieee.numeric_std.all;
use IEEE.std_logic_1164.all;

entity three_k_plus_one is
port( reset      : in std_logic;
      clk        : in std_logic;
      number_out : out unsigned(6 downto 0);
      term_out   : out unsigned(6 downto 0);
      done_out   : out std_logic);
end three_k_plus_one;

architecture asm_design of three_k_plus_one is
    type state_type is (reset_state, test_state, increment, reload_term, 
                        generate_term, div_by_2, mult_add, done_state);
    signal state, next_state : state_type;
    signal number : unsigned(6 downto 0);
    signal term   : unsigned(6 downto 0);
    signal length : unsigned(3 downto 0);
    signal done   : std_logic;
    signal reset_number, inc_number : std_logic;
    signal reset_term, load_term, shift_term, mult_term : std_logic;
    signal reset_length, inc_length : std_logic;
    signal reset_done, load_done : std_logic;
    signal term_is_one, term_is_even, length_ge_9 : std_logic;
begin
    -- NUMBER register
    process(clk, reset)
    begin
        if reset = '1' then number <= "0000001";
        elsif clk'event and clk = '1' then
            if reset_number = '1' then number <= "0000001";
            elsif inc_number = '1' then number <= number + 1;
            end if;
        end if;
    end process;

    -- TERM register
    process(clk, reset)
    begin
        if reset = '1' then term <= "0000001";
        elsif clk'event and clk = '1' then
            if reset_term = '1' then term <= "0000001";
            elsif load_term = '1' then term <= number;
            elsif shift_term = '1' then term <= '0' & term(6 downto 1);
            elsif mult_term = '1' then term <= resize(3 * term + 1, 7);
            end if;
        end if;
    end process;

    -- LENGTH register
    process(clk, reset)
    begin
        if reset = '1' then length <= "0001";
        elsif clk'event and clk = '1' then
            if reset_length = '1' then length <= "0001";
            elsif inc_length = '1' then length <= length + 1;
            end if;
        end if;
    end process;

    -- DONE register
    process(clk, reset)
    begin
        if reset = '1' then done <= '0';
        elsif clk'event and clk = '1' then
            if reset_done = '1' then done <= '0';
            elsif load_done = '1' then done <= '1';
            end if;
        end if;
    end process;

    -- Status signals
    term_is_one  <= '1' when term = "0000001" else '0';
    term_is_even <= not term(0);
    length_ge_9  <= '1' when length >= "1001" else '0';

    -- State register
    process(clk, reset)
    begin
        if reset = '1' then state <= reset_state;
        elsif clk'event and clk = '1' then state <= next_state;
        end if;
    end process;

    -- Next state and output logic
    process(state, term_is_one, term_is_even, length_ge_9)
    begin
        reset_number<='0'; inc_number<='0'; reset_term<='0'; load_term<='0';
        shift_term<='0'; mult_term<='0'; reset_length<='0'; inc_length<='0';
        reset_done<='0'; load_done<='0'; next_state<=state;
        
        case state is
            when reset_state =>
                reset_number<='1'; reset_term<='1'; reset_length<='1'; reset_done <= '0';
                next_state <= test_state;
            when increment =>
                inc_number <= '1'; next_state <= reload_term;
            when reload_term =>
                load_term<='1'; reset_length<='1'; next_state <= test_state;
            when test_state =>
                if term_is_one='1' then
                    if length_ge_9='1' then next_state<=done_state;
                    else next_state<=increment; end if;
                else next_state<=generate_term; end if;
            when generate_term =>
                if term_is_even='1' then next_state<=div_by_2;
                else next_state<=mult_add; end if;
            when div_by_2 =>
                shift_term<='1'; inc_length<='1'; next_state<=test_state;
            when mult_add =>
                mult_term<='1'; inc_length<='1'; next_state<=test_state;
            when done_state =>
                load_done<='1'; next_state<=done_state;
            when others => next_state<=reset_state;
        end case;
    end process;

    number_out <= number; term_out <= term; done_out <= done;
end asm_design;
