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
library work;
use work.riscv_pkg.all;             -- Pra usar as constantes do arquivo riscv_pkg.vhd


entity alu_ctr is
	port (
		op_alu		: in std_logic_vector(1 downto 0);
		funct3		: in std_logic_vector(2 downto 0);
		funct7      : in std_logic_vector(6 downto 0);
		alu_ctr	    : out std_logic_vector(3 downto 0)
	);
end entity alu_ctr;

architecture arc_alu_control of alu_ctr is
    begin
        process (op_alu, funct3, funct7, alu_ctr)
        
        begin
      
            case op_alu is
        
                when "00" => -- ADD(SW, LW, LUI, AUIPC)
                    alu_ctr <= ULA_ADD;         
                  
                when "01" => -- Branch(saltos)
                    if funct3 =  iBEQ3  then --BEQ
                        alu_ctr <= ULA_SNE; --SNE
                    end if;
                    
                    if funct3 = iBNE3 then --BNE
                        alu_ctr <= ULA_SEQ; --SEQ
                    end if;
                    
                    if funct3 = iBLT3 then -- BLT
                        alu_ctr <= ULA_SGE; --SGE
                    end if;
                    
                    if funct3 = iBGE3 then --BGE
                        alu_ctr <= ULA_SLT; --SLT
                    end if;
                  
                  
                when "10" => -- R Type
                  
                    if funct3 = (iADDSUB3 or iADD3)  then --ADD ou SUB
                        if funct7(5) = (iSUB7 or iSRA7 or iSRAI7) then --SUB
                            alu_ctr <= ULA_SUB; --SUB
                        else
                            alu_ctr <= ULA_ADD; --ADD
                        end if;
                    end if;
                    
                    if funct3 = iSLL3 then --SLL
                        alu_ctr <= ULA_SLL; --SLL
                    end if;
                    
                    if funct3 = iSLTI3 then 
                        alu_ctr <= ULA_SLT; --SLT
                    end if;
                    
                    if funct3 = iSLTU then 
                        alu_ctr <= ULA_SLTU; --SLTU
                    end if;
                    
                    if funct3 = iXOR3 then 
                        alu_ctr <= ULA_XOR; --XOR
                    end if;
                    
                    if funct3 = (iSR3 or iSRI3) then --SRL ou SRA
                        if funct7(5) = (iSUB7 or iSRA7 or iSRAI7) then 
                            alu_ctr <= ULA_SRA; --SRA
                        else
                            alu_ctr <= ULA_SRL; --SRL
                        end if;
                    end if;
                    
                    if funct3 = iOR3  then 
                        alu_ctr <= ULA_OR; --OR
                    end if;
                    
                    if funct3 = iAND3 then --AND
                        alu_ctr <= ULA_AND; --AND
                    end if;
                    
                    
                when "11" => -- I Type
                     
                    if funct3 = iADD3 then --ADDi
                        alu_ctr <= ULA_ADD; --ADDi
                    end if;
                    
                    if funct3 = iSLTI3 then --SLTi
                        alu_ctr <= ULA_SLT; --SLTi
                    end if;
                    
                    if funct3 = iSLTIU3 then --SLTUi
                        alu_ctr <= ULA_SLTU; --SLTUi
                    end if;
                    
                    if funct3 = iXOR3 then --XORi
                        alu_ctr <= ULA_XOR; --XORi
                    end if;
                    
                    if funct3 = iSLL3 then --SLLi
                        alu_ctr <= ULA_SLL; --SLLi
                    end if;
                    
                    if funct3 = (iSR3 or iSRI3) then --SRLi ou SRAi
                        if funct7(5) = (iSUB7 or iSRA7 or iSRAI7) then --SRAi
                        alu_ctr <= ULA_SRA; --SRAi
                        else
                        alu_ctr <= ULA_SRL; --SRLi
                        end if;
                    end if;
                    
                    if funct3 = iOR3 then --ORi
                        alu_ctr <= ULA_OR; --ORi
                    end if;
                    
                    if funct3 = iAND3 then --ANDi
                        alu_ctr <= ULA_AND; --ANDi
                    end if;
                  
                when others =>
                    alu_ctr <= ULA_ADD; -- 0000

            end case;
        end process;
end arc_alu_control;