--#########################################################
--#* Referente ao Trab V: Banco de Registradores do RISC-V  
--#*                                              			   
--#* João Pedro de Oliveira Silva               190057807          
--#* Gabriel Ritter Domingues dos Santos        190067543                     
--#*                                              
--#########################################################

library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity XREGS is									-- Função fornecida pelo professor
  generic (WSIZE : natural := 32);				-- tamanho do vetor
  port (
        clk, wren, rst  : in std_logic;
        rs1, rs2, rd    : in std_logic_vector(4 downto 0);
        data            : in std_logic_vector(WSIZE-1 downto 0);
        ro1, ro2        : out std_logic_vector(WSIZE-1 downto 0)
    );
end XREGS;

architecture trab5 of XREGS is

type regs is array (31 downto 0) of std_logic_vector (31 downto 0);

signal registradores :regs;

	begin
    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                for I in 0 to 31 loop
					registradores(I) <= X"00000000";
				end loop;

            elsif wren = '1' then
                if to_integer(unsigned(rd)) /= 0 then
                    registradores(to_integer(unsigned(rd))) <= data;
                end if;

            else
                ro1 <= registradores(to_integer(unsigned(rs1)));
                ro2 <= registradores(to_integer(unsigned(rs2)));
             end if;
			 registradores(0) <= X"00000000";
        end if;
    end process;
end trab5;