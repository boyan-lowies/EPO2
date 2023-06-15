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
            dataA       :in std_logic_vector(4 downto 0);
            dataB       :in std_logic_vector(4 downto 0);
            dataC       :in std_logic_vector(4 downto 0);
            dataD       :in std_logic_vector(4 downto 0);
            dataE       :in std_logic_vector(4 downto 0);
            dataF       :in std_logic_vector(4 downto 0);
            dataG       :in std_logic_vector(4 downto 0);
            dataH       :in std_logic_vector(4 downto 0);
            set         :in std_logic_vector(2 downto 0);
    
            output      :out std_logic_vector(4 downto 0)
        );
    end component threebitmux;

    component reverse is
        port (
            sensors_in          :in     std_logic_vector(2 downto 0);
            clk                 :in     std_logic;
            reset               :in     std_logic;
            direction           :out    std_logic_vector(4 downto 0);
				count					  :in 	std_logic_vector(19 downto 0)
        );
    end component reverse;

    component linefollower is
        port (
            sensors_in          :in     std_logic_vector(2 downto 0);
            clk                 :in     std_logic;
            reset               :in     std_logic;
            direction           :out    std_logic_vector(4 downto 0);
				count					  :in 	 std_logic_vector(19 downto 0)			
        );
    end component linefollower;
    
	 component left is
        port (
            sensors_in          :in     std_logic_vector(2 downto 0);
            clk                 :in     std_logic;
            reset               :in     std_logic;
            direction           :out    std_logic_vector(4 downto 0);
				count					  :in 	 std_logic_vector(19 downto 0)			
        );
    end component left;
	 
	 component right is
        port (
            sensors_in          :in     std_logic_vector(2 downto 0);
            clk                 :in     std_logic;
            reset               :in     std_logic;
            direction           :out    std_logic_vector(4 downto 0);
				count					  :in 	std_logic_vector(19 downto 0)			
        );
    end component right;
	 
	 component turnaround is
        port (
            sensors_in          :in     std_logic_vector(2 downto 0);
            clk                 :in     std_logic;
            reset               :in     std_logic;
            direction           :out    std_logic_vector(4 downto 0);
				sel					  :in	std_logic_vector(2 downto 0);
				
				count					  :in 	std_logic_vector(19 downto 0)			
        );
    end component turnaround;
	 
    signal direction_linefollower, direction_backwards, direction_left, direction_right, direction_turnaround          :std_logic_vector(4 downto 0);
    signal output                                               :std_logic_vector(4 downto 0);
	 
begin
    reset_out 	 <= output(4);
    direction_L <= output(3 downto 2);
    direction_R <= output(1 downto 0);

    C1: linefollower port map(
        sensors_in  => sensors_in,
        clk         => clk,
        reset       => reset_in,
        direction   => direction_linefollower,
		  count		  => count
    );
    
    C2: reverse port map(
        sensors_in  => sensors_in,
        clk         => clk,
        reset       => reset_in,
        direction   => direction_backwards,
		  count		  => count

    );
	 
	 CL: left port map(
        sensors_in  => sensors_in,
        clk         => clk,
        reset       => reset_in,
        direction   => direction_left,
		  count		  => count
    );
	 
	 CR: right port map(
        sensors_in  => sensors_in,
        clk         => clk,
        reset       => reset_in,
        direction   => direction_right,
		  count		  => count
    );
	 
	 CT: turnaround port map(
        sensors_in  => sensors_in,
        clk         => clk,
        reset       => reset_in,
        direction   => direction_turnaround,
		  count		  => count,
		  sel			  => set
    );

    MU: threebitmux port map(
        clk         => clk,
        dataA       => direction_left,
        dataB       => direction_linefollower,
        dataC       => direction_right,
        dataD       => direction_turnaround,
        dataE       => "00000",
        dataF       => "00000",
        dataG       => "00000",
        dataH       => "00000",
        set         => set,

        output      => output
    );
    
end architecture rtl;