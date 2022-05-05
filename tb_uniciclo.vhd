--#########################################################
--#* Testbench para o programa principal
--#*                                              			   
--#* João Pedro de Oliveira Silva               190057807          
--#* Gabriel Ritter Domingues dos Santos        190067543                     
--#*                                              
--#########################################################
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity testb_uniciclo is
  -- Generics
end testb_uniciclo;

architecture testbench of testb_uniciclo is
    component rv_uniciclo is
    port(
            clk			: in std_logic;
            clk_rom		: in std_logic;
            rst	   		: in std_logic;
            data  		: out std_logic_vector(WORD_SIZE-1 downto 0)
        );
    end component;

  -- signal
begin
  module: ent port map(
    -- port map
    );

  test_handler: process
  begin
    -- statements
  end process;
end testbench;