--treebitregister

library ieee;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity threebitregister is
    port(   input       :in std_logic_vector(2 downto 0);
            clk         :in std_logic;
    
            output      :out std_logic_vector(2 downto 0)
    );
end entity threebitregister;

architecture behavioral of threebitregister is

begin  
    process(clk)
    begin    
        if(rising_edge(clk)) then
            output <= input;
        end if;    
    
        end process;
end architecture behavioral;



--Inputbuffer

library ieee;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity inputbuffer is
    port(
        sensor_l_in         :in std_logic;
        sensor_m_in         :in std_logic; 
        sensor_r_in         :in std_logic;
        clk                 :in std_logic;
        sensors_out         :out std_logic_vector(2 downto 0)
    );
end entity inputbuffer;

architecture structural of inputbuffer is
    component threebitregister is
        port(   input       :in std_logic_vector(2 downto 0);
                clk         :in std_logic;

                output      :out std_logic_vector(2 downto 0)
        );
    end component threebitregister;

    signal input, inter, output     :std_logic_vector(2 downto 0);

begin
    input(2)        <= sensor_l_in ;     
    input(1)        <= sensor_m_in ;     
    input(0)        <= sensor_r_in ; 

    sensors_out     <= output;
    
    R1: threebitregister port map(
        input   =>      input,
        clk     =>      clk,
        output  =>      inter
    );

    R2: threebitregister port map(
        input   =>      inter,
        clk     =>      clk,
        output  =>      output
    );

    

end architecture structural;

-- Motorcontrol

library ieee;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity motorcontrol is
    port (  clk         :in std_logic;
            reset       :in std_logic;
            direction   :in std_logic_vector(1 downto 0); --none = 00, ccw = 01, cw = 10
            count_in    :in std_logic_vector(19 downto 0);

            pwm         :out std_logic
    );
end entity motorcontrol;

architecture beheivioral of motorcontrol is
    
    type motorcontrol_state is (    motor_reset,
                                    motor_on,
                                    motor_off
    );

    signal state        :motorcontrol_state;

begin
    process(clk)
    begin 
        if (rising_edge(clk)) then
            if(reset = '1') then
                state <= motor_reset;
            elsif(reset = '0' and direction = "00") then
                state <= motor_off;

            elsif(reset = '0' and state = motor_reset) then
                state <= motor_on;
            
            elsif(state = motor_on) then
                if(direction = "01" and unsigned(count_in) = 100000 ) then
                    state <= motor_off;
                
                elsif(direction = "10" and unsigned(count_in) = 50000) then 
                    state <= motor_off;
                end if;
            end if;
        end if;
    end process;
    
    process(state)
    begin
        case state is 
            when motor_reset =>
                pwm <= '0';
            
            when motor_on =>
                pwm <= '1';

            when motor_off =>
                pwm <= '0';
        end case;
    end process;
end architecture beheivioral;


-- timebase

library ieee;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity timebase is
    port(
        clk         :in std_logic;
        reset       :in std_logic;
        count_out   :out std_logic_vector(19 downto 0)
    );
end entity timebase;

architecture behavioral of timebase is
	signal count, new_count		:unsigned (19 downto 0);

	begin
		-- Register
		process(clk)
		begin
			if (rising_edge(clk)) then
				if (reset = '1') then
					count <= (others => '0');
                else 
					count <= new_count;
				end if;
			end if;
		end process;
		
		-- add_1
		process(count)
		begin
			new_count <= count + 1;
		end process;

		count_out <= std_logic_vector(count);
	end architecture behavioral;



    -- Controller

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
        if rising_edge(clk) then
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

-- Robot


library ieee;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity robot is
    port (
        clk             :in std_logic;
        reset           :in std_logic;
        
        sensor_l_in     :in std_logic;  
        sensor_m_in     :in std_logic;       
        sensor_r_in     :in std_logic;

        motor_l_pwm     :out std_logic;
        motor_r_pwm     :out std_logic       
        
    );
end entity robot;

