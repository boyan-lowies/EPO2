library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity right is
    port (
        sensors_in          :in     std_logic_vector(2 downto 0);
        clk                 :in     std_logic;
        reset               :in     std_logic;
        direction           :out    std_logic_vector(4 downto 0);
		  count					 :in 	std_logic_vector(19 downto 0)
    );
end entity right;


architecture beheivioal of right is
    type controller_state is (  c_reset,
                                c_forward,
                                c_g_left,
                                c_left,
                                c_g_right,
                                c_right

);



    signal state, newstate   :controller_state;
	 signal reset_i			  :std_logic;
	 signal direction_i 		  :std_logic_vector(3 downto 0);

begin
    
	 direction <= reset_i & direction_i;
	 
	 process(clk, reset)
    begin
		if(rising_edge(clk)) then
			  if reset = '1' or count = "11110100001001000000" then
					state <= c_reset;
			  else
					state <= newstate;
			  end if;
		end if;
        
    end process;

    process(state, sensors_in)
    begin
        case state is
            
            when c_reset =>
                direction_i <= "0000";
					 reset_i <= '1';
                if sensors_in = "101"  then
                    newstate <= c_forward;
                
                elsif sensors_in = "001" then
                    newstate <= c_g_left;
                
                elsif sensors_in = "011" then
                    newstate <= c_left;
                
                elsif sensors_in = "100" then
                    newstate <= c_g_right;
                
                elsif sensors_in = "000" or sensors_in = "110" or sensors_in = "010" or sensors_in = "111" then
                    newstate <= c_right;

                end if;

            when c_forward =>
                direction_i <= "0110";
                newstate <= c_forward;
					 reset_i <= '0';

					 
            when c_g_left =>
                direction_i <= "0010";
					 newstate <= c_g_left;
					 reset_i <= '0';

				
            when c_left =>
                direction_i <= "1010";
					 newstate <= c_left;
					 reset_i <= '0';
				
            when c_g_right =>
                direction_i <= "0100";
					 newstate <= c_g_right;
					 reset_i <= '0';
				
            when c_right =>
                direction_i <= "0101";
					 newstate <= c_right;
					 reset_i <= '0';

        end case;
    end process;
end architecture beheivioal;
