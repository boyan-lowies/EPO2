library ieee;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity robot is
    port (
        clk             :in std_logic;
        reset           :in std_logic;
		  set_t				:in std_logic;
        
        sensor_l_in     :in std_logic;  
        sensor_m_in     :in std_logic;       
        sensor_r_in     :in std_logic;

        motor_l_pwm     :out std_logic;
        motor_r_pwm     :out std_logic;
          
		  rx					:in std_logic;
		  tx					:out std_logic;
		  line_out			:in std_logic;
		  
		  led1				:out std_logic;
		  led2				:out std_logic;
		  led3				:out std_logic;
		  led4				:out std_logic;		  
		  led5				:out std_logic;
		  led6				:out std_logic

        
    );
end entity robot;

architecture structural of robot is
    component motorcontrol is
        port (  
                clk         :in std_logic;
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
        clk                     :in std_logic;
        reset_in                :in std_logic;
        reset_out               :out std_logic;
        
        sensors_in              :in std_logic_vector(2 downto 0);
        set                     :in std_logic_vector(2 downto 0);
        direction_L             :out std_logic_vector(1 downto 0);
        direction_R             :out std_logic_vector(1 downto 0);

        count                   :in std_logic_vector(19 downto 0)
    );
    end component controller;
	 
	 component sensory is
		 port (
			  clk         :in std_logic;
			  sensors_in  :in std_logic_vector(2 downto 0);
			  mine		  :in std_logic;
			  sel			  :in std_logic_vector(2 downto 0);

			  message_out :out std_logic_vector(7 downto 0);
			  new_message :out std_logic;
			  test			:out std_logic
		 );
	end component sensory;
   
	component minez is
		port (	
			clk		: in	std_logic;
			line_out	: in	std_logic;

			mine		: out	std_logic :='0'  -- Please enter upper bound
		);
	end component minez;

    component timebase is
        port(
            clk         :in std_logic;
            reset       :in std_logic;
            count_out   :out std_logic_vector(19 downto 0)
        );
    end component timebase;
	 
	 component uart is
         port(
            clk             : in std_logic ;
            reset           : in std_logic ;
        
            rx              : in std_logic ;                           -- input bit stream
            tx              : out std_logic ;                          -- output bit stream
        
            data_in         : in std_logic_vector (7 downto 0) ;       -- byte to be sent
            buffer_empty    : out std_logic ;                          -- flag '1' if tx buffer empty
            write           : in std_logic ;                           -- flag '1' to write to tx buffer
        
            data_out        : out std_logic_vector (7 downto 0) ;      -- received byte
            data_ready      : out std_logic ;                          -- flag '1' if new data in rx buffer
            read            : in std_logic                             -- flag '1' to read from rx buffer
         );
    end component uart ;
	 
	 component uart_read is
		 port (
			  clk         :in std_logic;
			  data_out    :in std_logic_vector(7 downto 0);
			  data_ready  :in std_logic;
			  read        :out std_logic;
			  reset		  :in std_logic;
			  set_t		  :in std_logic;

			  set         :out std_logic_vector(2 downto 0)
		 );
	end component uart_read;

    signal direction_l, direction_r         								:std_logic_vector(1 downto 0);
    signal count                            								:std_logic_vector(19 downto 0);
    signal reset_i, new_message, buff, ready, test, read, mine	   :std_logic;                         --Internal reset for counter and such
    signal sensors, set                          						:std_logic_vector(2 downto 0):="111";
	 signal message_out, message_in  			  	 						:std_logic_vector(7 downto 0);										

begin

	led1  <= set(0);
	led2  <= set(1);
	led3  <= set(2);
	led4 	<= test;
	led5	<= ready;
   led6	<= mine;

 
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
                                sensors_out     =>  sensors
    );

    CT: controller port map(
                                clk             => clk,
                                reset_in        => reset,
                                reset_out       => reset_i,
                                sensors_in      => sensors,
                                set             => set,
                                direction_L     => direction_l,
                                direction_R     => direction_r,
                                count           => count


    );

    TB: timebase port map(
                                clk             => clk,
                                reset           => reset_i,
                                count_out       => count
    );
	 
	 SE: sensory port map (
											clk 				=> clk,
											sensors_in		=> sensors,
											message_out		=> message_out,
											new_message		=> new_message,
											test				=> test,
											mine				=> mine,
											sel				=> set
	 );
	 
	 UA: uart port map(
											clk 				=> clk,
											reset				=> reset,
											rx					=> rx,
											tx					=> tx,
											data_in			=> message_out,
											buffer_empty	=> buff,
											write				=> new_message,
											data_out			=> message_in,
											data_ready		=> ready,
											read				=> read
	 );
	 
	 UR: uart_read port map(
											clk				=> clk,
											data_out			=> message_in,
											data_ready		=> ready,
											read				=> read,
											set 				=> set,
											reset				=> reset,
											set_t				=> set_t
	 );
	 
	 CU: minez port map(
											clk				=> clk,
											line_out			=> line_out,
											mine				=> mine
							);
	 
	 
	 
end architecture structural;