architecture structural of robot is
    component motorcontrol is
        port (  clk         :in std_logic;
                reset       :in std_logic;
                direction   :in std_logic_vector(1 downto 0); --none = 00, ccw = 01, cw = 10
                count_in    :in std_logic_vector(19 downto 0);
    
                pwm         :out std_logic
        );
    end component motorcontrol;

    component inputbuffer is
        port(
            sensor_l_in         :in std_logic;
            sensor_m_in         :in std_logic; 
            sensor_r_in         :in std_logic;
            clk                 :in std_logic;
            sensors_out         :out std_logic_vector(2 downto 0)
        );
    end component inputbuffer;
    
    component controller is
        port (
            sensors_out         :in std_logic_vector(2 downto 0);
            clk                 :in std_logic;
            direction_l         :out std_logic_vector(1 downto 0);
            direction_r         :out std_logic_vector(1 downto 0)
        );
    end component controller;

    component timebase is
        port(
            clk         :in std_logic;
            reset       :in std_logic;
            count_out   :out std_logic_vector(19 downto 0)
        );
    end component timebase;

    signal direction_l, direction_r         :std_logic_vector(1 downto 0);
    signal count                            :std_logic_vector(19 downto 0);
    signal reset_i                          :std_logic;                         --Internal reset for counter and such
    signal sensors_out                      :std_logic_vector(2 downto 0);

begin

    process(clk, reset, reset_i, count)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                reset_i <= '1';
            elsif reset_i = '1'then
                reset_i <= '0' after 20ns;
            elsif count = "11110100001001000000" then
                reset_i <= '1';
            end if;
        end if;
    end process;

    MCL: motorcontrol port map(
                                clk             =>  clk,
                                reset           =>  reset_i,
                                direction       =>  direction_l,
                                count_in        =>  count,
                                pwm             =>  motor_l_pwm
    );

    MCR: motorcontrol port map(
                                clk             =>  clk,
                                reset           =>  reset_i,
                                direction       =>  direction_r,
                                count_in        =>  count,
                                pwm             =>  motor_r_pwm
    );

    IB: inputbuffer port map(
                                sensor_l_in     =>  sensor_l_in,
                                sensor_m_in     =>  sensor_m_in,
                                sensor_r_in     =>  sensor_r_in,
                                clk             =>  clk,
                                sensors_out     =>  sensors_out
    );

    CT: controller port map(
                                sensors_out     =>  sensors_out,
                                clk             =>  clk,
                                direction_l     =>  direction_l,
                                direction_r     =>  direction_r
    );

    TB: timebase port map(
                                clk             => clk,
                                reset           => reset_i,
                                count_out       => count
    );
end architecture structural;

-- TB

library ieee;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity robot_tb is
end robot_tb;

architecture structural of robot_tb is

    component robot is
        port (
            clk             :in std_logic;
            reset           :in std_logic;
            
            sensor_l_in     :in std_logic;  
            sensor_m_in     :in std_logic;       
            sensor_r_in     :in std_logic;
    
            motor_l_pwm     :out std_logic;
            motor_r_pwm     :out std_logic       
        );
    end component robot;

    signal clk, reset                       :std_logic;
    signal sensor_l, sensor_m, sensor_r     :std_logic;
    signal sensors                          :std_logic_vector(2 downto 0);
    signal motor_l_pwm, motor_r_pwm         :std_logic;

begin

    lbl0: robot port map (
                            clk => clk,
                            reset => reset,
                            sensor_l_in => sensor_l,
                            sensor_m_in => sensor_m,
                            sensor_r_in => sensor_r,
                            motor_l_pwm => motor_l_pwm,
                            motor_r_pwm => motor_r_pwm
    );

    clk         <=  '0' after 0ns,
                    '1' after 10 ns when clk /= '1' else '0' after 10 ns;
    reset       <=  '1' after 0ns,
                    '0' after 40ms;
    sensors     <=  "000" after 0ns,
                    "001" after 70ms,
                    "010" after 110ms,
                    "011" after 150ms,
                    "100" after 190ms,
                    "101" after 230ms,
                    "110" after 270ms,
                    "111" after 310ms;

    sensor_l       <= sensors(2);
    sensor_m       <= sensors(1);
    sensor_r       <= sensors(0);
 
end architecture;