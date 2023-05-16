library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity uarttb_tb is
end entity uarttb_tb;

architecture rtl of uarttb_tb is
    component uart_tb is
        port(
            reset   :in std_logic;
            clk     :in std_logic;
            rx      :in std_logic;
            tx      :out std_logic;
            leds    :out std_logic_vector(2 downto 0)
        );
    end component uart_tb;

    signal reset, clk, rx, tx   :std_logic;
    signal leds                 :std_logic_vector(2 downto 0);

begin
    
    clk <=  '0',
            '1' after 10 ns when clk = '0' else '0' after 10ns;

    reset <=    '0',
                '1' after 90ns,
                '0' after 150ns;



    P1: uart_tb port map(
        reset => reset,
        clk     => clk,
        rx      => rx,
        tx      => tx,
        leds    => leds
    );

end architecture rtl;