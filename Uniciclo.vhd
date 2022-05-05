--#########################################################
--#* Programa principal, que executa todos os componentes
--#*                                              			   
--#* João Pedro de Oliveira Silva               190057807          
--#* Gabriel Ritter Domingues dos Santos        190067543                     
--#*                                              
--#########################################################
library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;
use work.riscv_pkg.all;

entity rv_uniciclo is
    port(
        clk			: in std_logic;
        clk_rom		: in std_logic;
        rst	   		: in std_logic;
        data  		: out std_logic_vector(WORD_SIZE-1 downto 0)
        );
end rv_uniciclo;
