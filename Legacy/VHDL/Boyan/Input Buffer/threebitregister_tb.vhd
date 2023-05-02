library ieee;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tb is
end entity tb;

architecture behavioral of tb is
    component threebitregister is
        port(   input       :in std_logic_vector(2 downto 0);
                clk         :in std_logic;
        
                output      :out std_logic_vector(2 downto 0)
        );
    end component threebitregister;

    signal clk              :std_logic;
    signal input            :std_logic_vector(2 downto 0);
    signal output           :std_logic_vector(2 downto 0);

begin

    clk     <=  '0' after 10ns when clk = '1' else '1' after 10ns;
    input   <=  "101" after 20ns,
                "010" after 55ns;

P1: threebitregister port map(
    input   => input,
    clk     => clk,
    output  => output      
);
end architecture behavioral;