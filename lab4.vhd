library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity registers_min_max is
port(din : in std_logic_vector(3 downto 0);
	reset : in std_logic;
	clk : in std_logic;
	sel : in std_logic_vector(1 downto 0);
	max_out : out std_logic_vector(3 downto 0);
	min_out : out std_logic_vector(3 downto 0);
	reg_out : out std_logic_vector(3 downto 0) );
end registers_min_max;

architecture behavioural of registers_min_max is

	type reg_array_t is array (0 to 3) of std_logic_vector(3 downto 0); -- array for the register file is easy to scale
	
	signal regs : reg_array_t := (others => "1000"); -- reset value
	
	signal comb_max : std_logic_vector(3 downto 0);
	signal comb_min : std_logic_vector(3 downto 0);
	
	signal max_reg_s : std_logic_vector(3 downto 0);
	signal min_reg_s : std_logic_vector(3 downto 0);
	
begin

	process(clk, reset) -- for shift register
	begin
		if reset = '1' then
			regs <= (others => "1000"); -- resetting all 4 regs to "1000"
		elsif (clk'event and clk = '1') then -- shift register
			regs(3) <= regs(2);
			regs(2) <= regs(1);
			regs(1) <= regs(0);
			regs(0) <= din;
		end if;
	end process;
	
	process(regs) -- to compute max and min
		variable v_max : std_logic_vector(3 downto 0);
		variable v_min : std_logic_vector(3 downto 0);
		variable i : integer;

	begin
		v_max := regs(0);
		v_min := regs(0);
		
		for i in 1 to 3 loop
			if regs(i) > v_max then
				v_max := regs(i);
			end if;
			if regs(i) < v_min then
				v_min := regs(i);
			end if;
		end loop;
		
		comb_max <= v_max;
		comb_min <= v_min;
	end process;
	
	process(clk, reset) -- output registers
	begin
		if reset = '1' then
			max_reg_s <= "0000"; -- so that it can increase
			min_reg_s <= "1111"; -- so that it can decrease
		elsif (clk'event and clk = '1') then
			if comb_max > max_reg_s then -- selective load for max register
				max_reg_s <= comb_max;
			end if;
			if comb_min < min_reg_s then -- selective load for min register
				min_reg_s <= comb_min;
			end if;
		end if;
	end process;
	
	max_out <= max_reg_s; -- assign values outside process
	min_out <= min_reg_s;
	
	with sel select -- 4-1 mux to display selected reg on output
		reg_out <= regs(0) when "00",
			regs(1) when "01",
			regs(2) when "10",
			regs(3) when others;
end behavioural;
			
