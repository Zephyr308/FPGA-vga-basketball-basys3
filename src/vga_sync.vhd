library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity vga_sync is
    port (
        clk      : in  std_logic;
        reset    : in  std_logic;
        hsync    : out std_logic;
        vsync    : out std_logic;
        video_on : out std_logic;
        x        : out unsigned(10 downto 0);
        y        : out unsigned(10 downto 0)
    );
end entity;

architecture rtl of vga_sync is
    signal h_cnt : unsigned(10 downto 0) := (others => '0');
    signal v_cnt : unsigned(10 downto 0) := (others => '0');
begin
    process(clk, reset)
    begin
        if reset = '1' then
            h_cnt <= (others => '0');
            v_cnt <= (others => '0');
        elsif rising_edge(clk) then
            if h_cnt = 799 then
                h_cnt <= (others => '0');
                if v_cnt = 524 then
                    v_cnt <= (others => '0');
                else
                    v_cnt <= v_cnt + 1;
                end if;
            else
                h_cnt <= h_cnt + 1;
            end if;
        end if;
    end process;

    hsync <= '0' when (h_cnt >= 656 and h_cnt < 752) else '1';
    vsync <= '0' when (v_cnt >= 490 and v_cnt < 492) else '1';

    video_on <= '1' when (h_cnt < 640 and v_cnt < 480) else '0';

    x <= h_cnt;
    y <= v_cnt;
end architecture;
