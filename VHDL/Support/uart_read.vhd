library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity uart_read is
    port (
        clk         :in std_logic;
        data_out    :in std_logic_vector(7 downto 0);
        data_ready  :in std_logic;
        read        :out std_logic;
		  reset		  :in std_logic;
		  set_t		  :in std_logic;

        set         :out std_logic_vector(2 downto 0)
    );
end entity uart_read;

architecture rtl of uart_read is
    
begin
process(clk)
begin
    if rising_edge(clk) then
		  if reset = '1' then
				set <= "111";
		  elsif set_t = '1' then
				set <= "010";
		  end if;
		  
        if data_ready = '1' then
            set     <= data_out(2 downto 0);
            read    <= '1';
        
        else
            read    <= '0';
		end if;
	end if;
end process;
end architecture rtl;