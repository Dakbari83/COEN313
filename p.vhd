library IEEE;
use ieee.numeric_std.all;
use IEEE.std_logic_1164.all;

entity three_k_plus_one is
  port(
    reset      : in  std_logic; -- asynchronous active-high
    clk        : in  std_logic;
    number_out : out unsigned(6 downto 0);
    term_out   : out unsigned(6 downto 0);
    done_out   : out std_logic
  );
end three_k_plus_one;

architecture one_clock_process of three_k_plus_one is
  signal number_reg : unsigned(6 downto 0);
  signal term_reg   : unsigned(6 downto 0);
  signal length_reg : unsigned(3 downto 0); -- holds sequence length (needs up to 9)
  signal done_reg   : std_logic;
begin

  process(reset, clk)
  begin
    if reset = '1' then
      number_reg <= to_unsigned(1, 7);
      term_reg   <= to_unsigned(1, 7);
      length_reg <= to_unsigned(1, 4);
      done_reg   <= '0';
    elsif rising_edge(clk) then
      if done_reg = '1' then
        -- freeze all registers when done
        number_reg <= number_reg;
        term_reg   <= term_reg;
        length_reg <= length_reg;
        done_reg   <= done_reg;
      else
        -- if current term is not 1, compute next term
        if term_reg /= to_unsigned(1,7) then
          if term_reg(0) = '0' then  -- even (LSB = 0)
            -- divide by 2: shift right; keep 7 bits by prepending '0'
            term_reg <= '0' & term_reg(6 downto 1);
            length_reg <= length_reg + 1;
          else
            -- odd: term = 3*term + 1 (resize result to 7 bits as per hints)
            term_reg <= resize(term_reg * 3 + to_unsigned(1,7), 7);
            length_reg <= length_reg + 1;
          end if;
        else -- term == 1: sequence ended for the current number
          if length_reg >= to_unsigned(9,4) then
            done_reg <= '1';
          else
            -- move to next number: number := number + 1; term := number; length := 1
            number_reg <= number_reg + 1;
            term_reg   <= number_reg + 1;
            length_reg <= to_unsigned(1,4);
          end if;
        end if;
      end if;
    end if;
  end process;

  -- outputs
  number_out <= number_reg;
  term_out   <= term_reg;
  done_out   <= done_reg;

end one_clock_process;
