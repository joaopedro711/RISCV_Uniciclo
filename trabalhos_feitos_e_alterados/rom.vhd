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

-- entidade fornecida pelo professor
entity rom_rv is 
 port (
	 clk_rom 	 : in std_logic;
	 address : in std_logic_vector(11 downto 0);
	 dataout : out std_logic_vector(31 downto 0)
 );
end entity rom_rv;



--arquitetura da memoria de instrucoes (rom)
architecture RTL of rom_rv is
	Type rom_type is array (0 to 2**12-1) of std_logic_vector(31 downto 0);
	signal mem : rom_type;
	signal initialize : std_logic;
	signal atraso : std_logic := '0';
  begin
	initialize <= '1';
	init_proc: process(initialize) is
	  -- funcao para iniciar a memoria de instrucoes com base no site disponibilizado pelo professor
	  impure function init_memory return rom_type is
		file rom_file : text open read_mode is "C:\Users\Particular\Desktop\RISCV_Uniciclo\trabalhos_feitos_e_alterados\testROM.txt";
		variable text_line : line;
		variable mem_content : rom_type;
		variable i : integer := 0;
	  begin
		while not endfile(rom_file) loop
		  readline(rom_file, text_line);
		  hread(text_line, mem_content(i));
		  i := i + 1;
		end loop;
	   
		return mem_content;
	  end function;
	begin
	  mem <= init_memory;
	end process init_proc;
  
	process(clk_rom) is
	begin
	  if (rising_edge(clk_rom)) then
		atraso <= not atraso after 1 ns; --atraso da saida de dados
	  end if;
	end process;
	  
	process(atraso)
	begin
	  dataout <= mem(to_integer(unsigned(address))/4);
	end process;
  end RTL;