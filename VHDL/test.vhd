library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity test is
end entity test;

architecture rtl of test is
    signal a     :std_logic;
begin
    a <=    '0',
            '1' after 10 ms when a = '0' else '1' after 10ms;
end architecture rtl;