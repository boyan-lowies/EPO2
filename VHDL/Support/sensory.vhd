library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity sensory is
    port (
        clk         :in std_logic;
        sensors_in  :in std_logic_vector(2 downto 0);

        message_out :out std_logic_vector(7 downto 0);
        new_message :out std_logic
    );
end entity sensory;

architecture beheivioal of sensory is
    
begin
    process(clk, sensors_in)
    begin
        if rising_edge(clk) then
            if (sensors_in = "000" and sensors_in'event) then
                message_out         <= "00001111";
                new_message     <= '1';
            else
                new_message     <= '0';
            end if;
        end if;
    end process;
end architecture beheivioal;