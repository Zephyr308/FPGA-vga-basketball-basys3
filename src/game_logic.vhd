library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity game_logic is
    port (
        clk        : in std_logic;
        reset      : in std_logic;
        frame_tick : in std_logic;
        shoot_btn  : in std_logic;
        sw_angle   : in std_logic_vector(3 downto 0);
        sw_power   : in std_logic_vector(3 downto 0);

        ball_x     : out unsigned(10 downto 0);
        ball_y     : out unsigned(10 downto 0);
        score      : out unsigned(7 downto 0)
    );
end entity;

architecture rtl of game_logic is
    constant GRAVITY : integer := 1;
    constant PLAYER_X : integer := 560;
    constant PLAYER_Y : integer := 380;

    constant RIM_X : integer := 80;
    constant RIM_Y : integer := 260;

    signal bx, by : integer := PLAYER_X;
    signal vx, vy : integer := 0;
    signal scored : std_logic := '0';
    signal score_r : unsigned(7 downto 0) := (others => '0');
begin
    process(clk, reset)
    begin
        if reset = '1' then
            bx <= PLAYER_X; by <= PLAYER_Y;
            vx <= 0; vy <= 0;
            scored <= '0';
            score_r <= (others => '0');

        elsif rising_edge(clk) then
            if frame_tick = '1' then
                if shoot_btn = '1' and vx = 0 then
                    vx <= - (to_integer(unsigned(sw_power)) + 3);
                    vy <= - (to_integer(unsigned(sw_angle)) + 5);
                    scored <= '0';
                end if;

                vy <= vy + GRAVITY;
                bx <= bx + vx;
                by <= by + vy;

                if by >= PLAYER_Y then
                    bx <= PLAYER_X; by <= PLAYER_Y;
                    vx <= 0; vy <= 0;
                end if;

                if bx >= RIM_X and bx <= RIM_X + 40 and
                   by >= RIM_Y and by <= RIM_Y + 6 and
                   vy > 0 and scored = '0' then
                    score_r <= score_r + 1;
                    scored <= '1';
                end if;
            end if;
        end if;
    end process;

    ball_x <= to_unsigned(bx, 11);
    ball_y <= to_unsigned(by, 11);
    score  <= score_r;
end architecture;
