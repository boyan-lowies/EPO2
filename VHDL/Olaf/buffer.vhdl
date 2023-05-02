Library IEEE;
USE IEEE.Std_logic_1164.all;

entity register_1 is 
   port(
      clk :in std_logic;
      I_out_1 : out std_logic;     
      I_in_1 :in  std_logic; 
      M_out_1 : out std_logic;     
      M_in_1 :in  std_logic; 
      R_out_1 : out std_logic;     
      R_in_1 :in  std_logic  
   );
end register_1;
architecture behavioral of register_1 is  
begin  
 process(clk)
 begin 
    if(rising_edge(clk)) then
        I_out_1 <= I_in_1; 
        M_out_1 <= M_in_1;
        R_out_1 <= R_in_1;          
    end if;       
 end process;  
end behavioral;

Library IEEE;
USE IEEE.Std_logic_1164.all;

entity register_2 is 
   port(
      clk : in std_logic;
      I_out_2 : out std_logic;     
      I_in_2 :in  std_logic; 
      M_out_2 : out std_logic;     
      M_in_2 :in  std_logic; 
      R_out_2 : out std_logic;     
      R_in_2 :in  std_logic  
   );
end register_2;
architecture behavioral of register_2 is  
begin  
 process(clk)
 begin 
    if(rising_edge(clk)) then
        I_out_2 <= I_in_2; 
        M_out_2 <= M_in_2;
        R_out_2 <= R_in_2;          
    end if;       
 end process;  
end behavioral;

Library IEEE;
USE IEEE.Std_logic_1164.all;

entity input_buffer is
   port(
      clk    : in std_logic;
      I_out  : out std_logic;
      M_out  : out std_logic;
      R_out  : out std_logic;      
      I_in   :in  std_logic;     
      M_in   :in  std_logic;     
      R_in   :in  std_logic  
   );
end input_buffer;

architecture behavioral of input_buffer is  

component register_2 is 
   port(
      clk : in std_logic;
      I_out_2 : out std_logic;     
      I_in_2 :in  std_logic; 
      M_out_2 : out std_logic;     
      M_in_2 :in  std_logic; 
      R_out_2 : out std_logic;     
      R_in_2 :in  std_logic  
   );
end component;

component register_1 is 
   port(
      clk : in std_logic;
      I_out_1 : out std_logic;     
      I_in_1  :in  std_logic; 
      M_out_1 : out std_logic;     
      M_in_1  :in  std_logic; 
      R_out_1 : out std_logic;     
      R_in_1  :in  std_logic  
   );
end component;

signal I_btwn_1, I_btwn_2, R_btwn_1, R_btwn_2, M_btwn_1, M_btwn_2: std_logic;

begin 
 
lbl_register_1:  register_1 port map (
                                       clk => clk,
                                       I_in_1 => I_in,
                                       M_in_1 => M_in,
                                       R_in_1 => R_in,
                                       I_out_1 => I_btwn_1,
                                       M_out_1 => M_btwn_1,
                                       R_out_1 => R_btwn_1);

lbl_register_2:  register_2 port map (
                                       clk => clk,
                                       I_in_2 => I_btwn_1,
                                       M_in_2 => M_btwn_1,
                                       R_in_2 => R_btwn_1,
                                       I_out_2 => I_btwn_2,
                                       M_out_2 => M_btwn_2,
                                       R_out_2 => R_btwn_2);                 


I_out <= I_btwn_2;
M_out <= M_btwn_2;
R_out <= R_btwn_2;

end behavioral;
