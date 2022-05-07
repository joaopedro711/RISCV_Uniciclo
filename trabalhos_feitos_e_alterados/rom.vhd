--#########################################################
--#* Referente a Memória ROM  
--#*                                              			   
--#* João Pedro de Oliveira Silva               190057807          
--#* Gabriel Ritter Domingues dos Santos        190067543                     
--#*                                              
--#########################################################

library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

-- Fornecido pelo professor
entity rom_rv is 
 port (
	 address : in std_logic_vector(11 downto 0);
	 dataout : out std_logic_vector(31 downto 0)
 );
end entity rom_rv;



--Arquitetura pra ROM
architecture arc_rom of rom_rv is 
	type rom_type is array (0 to (2**(address'length)-1)) of std_logic_vector(dataout' range);
	
	impure function init_rom return rom_type is
		file text_file: text open read_mode is "C:\Users\Particular\Documents\GitHub\RISCV_Uniciclo\trabalhos_feitos_e_alterados\testROM.txt";    -- arquivo hexadecimal pra rom_rv
		variable text_line: line;
		variable rom_content: rom_type;
		
		begin 
			for i in 0 to (2**(address'length) - 1)  loop
			if not endfile(text_file) then
			 readline(text_file,text_line);
			 hread(text_line,rom_content(i));
			end if;
			end loop;
		return rom_content;
	end function;	
	
	signal rom_rv: rom_type := init_rom;
	signal s_addr : std_logic_vector(address' range);
begin

s_addr <= address;

process (s_addr)
begin
	dataout <= rom_rv(to_integer(unsigned(s_addr)));
end process;

end arc_rom;
