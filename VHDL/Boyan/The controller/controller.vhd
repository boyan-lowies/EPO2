library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity controller is
    port (
        sensors_out         :in std_logic_vector(2 downto 0);
        clk                 :in std_logic;
        direction_l         :out std_logic_vector(1 downto 0);
        direction_r         :out std_logic_vector(1 downto 0)
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

    signal state   :controller_state;

begin
    process(clk)
    begin
            if sensors_out = "000" or sensors_out = "010" or sensors_out = "101" or sensors_out = "111" then
                state <= c_forward;
            
            elsif sensors_out = "001" then
                state <= c_g_left;
            
            elsif sensors_out = "011" then
                state <= c_left;
            
            elsif sensors_out = "100" then
                state <= c_g_right;
            
            elsif sensors_out = "110" then
                state <= c_right;
        end if;
    end process;

    process(state)
    begin
        case state is
            when c_forward =>
                direction_l <= "01";
                direction_r <= "10";
                
            when c_g_left =>
                direction_l <= "00";
                direction_r <= "10";
            
            when c_left =>
                direction_l <= "10";
                direction_r <= "10";
            
            when c_g_right =>
                direction_l <= "01";
                direction_r <= "00";
            
            when c_right =>
                direction_l <= "01";
                direction_r <= "01";
            
            when c_reset =>
                direction_l <= "00";
                direction_r <= "00";
        end case;
    end process;
end architecture beheivioal;
