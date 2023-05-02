library ieee;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity motorcontrol is
    port (  clk         :in std_logic;
            reset       :in std_logic;
            direction   :in std_logic_vector(1 downto 0); --none = 00, ccw = 01, cw = 10
            count_in    :in std_logic_vector(19 downto 0);

            pwm         :out std_logic
    );
end entity motorcontrol;

architecture beheivioral of motorcontrol is
    
    type motorcontrol_state is (    motor_reset,
                                    motor_on,
                                    motor_off
    );

    signal state        :motorcontrol_state;

begin
    process(clk)
    begin 
        if (rising_edge(clk)) then
            if(reset = '1') then
                state <= motor_reset;
            elsif(reset = '0' and direction = "00") then
                state <= motor_off;

            elsif(reset = '0' and state = motor_reset) then
                state <= motor_on;
            
            elsif(state = motor_on) then
                if(direction = "01" and unsigned(count_in) = 100000 ) then
                    state <= motor_off;
                
                elsif(direction = "10" and unsigned(count_in) = 50000) then 
                    state <= motor_off;
                end if;
            end if;
        end if;
    end process;
    
    process(state)
    begin
        case state is 
            when motor_reset =>
                pwm <= '0';
            
            when motor_on =>
                pwm <= '1';

            when motor_off =>
                pwm <= '0';
        end case;
    end process;
end architecture beheivioral;