library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity reverse is
    port (
        sensors_in          :in     std_logic_vector(2 downto 0);
        clk                 :in     std_logic;
        reset               :in     std_logic;
        direction           :out    std_logic_vector(3 downto 0)
    );
end entity reverse;


architecture beheivioal of reverse is
    type controller_state is (  c_reset,
                                c_forward,
                                c_g_left,
                                c_left,
                                c_g_right,
                                c_right
);

    signal state, newstate   :controller_state;

begin
    process(clk)
    begin
        if reset = '1' then
            state <= c_reset;
        else
            state <= newstate;
        end if;
        
    end process;

    process(state, sensors_in)
    begin
        case state is
            
            when c_reset =>
                direction <= "0000";
            
                if sensors_in = "000" or sensors_in = "010" or sensors_in = "101" or sensors_in = "111" then
                    newstate <= c_forward;
                
                elsif sensors_in = "001" then
                    newstate <= c_g_left;
                
                elsif sensors_in = "011" then
                    newstate <= c_left;
                
                elsif sensors_in = "100" then
                    newstate <= c_g_right;
                
                elsif sensors_in = "110" then
                    newstate <= c_right;

                end if;

            when c_forward =>
                direction <= "1001";
                
            when c_g_left =>
                direction <= "0010";
            
            when c_left =>
                direction <= "1010";
            
            when c_g_right =>
                direction <= "0100";
            
            when c_right =>
                direction <= "0101";

        end case;
    end process;
end architecture beheivioal;
