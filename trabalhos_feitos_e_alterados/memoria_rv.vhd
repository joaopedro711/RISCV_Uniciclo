--#########################################################
--#* Referente ao Trab VII: Memória RiscV   
--#*                                              			   
--#* João Pedro de Oliveira Silva               190057807          
--#* Gabriel Ritter Domingues dos Santos        190067543                     
--#*                                              
--#########################################################

library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

-- Fornecido pelo professor
entity rom_rv is 
 port (
	 address : in std_logic_vector(11 downto 0);
	 dataout : out std_logic_vector(31 downto 0)
 );
end entity rom_rv;

entity ram_rv is
 port (
	 clock : in std_logic;
	 we : in std_logic;
	 address : in std_logic_vector(11 downto 0);
	 datain : in std_logic_vector(31 downto 0);
	 dataout : out std_logic_vector(31 downto 0)
 );
end entity ram_rv;

--Arquitetura pra ROM
architecture arc_rom of rom_rv is 
	type rom_type is array (0 to (2**(address'length)-1)) of std_logic_vector(dataout' range);
	
	impure function init_rom return rom_type is
		file text_file: text open read_mode is "testROM.txt";    -- arquivo hexadecimal pra rom_rv
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

--Arquitetura pra RAM
architecture arc_ram of ram_rv is 
	type ram_type is array (0 to (2**(address'length)-1)) of std_logic_vector(datain' range);
	
	impure function init_ram return ram_type is
		file text_file: text open read_mode is "testeRAM.txt";
		variable text_line: line;
		variable ram_content: ram_type;
		
		begin 
			for i in 0 to (2**(address'length) - 1)  loop
			if not endfile(text_file) then
			 readline(text_file,text_line);
			 hread(text_line,ram_content(i));
			end if;
			end loop;
		return ram_content;
	end function;	
	
	signal ram_rv: ram_type := init_ram;
	signal s_addr : std_logic_vector(address' range);

begin
Write: process(clock) begin
if rising_edge(clock) then 
    if we = '1' then
        ram_rv(to_integer(unsigned(address))) <= datain;
    end if;
end if;
s_addr <= address;
end process;

dataout <= ram_rv(to_integer(unsigned(s_addr)));

end arc_ram;