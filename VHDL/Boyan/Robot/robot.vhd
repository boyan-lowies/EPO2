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
        motor_r_pwm     :out std_logic       
        
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
            sensors_out         :in std_logic_vector(2 downto 0);
            clk                 :in std_logic;
            direction_l         :out std_logic_vector(1 downto 0);
            direction_r         :out std_logic_vector(1 downto 0)
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
    signal sensors_out                      :std_logic_vector(2 downto 0);

begin

    process(clk)
    begin
        if reset = '1' then
            reset_i <= '1';
        elsif reset_i = '1'then
            reset_i <= '0' after 20ns;
        elsif count = "11110100001001000000" then
            reset_i <= '1';
        end if;
    end process;

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
                                sensors_out     =>  sensors_out
    );

    CT: controller port map(
                                sensors_out     =>  sensors_out,
                                clk             =>  clk,
                                direction_l     =>  direction_l,
                                direction_r     =>  direction_r
    );

    TB: timebase port map(
                                clk             => clk,
                                reset           => reset_i,
                                count_out       => count
    );
end architecture structural;
