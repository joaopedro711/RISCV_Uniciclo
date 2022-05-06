--#########################################################
--#* Referente ao Trab IV: Geração de Dados Imm32 no RISC-V    
--#*                                              			   
--#* João Pedro de Oliveira Silva  		      190057807          
--#* Gabriel Ritter Domingues dos Santos      190067543                     
--#*                                              
--#########################################################

entity genImm32 is
port(	instr : in std_logic_vector(31 downto 0);
		imm32 : out signed(31 downto 0));
end genImm32;

architecture arq of genImm32 is

begin

  process(instr) is
  begin
  
  --Rtype
  imm32 <= X"00000000" when (instr and "00000000000000000000000001111111")= "00000000000000000000000000110011";
  
  --Utype
  imm32 <= resize(signed(instr(31 downto 12) & "000000000000"), 32) when(instr and "00000000000000000000000001111111") = "00000000000000000000000000110111";
  
  --Stype
  imm32 <= resize(signed(instr(31 downto 25) & instr(11 downto 7)), 32) when (instr and "00000000000000000000000001111111") = "00000000000000000000000000100011";
  
  --Itype0
  imm32 <= resize(signed(instr(31 downto 20)), 32) when (instr and "00000000000000000000000001111111") = "00000000000000000000000000000011";
	
  --Itype1
  imm32 <= resize(signed(instr(31 downto 20)), 32) when (instr and "00000000000000000000000001111111") = "00000000000000000000000000010011";
  
  --Itype2
  imm32 <= resize(signed(instr(31 downto 20)), 32) when (instr and "00000000000000000000000001111111") = "00000000000000000000000001100111";
  
  --SBtype
  imm32 <= resize(signed(instr(31) & instr(7) & instr(30 downto 25) & instr(11 downto 8) & "0"), 32) when (instr and "00000000000000000000000001111111") = "00000000000000000000000001100011";
  
  --UJtype
  imm32 <= resize(signed(instr(31) & instr(19 downto 12) & instr(20) & instr(30 downto 21) & "0"), 32) when (instr and "00000000000000000000000001111111") = "00000000000000000000000001101111";
  
  end process;  
end arq;