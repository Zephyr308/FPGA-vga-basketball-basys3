library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity seven_seg is
    port (
        clk     : in  std_logic;                 -- 100 MHz
        reset   : in  std_logic;
        value   : in  unsigned(15 downto 0);      -- score
        an      : out std_logic_vector(3 downto 0);
        seg     : out std_logic_vector(6 downto 0)
    );
end entity;

architecture rtl of seven_seg is
    signal refresh_cnt : unsigned(15 downto 0) := (others => '0');
    signal digit_sel   : unsigned(1 downto 0)  := (others => '0');

    signal digit : unsigned(3 downto 0);

    -- BCD digits
    signal d0, d1, d2, d3 : unsigned(3 downto 0);
begin

    ------------------------------------------------------------------
    -- Clock divider for multiplexing (~1 kHz)
    ------------------------------------------------------------------
    process(clk, reset)
    begin
        if reset = '1' then
            refresh_cnt <= (others => '0');
        elsif rising_edge(clk) then
            refresh_cnt <= refresh_cnt + 1;
        end if;
    end process;

    digit_sel <= refresh_cnt(15 downto 14);

    ------------------------------------------------------------------
    -- Binary to BCD (simple division, synthesizable)
    ------------------------------------------------------------------
    process(value)
        variable tmp : integer;
    begin
        tmp := to_integer(value);

        d0 <= to_unsigned(tmp mod 10, 4);
        tmp := tmp / 10;

        d1 <= to_unsigned(tmp mod 10, 4);
        tmp := tmp / 10;

        d2 <= to_unsigned(tmp mod 10, 4);
        tmp := tmp / 10;

        d3 <= to_unsigned(tmp mod 10, 4);
    end process;

    ------------------------------------------------------------------
    -- Digit selection
    ------------------------------------------------------------------
    process(digit_sel, d0, d1, d2, d3)
    begin
        case digit_sel is
            when "00" =>
                an    <= "1110";
                digit <= d0;
            when "01" =>
                an    <= "1101";
                digit <= d1;
            when "10" =>
                an    <= "1011";
                digit <= d2;
            when others =>
                an    <= "0111";
                digit <= d3;
        end case;
    end process;

    ------------------------------------------------------------------
    -- BCD to 7-segment decoder (active LOW)
    ------------------------------------------------------------------
    process(digit)
    begin
        case digit is
            when "0000" => seg <= "1000000"; -- 0
            when "0001" => seg <= "1111001"; -- 1
            when "0010" => seg <= "0100100"; -- 2
            when "0011" => seg <= "0110000"; -- 3
            when "0100" => seg <= "0011001"; -- 4
            when "0101" => seg <= "0010010"; -- 5
            when "0110" => seg <= "0000010"; -- 6
            when "0111" => seg <= "1111000"; -- 7
            when "1000" => seg <= "0000000"; -- 8
            when "1001" => seg <= "0010000"; -- 9
            when others => seg <= "1111111";
        end case;
    end process;

end architecture;
