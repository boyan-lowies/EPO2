library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity controller_tb is
end entity controller_tb;

architecture structural of controller_tb is
    component motorcontrol is
        port (  clk         :in std_logic;
                reset       :in std_logic;
                direction   :in std_logic_vector(1 downto 0); --none = 00, ccw = 01, cw = 10
                count_in    :in std_logic_vector(19 downto 0);
    
                pwm         :out std_logic
        );
    end component motorcontrol;

    component timebase is
        port(
            clk         :in std_logic;
            reset       :in std_logic;
            count_out   :out std_logic_vector(19 downto 0)
        );
    end component timebase;

    component controller is
        port (
            sensors_out         :in std_logic_vector(2 downto 0);
            clk                 :in std_logic;
            direction_l         :out std_logic_vector(1 downto 0);
            direction_r         :out std_logic_vector(1 downto 0)
        );
    end component controller;

    signal clk, reset           :std_logic;
    signal direction_l_s        :std_logic_vector(1 downto 0);
    signal direction_r_s        :std_logic_vector(1 downto 0);
    signal count                :std_logic_vector(19 downto 0);
    signal pwm_l, pwm_r         :std_logic;
    signal sensors_out          :std_logic_vector(2 downto 0);

begin
    
    clk     <=  '0',
                '1' after 10ns when clk = '0' else '0' after 10ns;
    
    reset   <=  '1',
                '0' after 200ns,
                '1' after 20000000ns,
                '0' after 20000020ns,
                '1' after 40000000ns,
                '0' after 40000020ns,
                '1' after 60000000ns,
                '0' after 60000020ns,
                '1' after 80000000ns,
                '0' after 80000020ns,
                '1' after 100000000ns,
                '0' after 100000020ns,
                '1' after 120000000ns,
                '0' after 120000020ns,
                '1' after 140000000ns,
                '0' after 140000020ns;
    
    sensors_out <=  "000",
                    "001" after  18000000ns,
                    "010" after  38000000ns,
                    "011" after  58000000ns,
                    "100" after  78000000ns,
                    "101" after  98000000ns,
                    "110" after 118000000ns,
                    "111" after 138000000ns;

    
    MCL: motorcontrol port map( clk         => clk,
                                reset       => reset,
                                direction   => direction_l_s,
                                count_in    => count,
                                pwm         => pwm_l
    );

    MCR: motorcontrol port map( clk         => clk,
                                reset       => reset,
                                direction   => direction_r_s,
                                count_in    => count,
                                pwm         => pwm_r
    );

    TB: timebase port map(      clk         => clk,
                                reset       => reset,
                                count_out   => count
    );

    CTR: controller port map(   sensors_out => sensors_out,
                                clk         => clk,
                                direction_l => direction_l_s,
                                direction_r => direction_r_s        
    );
    
    
end architecture structural;