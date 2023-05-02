library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity motorcontrol is
port ( clk              : in std_logic;
       reset            : in std_logic;
       direction        : in std_logic;
       count_in         : in std_logic_vector (19 downto 0);
       pwm              : out std_logic);
end entity motorcontrol;

architecture behavioural of motorcontrol is
             --naming of three states
             type motorcontrol_state is ( state_reset,
                                          motor_high,
                                          motor_low);
                   
             signal state, new_state: motorcontrol_state;
--process for transition between state
begin

      process (clk)
      begin 
               if (rising_edge(clk)) then
                        if  (reset = '1') then
                             state <=  state_reset;
                        else 
                             state <= new_state;
                        end if;
                end if;
      end process;



-- process for FSM's functionality depending on direction
       process (state, direction, count_in)
       begin 
              case state is
                    when state_reset =>                
                            pwm <= '0';
                            new_state         <= motor_high;

                    when motor_high =>
                            pwm <= '1'; 
                            if(direction = '1') then
                                             if(unsigned(count_in) <= 100000) then
                                                        new_state  <= motor_high;
                                             else 
                                                        new_state  <= motor_low;
                                             end if;
                                              
                             else
                                             if(unsigned(count_in) <= 50000) then
                                                        new_state  <= motor_high;
                                             else  
                                                        new_state  <= motor_low;
                                             end if;
                             end if;
                              
                         
                     when motor_low => 
                            pwm <= '0'; 
                            new_state      <= motor_low;
               

                end case;
        end process;
end architecture behavioural;   




                 
      
