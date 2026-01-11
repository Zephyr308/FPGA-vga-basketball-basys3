library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pixel_renderer is
    port (
        X, Y     : in unsigned(10 downto 0);
        video_on : in std_logic;
        ball_x   : in unsigned(10 downto 0);
        ball_y   : in unsigned(10 downto 0);
        RGB      : out std_logic_vector(11 downto 0)
    );
end entity;

architecture rtl of pixel_renderer is
    signal ball_rgb, rim_rgb, player_rgb : std_logic_vector(11 downto 0);
    signal ball_m, rim_m, player_m : std_logic;
begin
    ball : entity work.shape_circle
        generic map (6, x"F80")
        port map (X, Y, ball_x, ball_y, ball_rgb, ball_m);

    rim : entity work.shape_rect
        generic map (80, 120, 260, 266, x"FFF")
        port map (X, Y, rim_rgb, rim_m);

    player : entity work.shape_rect
        generic map (560, 580, 360, 420, x"0F0")
        port map (X, Y, player_rgb, player_m);

    process(video_on, ball_m, rim_m, player_m,
            ball_rgb, rim_rgb, player_rgb)
    begin
        if video_on = '0' then
            RGB <= (others => '0');
        elsif ball_m = '1' then
            RGB <= ball_rgb;
        elsif rim_m = '1' then
            RGB <= rim_rgb;
        elsif player_m = '1' then
            RGB <= player_rgb;
        else
            RGB <= x"00F";
        end if;
    end process;
end architecture;
