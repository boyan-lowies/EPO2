library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity uart_tb is
    port(
        reset   :in std_logic;
        clk     :in std_logic;
        rx      :in std_logic;
        tx      :out std_logic;
        leds    :out std_logic_vector(2 downto 0)
    );
end entity uart_tb;

architecture behavioural of uart_tb is
    component uart is
         port(
            clk             : in std_logic ;
            reset           : in std_logic ;
        
            rx              : in std_logic ;                           -- input bit stream
            tx              : out std_logic ;                          -- output bit stream
        
            data_in         : in std_logic_vector (7 downto 0) ;       -- byte to be sent
            buffer_empty    : out std_logic ;                          -- flag ’1’ if tx buffer empty
            write           : in std_logic ;                           -- flag ’1’ to write to tx buffer
        
            data_out        : out std_logic_vector (7 downto 0) ;      -- received byte
            data_ready      : out std_logic ;                          -- flag ’1’ if new data in rx buffer
            read            : in std_logic                             -- flag ’1’ to read from rx buffer
         );
         end component uart ;
        
         signal buffer_empty, write, data_ready, read, test       :std_logic;
         signal data_in, data_out                           :std_logic_vector(7 downto 0);

begin
    
    leds(0)  <= test;
    leds(1)  <= write;
    leds(2)  <= reset;
    
    data_in <=  "10101010";
    				read		<= '0';
					
    process(clk)
    begin
        if rising_edge(clk) then
        if reset = '1' then
            write   <=  '0',
                        '1' after 160ns,
                        '0' after 180ns;
            test    <=  '1',
                        '0' after 100 ms; 
			

				
        end if;
    end if;
    end process;      

    conn: uart port map(
        clk             => clk,
        reset           => reset,
        rx              => rx,
        tx              => tx,
        data_in         => data_in,
        buffer_empty    => buffer_empty,
        write           => write,
        data_out        => data_out,
        data_ready      => data_ready,
        read            => read
    );
    
    
end architecture behavioural;