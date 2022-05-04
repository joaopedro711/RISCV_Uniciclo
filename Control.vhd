--#########################################################
--#* Controle 
--#*                                              			   
--#* João Pedro de Oliveira Silva               190057807          
--#* Gabriel Ritter Domingues dos Santos        190067543                     
--#*                                              
--#########################################################
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.riscv_pkg.all;             -- Pra usar as constantes do arquivo riscv_pkg.vhd

entity control is
	port (
		opcode : in std_logic_vector(5 downto 0);
		op_ula :	out std_logic_vector(1 downto 0);
		reg_dst,
		branch,
		is_bne,
		jump,
		mem2reg,
		mem_wr,
		alu_src,
		breg_wr:	out std_logic
	);
end entity control;

architecture arc_control of control is
    --signals
    begin
    --process
    
end arc_control;    