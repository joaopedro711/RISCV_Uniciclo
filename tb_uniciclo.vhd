--#########################################################
--#* Testbench simples (apenas com os clocks e o reset) para o programa principal
--#* o reset foi testado e funcionou, porem nao utilizamos no resultado final do projeto
--#*                                              			   
--#* João Pedro de Oliveira Silva               190057807          
--#* Gabriel Ritter Domingues dos Santos        190067543                     
--#*                                              
--#########################################################
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity testb_uniciclo is end;

architecture testbench of testb_uniciclo is
    component rv_uniciclo is
    port(
            clk			: in std_logic;
            clk_rom		: in std_logic;
            rst	   		: in std_logic
        );
    end component;

  -- signal
  signal clk :std_logic;
  signal clk_rom :std_logic;
  signal rst : std_logic;

    begin
        project: rv_uniciclo port map(clk => clk, clk_rom => clk_rom, rst => rst);
    process
        begin
        rst <= '0';
        clk <= '1';
        clk_rom <= '1';
        wait for 100 ns;
	
        clk <= '0';
        clk_rom <= '0';
        wait for 100 ns;

    end process;
    
end testbench;
