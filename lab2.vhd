library IEEE;
use IEEE.std_logic_1164.all;


entity sum_of_minterms is
port(a,b,c : in std_logic;
	output : out std_logic);
end sum_of_minterms;

architecture structural of sum_of_minterms is
	component three_input_and
	port(x,y,z : in std_logic;
		f : out std_logic);
	end component;
	
	component three_input_or
	port(p,q,r : in std_logic;
		f : out std_logic);
	end component;
	
	signal na, nb, nc : std_logic;
	signal t1, t2, t3 : std_logic;
	
begin 
	na <= not a;
	nb <= not b;
	nc <= not c;
	
	and1: three_input_and port map (
		x => na,
		y => nb,
		z => c,
		f => t1 );
		
	and2: three_input_and port map(
		x => na,
		y => b,
		z => c,
		f => t2);
		
	and3: three_input_and port map(
		x => a,
		y => b,
		z => c,
		f => t3);
		
	or1: three_input_or port map(
		p => t1,
		q => t2,
		r => t3,
		f => output);
end structural;
