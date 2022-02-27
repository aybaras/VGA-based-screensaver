library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;


entity vga_driver is
    port(
		CLK25 : in	STD_LOGIC;
        HSYNC : out	STD_LOGIC;
        VSYNC : out	STD_LOGIC;
		Video_enable: out STD_LOGIC
	);
end vga_driver;


architecture Behavioral of vga_driver is
	
	constant HD  : integer := 639;		--  639   Horizontal Display (640)
	constant HFP : integer := 16;		--   16   Front Porch
	constant HSP : integer := 96;       --   96   Pulse Width (Retrace)
	constant HBP : integer := 48;		--   48   Back Porch
	
	constant VD  : integer := 479;		--  479   Vertical Display (480)
	constant VFP : integer := 10;		--   10   Front Porch
	constant VSP : integer := 2;		--    2   Pulse Width (Retrace)
	constant VBP : integer := 29;       --   29   Back Porch
	
	signal h : integer := 0;
	signal v : integer := 0;
	
	signal videoOn : STD_LOGIC := '0';

begin


Horizontal_position_counter : process(clk25)
begin
	if(rising_edge(clk25)) then
		if (h = (HD + HFP + HSP + HBP)) then
			h <= 0;
		else
			h <= h + 1;
		end if;
	end if;
end process;

Vertical_position_counter : process(clk25, h)
begin
	if(rising_edge(clk25)) then
		if(h = (HD + HFP + HSP + HBP)) then
			if(v = (VD + VFP + VSP + VBP)) then
				v <= 0;
			else
				v <= v + 1;
			end if;
		end if;
	end if;
end process;

Horizontal_Synchronisation : process(clk25, h)
begin
	if(rising_edge(clk25)) then
		if((h <= (HD + HFP)) OR (h > HD + HFP + HSP)) then
			HSYNC <= '1';
		else
			HSYNC <= '0';
		end if;
	end if;
end process;

Vertical_Synchronisation : process(clk25, v)
begin
	if(rising_edge(clk25)) then
		if((v <= (VD + VFP)) OR (v > VD + VFP + VSP)) then
			VSYNC <= '1';
		else
			VSYNC <= '0';
		end if;
	end if;
end process;

video_on : process(clk25, h, v)
begin
	if(rising_edge(clk25)) then
		if(h <= HD and v <= VD) then
			videoOn <= '1';
		else
			videoOn <= '0';
		end if;
	end if;
end process;

video_enable <= videoOn;

end Behavioral;