library IEEE;
use IEEE.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity add_sub is
port ( in1, in2 : in std_logic_vector (3 downto 0);
	answer : out std_logic_vector (3 downto 0);
	overflow : out std_logic );
end add_sub;

architecture rtl of add_sub is
begin

process (in1, in2)
	variable s1, s2 : std_logic;
	variable mag1, mag2, diff3 : std_logic_vector (2 downto 0);
	variable sum4, res : std_logic_vector (3 downto 0);
begin
	-- extract sign and magnitude
	s1 := in1(3);
	s2 := in2(3);
	mag1 := in1(2 downto 0);
	mag2 := in2(2 downto 0);
	
	if s1 = s2 then
	-- easy case: same sign, we add the magnitudes
	sum4 := ('0' & mag1) + ('0' & mag2); -- 4-bit sum; bit 3 is carry out
	res(2 downto 0) := sum4(2 downto 0); -- magnitude bits
	res(3) := s1; -- the sign is just the sign of one of the operands
	
	-- overflow if carry out from magnitude addition
	if sum4(3) = '1' then
		overflow <= '1';
	else
		overflow <= '0';
	end if;
	
	else
	-- opposite signs: subtract magnitudes
	overflow <= '0'; -- never overflow for opposite signs
	
	if mag1 = mag2 then
		res := "0000";
	elsif mag1 > mag2 then
		diff3 := mag1 - mag2;
		res(2 downto 0) := diff3;
		res(3) := s1; -- sign will be the sign of the operand with larger magnitude
	else
		diff3 := mag2 - mag1;
		res(2 downto 0) := diff3;
		res(3) := not s1; -- sign will be the sign of the other operand
		end if;
	end if;
	
	answer <= res;
	end process;
end rtl;
