-- Multiplexador 2 para 1 de 32 bits
library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity mux2p1 is
    port (
           sel : in  std_logic;
           A   : in  std_logic_vector(31 downto 0);
           B   : in  std_logic_vector(31 downto 0);
           X   : out std_logic_vector(31 downto 0)
          );
end mux2p1;

architecture arc_mux2p1 of mux2p1 is
    begin
    process(sel, A, B, X)
        begin
        case sel is
            when '0' =>
            X <= A;

            when others =>
            X <= B;
            
        end case;
    end process;
end arc_mux2p1;