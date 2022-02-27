library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity main_design is
	port(
		board_clk : in  STD_LOGIC;
		vsync     : out STD_LOGIC;
		hsync     : out STD_LOGIC;
		red       : out STD_LOGIC_VECTOR(2 downto 0);
		green     : out STD_LOGIC_VECTOR(2 downto 0);
		blue      : out STD_LOGIC_VECTOR(1 downto 0)
	);
end main_design;


architecture Behavioral of main_design is

component frequency_divider_by_4 is
	port(
		Clk_in  : in  STD_LOGIC;
		Clk_out : out STD_LOGIC
	);
end component;

component frequency_divider_by_416666 is
	port(
		Clk_in  : in  STD_LOGIC;
		Clk_out : out STD_LOGIC
	);
end component;

component vga_driver is
    port(
		CLK25 : in   STD_LOGIC;
        HSYNC : out  STD_LOGIC;
        VSYNC : out  STD_LOGIC;
		Video_enable : out STD_Logic
    );
end component;

component update_square_pos is
	port(
		Clk    : in  STD_LOGIC;
		Enable : in  STD_LOGIC;
		x      : out integer range 0 to 639;
		y      : out integer range 0 to 479;
		color  : out STD_LOGIC_VECTOR(7 downto 0)
	);
end component;

component color_generator is
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
end component;


signal clk_div, clk_div_2, v_sync_gen_enable, video_en : STD_LOGIC;
signal x : integer range 0 to 639;
signal y : integer range 0 to 479;
signal color : STD_LOGIC_VECTOR(7 downto 0);

begin

	freq_div   : frequency_divider_by_4			-- 100 MHz to 25 MHz, so we divide the frequency by 4.
		port map(board_clk, clk_div);
	
	freq_div_2 : frequency_divider_by_416666	-- 25 MHz to 60 Hz (refresh rate), so we divide the frequency by 416666.
		port map(clk_div, clk_div_2);
	
	vga_drive: vga_driver
		port map(clk_div,hsync,vsync, video_en);
	
	update_sqr_pos : update_square_pos
		port map(board_clk, clk_div_2, x, y, color);

	color_gen  : color_generator
		port map(board_clk, clk_div, x, y, video_en, color, red, green, blue);

end Behavioral;