library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity shape_rect is
    generic (
        X_MIN : integer;
        X_MAX : integer;
        Y_MIN : integer;
        Y_MAX : integer;
        COLOR : std_logic_vector(11 downto 0)
    );
    port (
        X    : in  unsigned(10 downto 0);
        Y    : in  unsigned(10 downto 0);
        RGB  : out std_logic_vector(11 downto 0);
        MASK : out std_logic
    );
end entity;

architecture Behav of shape_rect is
begin
    MASK <= '1' when
        to_integer(X) >= X_MIN and to_integer(X) < X_MAX and
        to_integer(Y) >= Y_MIN and to_integer(Y) < Y_MAX
        else '0';

    RGB <= COLOR when MASK = '1' else (others => '0');
end architecture;
