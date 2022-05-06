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
library work;
use work.riscv_pkg.all;             -- Pra usar as constantes do arquivo riscv_pkg.vhd

entity control is
	port (
		opcode : in std_logic_vector(6 downto 0);
		op_ula :	out std_logic_vector(1 downto 0);
		reg_dst,
		branch,				
		mem2reg,
		mem_read,
		mem_wr,
		alu_src,
		lui,
		auipc,
		jal,		
		jalr,
		breg_wr:	out std_logic
	);
end entity control;

architecture arc_control of control is

    begin
		process (opcode)
    begin
      	case opcode is

			-- R Type(Logico Aritmetico)
        	when iRType => 
				op_ula <= "10";
				reg_dst <= '1';
				branch <= '0';
				mem2reg <= '0';
				mem_read <= '0';
				mem_wr <= '0';
				alu_src <= '0';
				lui <= '0';
				auipc <= '0';
				jal <= '0';
				jalr <= '0';
				breg_wr <= '1';

            -- I Type(Logico Aritmetico)
			when iIType => 
				op_ula <= "11";
				reg_dst <= '0';
				branch <= '0';
				mem2reg <= '0';
				mem_read <= '0';
				mem_wr <= '0';
				alu_src <= '1';
				lui <= '0';
				auipc <= '0';
				jal <= '0';
				jalr <= '0';
				breg_wr <= '1';

            -- S Type (SW)
       		when iSType => 
				op_ula <= "00";
				reg_dst <= '0';
				branch <= '0';
				mem2reg <= '0';
				mem_read <= '0';
				mem_wr <= '1';
				alu_src <= '1';
				lui <= '0';
				auipc <= '0';
				jal <= '0';
				jalr <= '0';
				breg_wr <= '0';

	         -- LW
	      	when iILType =>
				op_ula <= "00";
				reg_dst <= '0';
				branch <= '0';
				mem2reg <= '1';
				mem_read <= '1';
				mem_wr <= '0';
				alu_src <= '1';
				lui <= '0';
				auipc <= '0';
				jal <= '0';
				jalr <= '0';
				breg_wr <= '1';
          
			 -- B(SB) Type	
			when iBType =>
				op_ula <= "01";
				reg_dst <= '0';
				branch <= '1';
				mem2reg <= '0';
				mem_read <= '0';
				mem_wr <= '0';
				alu_src <= '0';
				lui <= '0';
				auipc <= '0';
				jal <= '0';
				jalr <= '0';
				breg_wr <= '0';

			 -- U Type(LUI)
			when iLUI =>
				op_ula <= "00";
				reg_dst <= '0';
				branch <= '0';
				mem2reg <= '0';
				mem_read <= '0';
				mem_wr <= '0';
				alu_src <= '1';
				lui <= '1';
				auipc <= '0';
				jal <= '0';
				jalr <= '0';
				breg_wr <= '1';
				
        	-- U Type(AUIPC)  
        	when iAUIPC => 
        		op_ula <= "00";
				reg_dst <= '0';
				branch <= '0';
				mem2reg <= '0';
				mem_read <= '0';
				mem_wr <= '0';
				alu_src <= '1';
				lui <= '0';
				auipc <= '1';
				jal <= '0';
				jalr <= '0';
				breg_wr <= '1';
          
			 -- UJ Type(JAL)	
			when iJAL =>
				op_ula <= "00";
				reg_dst <= '0';
				branch <= '1';
				mem2reg <= '0';
				mem_read <= '0';
				mem_wr <= '0';
				alu_src <= '0';
				lui <= '0';
				auipc <= '0';
				jal <= '1';
				jalr <= '0';
				breg_wr <= '1';

			-- JALR
			when iJALR => 
				op_ula <= "10";
				reg_dst <= '0';
				branch <= '1';
				mem2reg <= '0';
				mem_read <= '0';
				mem_wr <= '0';
				alu_src <= '1';
				lui <= '0';
				auipc <= '0';
				jal <= '1';
				jalr <= '1';
				breg_wr <= '1';
          
			when others =>
				op_ula <= "00";
				reg_dst <= '0';
				branch <= '0';
				mem2reg <= '0';
				mem_read <= '0';
				mem_wr <= '0';
				alu_src <= '0';
				lui <= '0';
				auipc <= '0';
				jal <= '0';
				jalr <= '0';
				breg_wr <= '0';
				
    	end case;
  	end process;
    
end arc_control;    