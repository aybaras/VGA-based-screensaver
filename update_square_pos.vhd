library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;


entity update_square_pos is
	port(
		Clk    : in  STD_LOGIC;
		Enable : in  STD_LOGIC;
		x      : out integer range 0 to 639;
		y      : out integer range 0 to 479;
		color  : out STD_LOGIC_VECTOR(7 downto 0)
	);
end update_square_pos;


architecture Behavioral of update_square_pos is

-- constant screen_width  : integer := 640;
-- constant screen_height : integer := 480;
-- constant ball_width    : integer := 60;
-- constant ball_height   : integer := 60;

-- constant ball_width_half  : integer := 30;
-- constant ball_height_half : integer := 30;

signal x_pos		 : integer range 0 to 639 := 320;
signal y_pos		 : integer range 0 to 479 := 240;
signal count 	: STD_LOGIC_VECTOR(2 downto 0) := (others => '0');
signal t_color  : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');

begin

	update_sqr_pos_process : process(Enable)


	variable direction : STD_LOGIC_VECTOR(1 downto 0) := (others => '0');
	-- "00" : Down-Left		-- "01" : Down-Right
	-- "10" : Up-Left		-- "11" : Up-Right
	
	begin
		
		if rising_edge(Clk) then
			if Enable = '1' then
			
				count <= count + 1;
				
				
				if count = "111" then
					t_color <= t_color + 1;
					
					-- Check if the ball hits either the left or the right wall.
					if x_pos = 20 or x_pos = 619 then
						case direction is
							when "00"   => direction := "01";
							when "01"   => direction := "00";
							when "10"   => direction := "11";
							when others => direction := "10";
						end case;
					end if;
					
					
					-- Check if the ball hits either the bottom or the top wall (aka floor or ceiling).
					if y_pos = 20 or y_pos = 459 then
						case direction is
							when "00"   => direction := "10";
							when "01"   => direction := "11";
							when "10"   => direction := "00";
							when others => direction := "01";
						end case;
					end if;
					
					
					-- Move the ball 60/16 = 4 FPS (frames per second).
					case direction is
						when "00"   => x_pos <= x_pos - 1; y_pos <= y_pos + 1;
						when "01"   => x_pos <= x_pos + 1; y_pos <= y_pos + 1;
						when "10"   => x_pos <= x_pos - 1; y_pos <= y_pos - 1;
						when others => x_pos <= x_pos + 1; y_pos <= y_pos - 1;
					end case;
					
					count <= (others => '0');
					
				end if;
				
			end if;
		end if;
		
		x <= x_pos - 20;
		y <= y_pos - 20;
		color <= t_color;
end process update_sqr_pos_process;
-- x <= 320;
-- y <= 240;
end Behavioral;