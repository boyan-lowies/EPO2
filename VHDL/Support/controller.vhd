library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity controller is
    port (
        clk                     :in std_logic;
        reset_in                :in std_logic;
        reset_out               :out std_logic;

        sensors_in              :in std_logic_vector(2 downto 0);
        set                     :in std_logic_vector(2 downto 0);

        direction_L             :out std_logic_vector(1 downto 0);
        direction_R             :out std_logic_vector(1 downto 0);


        count                   :in std_logic_vector(19 downto 0)
    );
end entity controller;

architecture rtl of controller is
    component threebitmux is
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
    end component threebitmux;

    component reverse is
        port (
            sensors_in          :in     std_logic_vector(2 downto 0);
            clk                 :in     std_logic;
            reset               :in     std_logic;
            direction           :out    std_logic_vector(3 downto 0)
        );
    end component reverse;

    component linefollower is
        port (
            sensors_in          :in     std_logic_vector(2 downto 0);
            clk                 :in     std_logic;
            reset               :in     std_logic;
            direction           :out    std_logic_vector(3 downto 0)
        );
    end component linefollower;
    
    signal direction_linefollower, direction_backwards          :std_logic_vector(3 downto 0);
    signal output                                               :std_logic_vector(3 downto 0);
    signal reset                                                :std_logic;
begin
    
    process(clk, count, reset_in)
    begin
        if rising_edge(clk) then
            if  reset_in = '1' or count = "11110100001001000000" then
                reset <= '1';
            else
                reset <= '0';
        end if;
    end if;
    end process;

    reset_out   <= reset;
    direction_L <= output(3 downto 2);
    direction_R <= output(1 downto 0);

    C1: linefollower port map(
        sensors_in  => sensors_in,
        clk         => clk,
        reset       => reset,
        direction   => direction_linefollower
    );
    
    C2: reverse port map(
        sensors_in  => sensors_in,
        clk         => clk,
        reset       => reset,
        direction   => direction_backwards
    );

    MU: threebitmux port map(
        clk         => clk,
        dataA       => direction_linefollower,
        dataB       => direction_backwards,
        dataC       => "0000",
        dataD       => "0000",
        dataE       => "0000",
        dataF       => "0000",
        dataG       => "0000",
        dataH       => "0000",
        set         => set,

        output      => output
    );
    
end architecture rtl;