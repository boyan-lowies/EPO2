library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity sensory is
    port (
        clk         :in std_logic;
        sensors_in  :in std_logic_vector(2 downto 0);
		  mine		  :in std_logic;
		  sel			  :in std_logic_vector(2 downto 0);

        message_out :out std_logic_vector(7 downto 0);
        new_message :out std_logic;
		  test			:out std_logic
    );
end entity sensory;

architecture beheivioal of sensory is

	signal message				:std_logic_vector(7 downto 0);
	signal newm					:std_logic;
begin
	
	message_out <= message;
	new_message <= newm;
	
    process(clk, sensors_in, sel)
	 
	 variable count, direction, detection :integer :=0;
	 
    begin
        if rising_edge(clk) then
				if(newm = '0') then
					if count <= 0 then
						test <= '0';
						if (sensors_in = "000") then
							
								count			  :=  50000000;
								direction     :=  25000000;
								newm 			<= '1';

								message     <= "01111010";

								
						elsif( sensors_in = "111") then
								if sel /= "011" then
									message     <= "01111010";
									newm 			<= '1';
									count			  := 100000000;
								end if;
								
								direction     :=  50000000;
								

						end if;
					end if;

					if count > 0 then
						count := count -1;
					end if;
						
					if direction > 1 then 
						direction := direction -1;
							
					elsif direction = 1 then
						direction := 0;
						message <= "01110001";
						newm 			<= '1';
					end if;
				
				
				if mine = '1' and detection = 0 then
					message <= "01101101";
					detection := 50000000;
					newm <= '1';
				
				elsif detection > 0 then
					detection := detection-1;
				
				end if;
			
			else
					newm <= '0';
				end if;
        end if;
    end process;
end architecture beheivioal;