library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity controller_tb is
end entity controller_tb;

architecture structural of controller_tb is
    component controller is
        port (
            sensors_in         :in     std_logic_vector(2 downto 0);
            clk                 :in     std_logic;
            reset               :in     std_logic;
            count               :in     std_logic_vector(19 downto 0);

            direction_l         :out    std_logic_vector(1 downto 0);
            direction_r         :out    std_logic_vector(1 downto 0);
            reset_i             :out    std_logic
        );
    end component controller;

    component timebase is
        port(
            clk         :in std_logic;
            reset       :in std_logic;
            count_out   :out std_logic_vector(19 downto 0)
        );
    end component timebase;

    signal count                                            :       std_logic_vector(19 downto 0);
    signal direction_l, direction_r                         :       std_logic_vector(1 downto 0); 
    signal reset, clk,  reset_i                             :       std_logic;
    signal sensors                                          :       std_logic_vector(2 downto 0); 

begin
    
    clk         <=  '0' after 0ns,
                    '1' after 10 ns when clk /= '1' else '0' after 10 ns;
    
    reset       <=  '1',
                    '0' after 100ns;
    
    sensors     <= "100";
    
    
    TB: timebase port map(
        clk         => clk,
        reset       => reset_i,
        count_out   => count
    );
    
    CT: controller port map(
        sensors_in      => sensors,
        clk             => clk,
        reset           => reset,
        count           => count,
        direction_l     => direction_l,
        direction_r     => direction_r,
        reset_i         => reset_i
    );

end architecture structural;