library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity sensory_tb is
end entity sensory_tb;

architecture rtl of sensory_tb is
    
    component sensory is
        port (
            clk         :in std_logic;
            sensors_in  :in std_logic_vector(2 downto 0);
    
            message_out :out std_logic_vector(7 downto 0);
            new_message :out std_logic
        );
    end component sensory;


    signal clk, new_message     :       std_logic;
    signal message_out          :       std_logic_vector(7 downto 0);
    signal sensors_in           :       std_logic_vector(2 downto 0);
begin
    
    clk <=  '0',
            '1' after 10 ns when clk = '0' else '0' after 10ns;

    sensors_in <=   "010",
                    "000" after 100ns,
                    "111" after 200ns;
    
    P1: sensory port map(
        clk         => clk,
        sensors_in  => sensors_in,
        message_out => message_out,
        new_message => new_message 

    );
end architecture rtl;