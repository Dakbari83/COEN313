library IEEE;
use IEEE.std_logic_1164.all;
use ieee.std_logic_unsigned.all; 

entity add_sub2 is
  port (
    in1      : in  std_logic_vector(3 downto 0);
    in2      : in  std_logic_vector(3 downto 0);
    answer   : out std_logic_vector(3 downto 0);
    overflow : out std_logic
  );
end add_sub2;

architecture rtl of add_sub2 is
begin
  
  process(in1, in2)

  begin
    -- default outputs
    answer <= (others => '0');
    overflow <= '0';

    -- extract sign and magnitude bits
   

    -- same sign -> add magnitudes
    if in1(3) = in2(3) then
      

     

      -- Write results to answer bits
      answer(0) <= in1(0) xor in2(0);
      -- carry1
      -- c1 = a0 and b0
      -- sum1 uses c1
      answer(1) <= in1(1) xor in2(1) xor (in1(0) and in2(0));

      -- carry2 = (a1 and b1) or ((a1 xor b1) and c1)
      -- where c1 = in1(0) and in2(0)
      overflow <= ((in1(2) and in2(2)) or ((in1(2) xor in2(2)) and
                   ((in1(1) and in2(1)) or ((in1(1) xor in2(1)) and (in1(0) and in2(0))))));

      -- sum2 = a2 xor b2 xor carry2
      -- carry2 expression reused from overflow's inner part (extract as expression)
      -- build carry2 expression explicitly to compute sum2
      answer(2) <= in1(2) xor in2(2) xor ((in1(1) and in2(1)) or ((in1(1) xor in2(1)) and (in1(0) and in2(0))));

      -- sign is the common sign
      answer(3) <= in1(3);

    else
      -- opposite signs: compare magnitudes (bitwise comparator)
      -- compare from MSB to LSB
      if (in1(2) /= in2(2)) then
        -- bigger is the one with '1' in bit2
        if in1(2) = '1' then
          -- in1 magnitude > in2 magnitude -> result = in1 - in2, sign = sign(in1)
          -- perform 3-bit subtraction a - b
          -- diff0 = a0 xor b0
          -- borrow1 = (not a0) and b0
          answer(0) <= in1(0) xor in2(0);
          -- borrow1
          -- b1 = (not a0) and b0
          answer(1) <= in1(1) xor in2(1) xor ((not in1(0)) and in2(0));
          -- borrow2 = ((not a1) and b1) or ((not (a1 xor b1)) and borrow1)
          -- compute borrow2 as expression
          answer(2) <= in1(2) xor in2(2) xor (
                          ((not in1(1)) and in2(1)) or ((not (in1(1) xor in2(1))) and ((not in1(0)) and in2(0)))
                        );
          answer(3) <= in1(3);
          overflow <= '0';
        else
          -- in2(2) = '1' and in1(2) = '0' -> in2 bigger
          -- result = in2 - in1, sign = sign(in2)
          answer(0) <= in2(0) xor in1(0);
          answer(1) <= in2(1) xor in1(1) xor ((not in2(0)) and in1(0));
          answer(2) <= in2(2) xor in1(2) xor (
                          ((not in2(1)) and in1(1)) or ((not (in2(1) xor in1(1))) and ((not in2(0)) and in1(0)))
                        );
          answer(3) <= in2(3);
          overflow <= '0';
        end if;

      elsif (in1(1) /= in2(1)) then
        -- bit2 equal, compare bit1
        if in1(1) = '1' then
          -- in1 bigger
          answer(0) <= in1(0) xor in2(0);
          answer(1) <= in1(1) xor in2(1) xor ((not in1(0)) and in2(0));
          answer(2) <= in1(2) xor in2(2) xor (
                          ((not in1(1)) and in2(1)) or ((not (in1(1) xor in2(1))) and ((not in1(0)) and in2(0)))
                        );
          answer(3) <= in1(3);
          overflow <= '0';
        else
          -- in2 bigger
          answer(0) <= in2(0) xor in1(0);
          answer(1) <= in2(1) xor in1(1) xor ((not in2(0)) and in1(0));
          answer(2) <= in2(2) xor in1(2) xor (
                          ((not in2(1)) and in1(1)) or ((not (in2(1) xor in1(1))) and ((not in2(0)) and in1(0)))
                        );
          answer(3) <= in2(3);
          overflow <= '0';
        end if;

      else
        -- bits 2 and 1 equal, compare bit0 or equal
        if (in1(0) /= in2(0)) then
          if in1(0) = '1' then
            -- in1 > in2
            answer(0) <= '1'; -- 1 xor 0 = 1
            answer(1) <= '0';
            answer(2) <= '0';
            answer(3) <= in1(3);
            overflow <= '0';
          else
            -- in2 > in1
            answer(0) <= '1';
            answer(1) <= '0';
            answer(2) <= '0';
            answer(3) <= in2(3);
            overflow <= '0';
          end if;
        else
          -- magnitudes equal -> result = +0
          answer <= "0000";
          overflow <= '0';
        end if;
      end if;
    end if;
  end process;
end rtl;
