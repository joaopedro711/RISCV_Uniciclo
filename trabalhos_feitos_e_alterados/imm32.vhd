--#########################################################
--#* Referente ao Trab IV: Geração de Dados Imm32 no RISC-V    
--#*                                              			   
--#* João Pedro de Oliveira Silva				190057807          
--#* Gabriel Ritter Domingues dos Santos			190067543                     
--#*                                              
--#########################################################

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--Código fornecido pelo professor
package formatos is
	type FORMAT_RV is (R_type, I_type, S_type, SB_type, UJ_type, U_type);
end formatos;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.formatos.all;

entity genImm32 is port(
	instr: 	in std_logic_vector(31 downto 0);
    imm32: 	out signed(31 downto 0));
end genImm32;
-- Fim do código do professor


architecture trab4 of genImm32 is
	--sinais auxiliares												
	signal tipo_inst: FORMAT_RV; 
	signal opcode: unsigned(6 downto 0);

 begin
	--imm32 <= aux;										--imm32 recebe o valor de auxiliar
    opcode <= unsigned(instr(6 downto 0));  			--opcode recebe os 7 primeiros bits da instr(entrada), eles representam o opcode

   	process(instr, tipo_inst, opcode)
    	begin
		
        --case opcode is									--checa os 7 primeiros bits e vê o opcode correspondente
		
		with opcode select 
									-- 0x33
			tipo_inst <= R_type when b"0110011",
			
									   -- 0x03		  0x13		   0x67
					    I_type when b"0000011" | b"0010011" | b"1100111",
			
									  -- 0x23
						S_type when b"0100011",
			
									   -- 0x63
						SB_type when b"1100011",
			
									  -- 0x37
						U_type when b"0110111",
			
									   -- 0x6f
						UJ_type when others;
		
        --checa o tipo da instrução, faz o aux(imm32) receber os valores dos imediatos
        with tipo_inst select
			--R_type não possui imediatos
        	imm32 <= 	x"00000000" when R_type,
            
					-- I-type: 12 bits, imm(11:0) =ins(31:20) e imm(31:12) => extensão de sinal.
					to_signed(to_integer(signed(instr(31 downto 20))),32) when I_type,
						
					-- S-type: 12 bits, imm(11:0) = {ins(31:25), ins(11:7)} e imm(31:12) => extensão de sinal
					to_signed(to_integer(signed(instr(31 downto 25) & instr(11 downto 7))),32) when S_type,
						
					-- SB-type: 12 bits, imm(12:1) = {ins(31), ins(7), ins(30:25), ins(11:8)}, sendo imm(0) = 0 e imm(31:13) => extensão de sinal.
					to_signed(to_integer(signed(instr(31) & instr(7) & instr(30 downto 25) & instr(11 downto 8)) & '0'),32) when SB_type,
						
					-- UJ-type: 20 bits, imm(20:1) = {ins(31), ins(19:12), ins(20), ins(30:21)}, sendo imm(0) = 0 e imm(31:20) => extensão de sinal.
					to_signed(to_integer(signed(instr(31) & instr(19 downto 12) & instr(20) & instr(30 downto 21) & '0')),32) when UJ_type,
						
					--  U-type: 20 bits, imm(31:12), = ins(31:12) e os imm(11:0) = 0.          U-type
					shift_left(to_signed(to_integer(signed(instr(31 downto 12))),32), 12) when others;
        
	end process; 
end trab4;