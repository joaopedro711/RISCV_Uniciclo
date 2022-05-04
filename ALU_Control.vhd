--#########################################################
--#* Controle da ULA   
--#*                                              			   
--#* João Pedro de Oliveira Silva               190057807          
--#* Gabriel Ritter Domingues dos Santos        190067543                     
--#*                                              
--#########################################################
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.riscv_pkg.all;             -- Pra usar as constantes do arquivo riscv_pkg.vhd


entity alu_ctr is
	port (
		op_alu		: in std_logic_vector(1 downto 0);
		funct3		: in std_logic_vector(2 downto 0);
		funct7		: in std_logic;
		alu_ctr	   : out std_logic_vector(3 downto 0)
	);
end entity alu_ctr;

architecture arc_alu_control of alu_ctr is
    --signals
  begin
    --process
end arc_alu_control;