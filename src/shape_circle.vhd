library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity shape_circle is
    generic (
        RADIUS : integer;
        COLOR  : std_logic_vector(11 downto 0)
    );
    port (
        X, Y   : in unsigned(10 downto 0);
        CX, CY : in unsigned(10 downto 0);
        RGB    : out std_logic_vector(11 downto 0);
        MASK   : out std_logic
    );
end entity;

architecture Behav of shape_circle is
    signal dx, dy : integer;
begin
    dx <= abs(to_integer(X) - to_integer(CX));
    dy <= abs(to_integer(Y) - to_integer(CY));

    MASK <= '1' when (dx*dx + dy*dy) <= RADIUS*RADIUS else '0';
    RGB  <= COLOR when MASK = '1' else (others => '0');
end architecture;
