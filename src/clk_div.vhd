library ieee;
use ieee.std_logic_1164.all;

entity clk_div is
    port (
        clk100 : in  std_logic;
        clk25  : out std_logic
    );
end entity;

architecture rtl of clk_div is
    signal cnt : unsigned(1 downto 0) := (others => '0');
begin
    process(clk100)
    begin
        if rising_edge(clk100) then
            cnt <= cnt + 1;
        end if;
    end process;

    clk25 <= cnt(1);
end architecture;
