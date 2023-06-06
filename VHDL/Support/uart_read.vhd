library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity uart_read is
    port (
        clk         :in std_logic;
        data_out    :in std_logic_vector(7 downto 0);
        data_ready  :in std_logic;
        read        :in std_logic;

        set         :out std_logic;
    );
end entity uart_read;

architecture rtl of uart_read is
    
begin
    if rising_edge(clk) then
        if data_ready = '1' then
            set     <= data_out(2 downto 0);
            read    <= '1';
        
        else
            read    <= '0';
    
    
end architecture rtl;

