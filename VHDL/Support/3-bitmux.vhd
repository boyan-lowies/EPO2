library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity threebitmux is
    port (
        clk         :in std_logic;
        dataA       :in std_logic_vector(3 downto 0);
        dataB       :in std_logic_vector(3 downto 0);
        dataC       :in std_logic_vector(3 downto 0);
        dataD       :in std_logic_vector(3 downto 0);
        dataE       :in std_logic_vector(3 downto 0);
        dataF       :in std_logic_vector(3 downto 0);
        dataG       :in std_logic_vector(3 downto 0);
        dataH       :in std_logic_vector(3 downto 0);
        set         :in std_logic_vector(2 downto 0);

        output      :out std_logic_vector(3 downto 0)
    );
end entity threebitmux;

architecture behavioral of threebitmux is
    
begin
    process(clk,set)
    begin
    if rising_edge(clk) then
        case set is
            when "000" =>
                output <= dataA;
            
            when "001" =>
                output <= dataB;
            
            when "010" =>
                output <= dataC;
            
            when "011" =>
                output <= dataD;
            
            when "100" =>
                output <= dataE;
            
            when "101" =>
                output <= dataF;
            
            when "110" =>
                output <= dataG;
            
            when "111" =>
                output <= dataH;

            when others =>
                output <= "0000";
        end case;
    end if;
    end process;
end architecture behavioral;