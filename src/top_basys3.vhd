library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top_basys3 is
    port (
        clk100   : in  std_logic;
        btnC     : in  std_logic;
        sw       : in  std_logic_vector(15 downto 0);

        hsync    : out std_logic;
        vsync    : out std_logic;
        vgaRed   : out std_logic_vector(3 downto 0);
        vgaGreen : out std_logic_vector(3 downto 0);
        vgaBlue  : out std_logic_vector(3 downto 0);

        an       : out std_logic_vector(3 downto 0);
        seg      : out std_logic_vector(6 downto 0)
    );
end entity;

architecture rtl of top_basys3 is
    signal clk25 : std_logic;
    signal x, y  : unsigned(10 downto 0);
    signal video_on : std_logic;

    signal bx, by : unsigned(10 downto 0);
    signal score  : unsigned(7 downto 0);
    signal rgb    : std_logic_vector(11 downto 0);
    signal frame_tick : std_logic;
begin
    clkdiv : entity work.clk_div port map (clk100, clk25);

    vga : entity work.vga_sync
        port map (clk25, btnC, hsync, vsync, video_on, x, y);

    frame_tick <= '1' when (x = 0 and y = 0) else '0';

    logic : entity work.game_logic
        port map (clk25, btnC, frame_tick, btnC,
                  sw(7 downto 4), sw(3 downto 0),
                  bx, by, score);

    render : entity work.pixel_renderer
        port map (x, y, video_on, bx, by, rgb);

    seven : entity work.seven_seg
        port map (clk100, btnC, ("00000000" & score), an, seg);

    vgaRed   <= rgb(11 downto 8);
    vgaGreen <= rgb(7 downto 4);
    vgaBlue  <= rgb(3 downto 0);
end architecture;
