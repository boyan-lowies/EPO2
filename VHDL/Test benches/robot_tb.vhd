library ieee;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity robot_tb is
end robot_tb;

architecture structural of robot_tb is

    component robot is
        port (
            clk             :in std_logic;
            reset           :in std_logic;
            
            sensor_l_in     :in std_logic;  
            sensor_m_in     :in std_logic;       
            sensor_r_in     :in std_logic;
    
            motor_l_pwm     :out std_logic;
            motor_r_pwm     :out std_logic;
            
            sel             :std_logic
        );
    end component robot;

    signal clk, reset, sel                       :std_logic;
    signal sensor_l, sensor_m, sensor_r     :std_logic;
    signal sensors                          :std_logic_vector(2 downto 0);
    signal motor_l_pwm, motor_r_pwm         :std_logic;

begin

    lbl0: robot port map (
                            clk => clk,
                            reset => reset,
                            sensor_l_in => sensor_l, 
                            sensor_m_in => sensor_m, 
                            sensor_r_in => sensor_r, 
                            motor_l_pwm => motor_l_pwm,
                            motor_r_pwm => motor_r_pwm,
                            sel => sel
    );

    sel         <=  '0',
                    '1' after 150ms;
    clk         <=  '0' after 0ns,
                    '1' after 10 ns when clk /= '1' else '0' after 10 ns;
    reset       <=  '1' after 0ns,
                    '0' after 40ms;
    sensors     <=  "000" after 0ns,
                    "001" after 70ms,
                    "010" after 110ms,
                    "011" after 150ms,
                    "100" after 190ms,
                    "101" after 230ms,
                    "110" after 270ms,
                    "111" after 310ms;

    sensor_l       <= sensors(2);
    sensor_m       <= sensors(1);
    sensor_r       <= sensors(0);
 
end architecture;