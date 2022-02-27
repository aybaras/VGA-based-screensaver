library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;


entity frequency_divider_by_416666 is
	port(
		Clk_in  : in  STD_LOGIC;
		Clk_out : out STD_LOGIC
	);
end frequency_divider_by_416666;


architecture Behavioral of frequency_divider_by_416666 is

begin

	freq_div : process(Clk_in)
	
	variable count : integer range 0 to 416665 := 0;
	
	begin

		if rising_edge(Clk_in) then
			count := count + 1;
			if count = 416665 then
				Clk_out <= '1';
			else
				Clk_out <= '0';
			end if;
		end if;

	end process freq_div;
	  
	

end Behavioral;