library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

-- Setting ports that are used
entity counter is
	port (	clk		: in	std_logic;
		line_out	: in	std_logic;

		mine		: out	std_logic :='0'  -- Please enter upper bound
	);
end entity counter;

-- Timebase function
architecture behavioural of counter is
	type states is (one, two, three, four);
    	signal next_state, state : states;
	signal count, new_count		:unsigned(19 downto 0);
	signal new_mine, reset		:std_logic;

begin		
	process(clk, state, line_out, new_mine)
	begin
		case state is
			when one =>
				reset <= '0';
				if(line_out = '1') then
					next_state <= two;
				else
					next_state <= one;
				end if;
			when two =>
				reset <= '0';
				if(line_out = '0') then
					next_state <= three;
				else
					next_state <= two;
				end if;
			when three =>
				reset <= '1';
				next_state <= four;
			when four =>
				next_state <= one;
				reset <= '0';
		end case;
	end process;

	process (clk)
	begin
		if (rising_edge (clk)) then
			state <= next_state;
			if (reset = '1') then	
				mine <= new_mine;
				count <= (others => '0');
			else
				count <= new_count;
			end if;
		end if;
	end process;

	process (count)
	begin
		new_count <= count + 1;

		if (count > to_unsigned(4950,20) and count < to_unsigned(6300,20)) then
			new_mine <= '1';
		else
			new_mine <= '0';
		end if;
	end process;
	

end architecture behavioural;
		