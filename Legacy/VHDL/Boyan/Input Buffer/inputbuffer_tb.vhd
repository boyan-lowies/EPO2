library ieee;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tb is
end entity tb;

architecture structural of tb is
    component inputbuffer is
        port(
            sensor_l_in         :in std_logic;
            sensor_m_in         :in std_logic; 
            sensor_r_in         :in std_logic;
            clk                 :in std_logic;
    
            sensors_out         :out std_logic_vector(2 downto 0)
        );
        end component inputbuffer;

    signal sensor_l_in                      :std_logic;
    signal sensor_m_in                      :std_logic; 
    signal sensor_r_in                      :std_logic;
    signal clk                              :std_logic;
    signal sensors_out                      :std_logic_vector(2 downto 0);
    

begin
    sensor_l_in <=  '1' after 35ns,
                    '0' after 55ns;
    sensor_m_in <=  '0' after 35ns,
                    '1' after 55ns;
    sensor_r_in <=  '1' after 35ns,
                    '0' after 55ns;

    clk         <=  '1' after 0ns,
                    '0' after 10ns when clk = '1' else '1' after 10ns;

    
    P1: inputbuffer port map(
        sensor_l_in => sensor_l_in,
        sensor_m_in => sensor_m_in,
        sensor_r_in => sensor_r_in,
        clk         => clk,
        sensors_out => sensors_out
    );

end architecture structural;
