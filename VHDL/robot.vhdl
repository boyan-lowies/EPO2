library IEEE;
use IEEE.std_logic_1164.all;

entity robot is
	port (  clk             : in    std_logic;
		reset           : in    std_logic;

		sensor_l_in     : in    std_logic;
		sensor_m_in     : in    std_logic;
		sensor_r_in     : in    std_logic;

		motor_l_pwm     : out   std_logic;
		motor_r_pwm     : out   std_logic
	);
end entity robot;

architecture robot_arch of robot is

component timebase is
	port(	clk	: in	std_logic;
		reset	: in 	std_logic;
		count_out: out	std_logic_vector (19 downto 0)
	);
end component timebase;


component motorcontrol is
port ( clk              : in std_logic;
       reset            : in std_logic;
       direction        : in std_logic;
       count_in         : in std_logic_vector (19 downto 0);
       pwm              : out std_logic);
end component motorcontrol;

component motorcontrol_2 is
port ( clk              : in std_logic;
       reset            : in std_logic;
       direction        : in std_logic;
       count_in         : in std_logic_vector (19 downto 0);
       pwm              : out std_logic);
end component motorcontrol_2;


component input_buffer is
   port(
      clk    : in std_logic;
      I_out  : out std_logic;
      M_out  : out std_logic;
      R_out  : out std_logic;      
      I_in   :in  std_logic;     
      M_in   :in  std_logic;     
      R_in   :in  std_logic  
   );
end component input_buffer;

component controller is
port ( clk              : in std_logic;
       reset            : in std_logic;
       inputs           : in std_logic_vector (2 downto 0);
       count_in         : in std_logic_vector (19 downto 0);
       pulse_L          : out std_logic;
       pulse_R          : out std_logic;
       reset_L          : out std_logic;
       reset_R          : out std_logic;
       reset_timebase   : out std_logic
       );
end component controller;

signal motor_reset_L, motor_reset_R, motor_pulse_L, motor_pulse_R, reset_timebase: std_logic;
signal count : std_logic_vector (19 downto 0);
signal controller_input_L, controller_input_R, controller_input_M: std_logic;
signal inputs : std_logic_vector (2 downto 0);

begin

	lbl0: timebase port map	(	clk			=> clk,
					reset			=> reset_timebase,
					count_out		=> count
				);

        lbl11: input_buffer port map (
                                         clk        => clk,
                                         I_in       => sensor_l_in,
                                         M_in       => sensor_m_in,
                                         R_in       => sensor_R_in,
                                         I_out      => controller_input_L,
                                         M_out      => controller_input_M,
                                         R_out      => controller_input_R
                                      );
        
        inputs(0) <= controller_input_R;   
        inputs(1) <= controller_input_M; 
        inputs(2) <= controller_input_L;                            
					
	lbl2: controller port map (	clk			=> clk,
					reset			=> reset,
					inputs  		=> inputs,
					count_in		=> count,
					pulse_L			=> motor_pulse_L,
					pulse_R			=> motor_pulse_R,
					reset_L			=> motor_reset_L,
					reset_R			=> motor_reset_R,
                                        reset_timebase          => reset_timebase
				);

        lbl_motor_L: motorcontrol port map (
                                              clk     => clk,
                                              reset   => motor_reset_L,
                                              direction => motor_pulse_L,
                                              count_in => count,
                                              pwm => motor_l_pwm
                                            );

        lbl_motor_R: motorcontrol_2 port map (
                                              clk     => clk,
                                              reset   => motor_reset_R,
                                              direction => motor_pulse_R,
                                              count_in => count,
                                              pwm => motor_r_pwm
                                            );
end robot_arch;





















