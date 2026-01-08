-- Student name: Daniel Akbari
-- Student ID: 40298757
-- Lab section: FI-X

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity   reg_sign_extend   is
port(din: in std_logic_vector(3 downto 0);
	reset: in std_logic; -- asynch
	clk : in std_logic;
	extend: in std_logic;
	regout : out std_logic_vector(7 downto 0));
end   reg_sign_extend   ;

architecture rtl of   reg_sign_extend   is
	signal regs : std_logic_vector(7 downto 0);	
begin
	process(clk, reset)
	begin
		if reset = '1' then
			regs <= (others => '0');
		elsif (clk'event and clk = '1') then
			if extend = '0' then
				regs <= "0000" & din;
			else
				regs <= din(3) & din(3) & din(3) & din(3) & din;
			end if;
		end if;
	end process;
	regout <= regs;
end rtl;
			
