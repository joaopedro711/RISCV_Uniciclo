--#########################################################
--#* Referente a memoria RAM 
--#*                                              			   
--#* João Pedro de Oliveira Silva               190057807          
--#* Gabriel Ritter Domingues dos Santos        190067543                     
--#*                                              
--#########################################################

library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;


entity ram_rv is
 port (
	 clk : in std_logic;
	 we : in std_logic;
	 re : in std_logic;
	 address : in std_logic_vector(31 downto 0);
	 datain : in std_logic_vector(31 downto 0);
	 dataout : out std_logic_vector(31 downto 0)
 );
end entity ram_rv;


--arquitetura para a memoria ram
architecture arc_ram of ram_rv is 
Type ram_type is array (0 to 2**14-1) of std_logic_vector(31 downto 0);
signal wre_ram, init_ram_aux : ram_type := (others => (others => '0'));

type mem_addresses is array (0 to 2**12-1) of std_logic;
signal written_addresses : mem_addresses := (others => '0');
signal init_file : std_logic;
signal atraso : std_logic := '0';

begin
init_file <= '1';
init_proc: process(init_file) is
  -- funcao para ler o arquivo txt disponibilizado pelo professor
  impure function init_ram return ram_type is
	file text_file : text open read_mode is "C:\Users\Particular\Desktop\RISCV_Uniciclo\trabalhos_feitos_e_alterados\testRAM.txt";
	variable text_line : line;
	variable mem_content : ram_type;
	variable i : integer := 0;
  begin
	for i in 0 to 2047 loop
	  mem_content(i) := std_logic_vector(to_unsigned(0, 32));
	end loop;

	while not endfile(text_file) loop
	  readline(text_file, text_line);
	  -- O endereço base é 0x2000 = 8192. Mas como acessamos só palavras, a base é 8192/4 = 2048
	  hread(text_line, mem_content(i + 2048));
	  i := i + 1;
	end loop;
   
	return mem_content;
  end function;
  -- END init_ram
  variable mem_temp : ram_type;
begin
	init_ram_aux <= init_ram;
end process init_proc;

root_proc: process(clk) is
  variable write_address : integer;
begin
  write_address := to_integer(unsigned(address(15 downto 0)))/4;
  if (rising_edge(clk)) then
	-- Escrita não deve ser atrasada
	if we = '1' then
	  report "wre_ram written" severity note;
	  wre_ram(write_address) <= datain;
	  written_addresses(write_address) <= '1';
	end if;

	atraso <= not atraso after 3 ns;
  end if;
end process root_proc;

atrasoed_proc: process (atraso)
  variable result_address : integer;
begin
  result_address := to_integer(unsigned(address(15 downto 0)))/4;

  if re = '1' then
	if written_addresses(result_address) = '1' then
	  report "wre_ram read" severity note;
	  dataout <= wre_ram(result_address);
	else
	  report "init_ram read" severity note;
	  dataout <= init_ram_aux(result_address);
	end if;
  else
	  dataout <= std_logic_vector(to_unsigned(0, 32));
  end if;
end process atrasoed_proc;


end arc_ram;