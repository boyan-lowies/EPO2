library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity controller_tb is
end entity controller_tb;

architecture rtl of controller_tb is
    component controller is
        port (
            clk                     :in std_logic;
            reset                   :in std_logic;
            
            sensors_in              :in std_logic_vector(2 downto 0);
            set                     :in std_logic_vector(2 downto 0);
    
            direction_L             :out std_logic_vector(1 downto 0);
            direction_R             :out std_logic_vector(1 downto 0)
    
        );
    end component controller;

    signal clk, reset   :std_logic;
    signal sensors_in, set :std_logic_vector(2 downto 0);
    signal direction_L, direction_R : std_logic_vector(1 downto 0);
begin
    
    clk <=  '0',
            '1' after 10 ns when clk = '0' else '0' after 10ns;
    
    reset <=    '1',
                '0' after 100 ns;
    
    sensors_in <=   "000";
    
    set        <=   "000",
                    "001" after 300 ns;

    CO: controller port map(
        clk => clk,
        reset => reset,
        sensors_in => sensors_in,
        direction_L => direction_L,
        direction_R => direction_R,
        set         => set
    );
end architecture rtl;