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

type regs is array (0 to 31) of std_logic_vector (31 downto 0);

signal registradores :regs:=(others => (others => '0'));

signal tgr : std_logic := '0';

	begin
    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                for I in 0 to 31 loop
					registradores(I) <= X"00000000";
				end loop;
            end if;

            if wren = '1' then
                registradores(to_integer(unsigned(rd))) <= data;
            end if;

            tgr <= not tgr after 2 ns;

        end if;
    end process;

    process(registradores, tgr)
    begin
        case( rs1 ) is
        
            when "00000" => ro1 <= std_logic_vector(to_signed(0, 32));
            when "UUUUU" => ro1 <= std_logic_vector(to_signed(0, 32));                
        
            when others => ro1 <= registradores(to_integer(unsigned(rs1)));        
        end case ;

        case( rs2 ) is
        
            when "00000" => ro2 <= std_logic_vector(to_signed(0, 32));
            when "UUUUU" => ro2 <= std_logic_vector(to_signed(0, 32));                
        
            when others => ro2 <= registradores(to_integer(unsigned(rs2)));          
        end case ;
    end process;
end trab5;