library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity threebitmux_tb is
    port(
        setA        :in std_logic;
        setB        :in std_logic;
        setC        :in std_logic;

        outputA     :out std_logic;
        outputB     :out std_logic;
        outputC     :out std_logic;
        outputD     :out std_logic
    );
end entity threebitmux_tb;

architecture structural of threebitmux_tb is
    component threebitmux is
        port (
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
    
    signal set_i      :std_logic_vector(2 downto 0);
    signal output_i   :std_logic_vector(3 downto 0);
    signal output_v   :std_logic_vector(3 downto 0);

begin
    set_i(2)    <= setA;
    set_i(1)    <= setB;
    set_i(0)    <= setC;
    outputA     <= output_v(3);
    outputB     <= output_v(2);
    outputC     <= output_v(1);
    outputD     <= output_v(0);
    
    MUX: threebitmux port map(
        dataA   =>  "0001",
        dataB   =>  "0010",
        dataC   =>  "0011",
        dataD   =>  "0100",
        dataE   =>  "0101",
        dataF   =>  "0110",
        dataG   =>  "0111",
        dataH   =>  "1000",
        set     =>  set_i,  
        output  =>  output_v
    );
end architecture structural;