--#########################################################
--#* PC    
--#*                                              			   
--#* João Pedro de Oliveira Silva               190057807          
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
    we : in STD_LOGIC;                              --Só pra deixar o processador real, não tem no riscV
    addr_in : in std_logic_vector(31 downto 0);
    addr_out : OUT std_logic_vector(31 downto 0));
end entity pc;

architecture arc_pc of pc is

    begin
    process (clk, we) begin
        if rising_edge(clk) then
            if we = '1' then    
                addr_out <= "00000000000000000000000000000000";
            else
                addr_out <= addr_in;
            end if;
        end if;
    end process;
end arc_pc;