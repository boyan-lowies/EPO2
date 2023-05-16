library ieee;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity robot is
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
end entity robot;

architecture structural of robot is
    component motorcontrol is
        port (  clk         :in std_logic;
                reset       :in std_logic;
                direction   :in std_logic_vector(1 downto 0); --none = 00, ccw = 01, cw = 10
                count_in    :in std_logic_vector(19 downto 0);
    
                pwm         :out std_logic
        );
    end component motorcontrol;

    component inputbuffer is
        port(
            sensor_l_in         :in std_logic;
            sensor_m_in         :in std_logic; 
            sensor_r_in         :in std_logic;
            clk                 :in std_logic;
            sensors_out         :out std_logic_vector(2 downto 0)
        );
    end component inputbuffer;
    
    component controller is
        port (
        clk                     :in std_logic;
        reset_in                :in std_logic;
        reset_out               :out std_logic;
        
        sensors_in              :in std_logic_vector(2 downto 0);
        set                     :in std_logic_vector(2 downto 0);
        direction_L             :out std_logic_vector(1 downto 0);
        direction_R             :out std_logic_vector(1 downto 0);

        count                   :in std_logic_vector(19 downto 0)
    );
    end component controller;
    

    component timebase is
        port(
            clk         :in std_logic;
            reset       :in std_logic;
            count_out   :out std_logic_vector(19 downto 0)
        );
    end component timebase;

    signal direction_l, direction_r         :std_logic_vector(1 downto 0);
    signal count                            :std_logic_vector(19 downto 0);
    signal reset_i                          :std_logic;                         --Internal reset for counter and such
    signal sensors, set                          :std_logic_vector(2 downto 0);

begin

 
    MCL: motorcontrol port map(
                                clk             =>  clk,
                                reset           =>  reset_i,
                                direction       =>  direction_l,
                                count_in        =>  count,
                                pwm             =>  motor_l_pwm
    );

    MCR: motorcontrol port map(
                                clk             =>  clk,
                                reset           =>  reset_i,
                                direction       =>  direction_r,
                                count_in        =>  count,
                                pwm             =>  motor_r_pwm
    );

    IB: inputbuffer port map(
                                sensor_l_in     =>  sensor_l_in,
                                sensor_m_in     =>  sensor_m_in,
                                sensor_r_in     =>  sensor_r_in,
                                clk             =>  clk,
                                sensors_out     =>  sensors
    );

    CT: controller port map(
                                clk             => clk,
                                reset_in        => reset,
                                reset_out       => reset_i,
                                sensors_in      => sensors,
                                set             => set,
                                direction_L     => direction_l,
                                direction_R     => direction_r,
                                count           => count


    );

    TB: timebase port map(
                                clk             => clk,
                                reset           => reset_i,
                                count_out       => count
    );
end architecture structural;
