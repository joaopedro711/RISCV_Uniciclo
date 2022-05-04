--#########################################################
--#* Somador de 32 bits    
--#*                                              			   
--#* João Pedro de Oliveira Silva               190057807          
--#* Gabriel Ritter Domingues dos Santos        190067543                     
--#*                                              
--#########################################################
library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity adder is
    port ( 
        a : in  std_logic_vector(31 downto 0);
        b : in  std_logic_vector(31 downto 0);
        res : out  std_logic_vector(31 downto 0)
    );
end adder;

architecture arc_somador of adder is
begin

    result <= std_logic_vector(signed(a) + signed(b));

end arc_somador;