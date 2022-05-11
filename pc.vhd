--#########################################################
--#* PC    
--#*                                              			   
--#* Joao Pedro de Oliveira Silva               190057807          
--#* Gabriel Ritter Domingues dos Santos        190067543                     
--#*                                              
--#########################################################
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;

entity pc is
  port (
    clk : in STD_LOGIC;
    we : in STD_LOGIC;                              --serve para deixar a simulacao real, nao tem no riscV
    addr_in : in std_logic_vector(31 downto 0);
    addr_out : OUT std_logic_vector(31 downto 0));
end entity pc;

architecture arc_pc of pc is

    begin
    process (clk) begin
        if (rising_edge(clk) and we = '1') then
            if addr_out(0) = 'U' then    
                addr_out <= "00000000000000000000000000000000";
            else
                addr_out <= addr_in;
            end if;
        end if;
    end process;
end arc_pc;
