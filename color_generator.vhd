library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;


entity color_generator is
	port (
		Clk    : in  STD_LOGIC;
		Enable : in  STD_LOGIC;
		x      : in  integer range 0 to 639;
		y      : in  integer range 0 to 479;
		Video_enable : in STD_LOGIC;
		color  : in  STD_LOGIC_VECTOR(7 downto 0);
		red    : out STD_LOGIC_VECTOR(2 downto 0) := "000";
		green  : out STD_LOGIC_VECTOR(2 downto 0) := "000";
		blue   : out STD_LOGIC_VECTOR(1 downto 0) := "00"
	);
end color_generator;


architecture Behavioral of color_generator is

-- constant screen_width  : integer := 640;
-- constant screen_height : integer := 480;
-- constant ball_width    : integer := 60;
-- constant ball_height   : integer := 60;

begin

	counter_process : process(Enable)
	
	variable count, square_pos : integer range 0 to 307199 := 0;
	variable count2			   : integer range 0 to 416799 := 0;
	variable flag			   : boolean := true;
	
	begin

		if rising_edge(Clk) then
			if Enable = '1' then
				if count2 = 416799 then
					count := 0;
					count2 := 0;
				end if;
			
				if video_enable = '1' then
				
					flag := true;
					square_pos := x + y * 640;
					
					-- Display the square by pushing a colorful pixel.
					for h in 0 to 40 loop
						if square_pos <= count and count <= square_pos + 40 then
							red <= color(7) & color(3) & color(1);
							green <= color(0) & color(5) & color(4);
							blue <= color(6) & color(2);
							flag := false;
							exit;
						end if;
						square_pos := square_pos + 640;
					end loop;
					
					-- If flag is true, then push a black pixel.
					if flag then
						red <= (others => '0');
						green <= (others => '0');
						blue <= (others => '0');
					end if;
				
					count := count + 1;
				
				else
				
					red <= (others => '0');
					green <= (others => '0');
					blue <= (others => '0');
					
				end if;
				
				count2 := count2 + 1;
				
			end if;
			
		end if;
		
	end process counter_process;

end Behavioral;