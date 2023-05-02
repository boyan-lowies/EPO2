library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity controller is
port ( clk              : in std_logic;
       reset            : in std_logic;
       inputs           : in std_logic_vector (2 downto 0);
       count_in         : in std_logic_vector (19 downto 0);
       pulse_L          : out std_logic;
       pulse_R          : out std_logic;
       reset_L          : out std_logic;
       reset_R          : out std_logic;
       reset_timebase   : out std_logic
       );
end entity controller;


architecture behavioural of controller is
             --naming of all states
             type controller_state is ( state_reset, forward, gentle_left, sharp_left, gentle_right, sharp_right);


signal state, new_state: controller_state;
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

-- process for FSM's functionality depending on inputs
       process (state, inputs, count_in)
       begin 
              case state is
                    when state_reset =>
                                   reset_L <= '1';
                                   reset_R <= '1';
                                   reset_timebase <= '1';
                                   if (inputs = "000" or inputs = "010" or inputs = "101" or inputs = "111") then
                                  	new_state <=    forward;
                                    elsif (inputs = "001") then
                                	 new_state <=    gentle_left; 
                         	    elsif (inputs = "100") then
                                	 new_state <=    gentle_right;
                          	    elsif (inputs = "011") then
                                 	new_state <=    sharp_left;
                                    elsif (inputs = "110") then
                                	 new_state <=    sharp_right;
                          	    end if;
                     when forward =>
                            pulse_L <= '1';
                            pulse_R <= '1';
                            reset_L <= '0';
                            reset_R <= '0';
                            reset_timebase <= '0';
             
                            if(unsigned(count_in) <= 1000000) then
                                                        new_state  <= forward;
                                             else 
                                                        new_state  <= state_reset;
                                             end if;
                                                      
                     when gentle_left =>
                            pulse_R <= '1';
                            pulse_L <= '0';
                            reset_L <= '1';
                            reset_R <= '0';
                            reset_timebase <= '0';
             
                            if(unsigned(count_in) <= 1000000) then
                                                        new_state  <= gentle_left;
                                             else 
                                                        new_state  <= state_reset;
                                             end if;                        


                     when sharp_left =>
                            pulse_L <= '0';
                            pulse_R <= '1';
                            reset_L <= '0';
                            reset_R <= '0';
                            reset_timebase <= '0';
             
                            if(unsigned(count_in) <= 1000000) then
                                                        new_state  <= sharp_left;
                                             else 
                                                        new_state  <= state_reset;
                                             end if;

                     when gentle_right =>
                            pulse_R <= '0';
                            pulse_L <= '1';
                            reset_L <= '0';
                            reset_R <= '1';
                            reset_timebase <= '0';

             
                            if(unsigned(count_in) <= 1000000) then
                                                        new_state  <= gentle_right;
                                             else 
                                                        new_state  <= state_reset;
                                             end if;

                     when sharp_right =>
                            pulse_L <= '1';
                            pulse_R <= '0';
                            reset_L <= '0';
                            reset_R <= '0';
                            reset_timebase <= '0';
             
                            if(unsigned(count_in) <= 1000000) then
                                                        new_state  <= sharp_right;
                                             else 
                                                        new_state  <= state_reset;
                                             end if;


                end case;
        end process;

end architecture behavioural;



























