library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity controller is
    port (
        sensors_in         :in     std_logic_vector(2 downto 0);
        clk                 :in     std_logic;
        reset               :in     std_logic;
        count               :in     std_logic_vector(19 downto 0);

        direction_l         :out    std_logic_vector(1 downto 0);
        direction_r         :out    std_logic_vector(1 downto 0);
        reset_i             :out    std_logic
    );
end entity controller;


architecture beheivioal of controller is
    type controller_state is (  c_reset,
                                c_forward,
                                c_g_left,
                                c_left,
                                c_g_right,
                                c_right
);

    signal state, newstate   :controller_state;

begin
    process(clk, count)
    begin
        if count = "11110100001001000000" or reset = '1' then
            state <= c_reset;
        else
            state <= newstate;
        end if;
        
    end process;

    process(state, sensors_in)
    begin
        case state is
            
            when c_reset =>
                direction_l <= "00";
                direction_r <= "00";
                reset_i <= '1';
            
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
                direction_l <= "01";
                direction_r <= "10";
                reset_i <= '0';
                
            when c_g_left =>
                direction_l <= "00";
                direction_r <= "10";
                reset_i <= '0';
            
            when c_left =>
                direction_l <= "10";
                direction_r <= "10";
                reset_i <= '0';
            
            when c_g_right =>
                direction_l <= "01";
                direction_r <= "00";
                reset_i <= '0';
            
            when c_right =>
                direction_l <= "01";
                direction_r <= "01";
                reset_i <= '0';
            

        end case;
    end process;
end architecture beheivioal;
