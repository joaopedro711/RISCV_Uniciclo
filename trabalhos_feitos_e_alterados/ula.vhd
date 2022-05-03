--#########################################################
--#* Referente ao Trab VI: ULA do RISC-V    
--#*                                              			   
--#* João Pedro de Oliveira Silva               190057807          
--#* Gabriel Ritter Domingues dos Santos        190067543                     
--#*                                              
--#########################################################
library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

-- entity fornecida pelo professor
entity ulaRV is
    generic (WSIZE : natural := 32);
    port (
          opcode : in std_logic_vector(3 downto 0);
          A, B : in std_logic_vector(WSIZE-1 downto 0);
          Z : out std_logic_vector(WSIZE-1 downto 0);
          zero : out std_logic
        );
end ulaRV;

architecture trab6 of ulaRV is
begin
    process(opcode, A, B, Z, zero)
    begin
        case opcode is

            -- ADD 
            when "0000" =>
            Z <= std_logic_vector(signed(A) + signed(B));
			zero <= '0';

            -- SUB
            when "0001" =>
            Z <= std_logic_vector(signed(A) - signed(B));
			zero <= '0';

            -- AND
            when "0010" =>
            Z <= A AND B;
			zero <= '0';
			
            -- OR
            when "0011" =>
            Z <= A OR B;
			zero <= '0';

            -- XOR
            when "0100" =>
            Z <= A XOR B;
			zero <= '0';

            -- SLL
            when "0101" =>
            Z <= std_logic_vector(shift_left(unsigned(A), to_integer(unsigned(B))));
			zero <= '0';

            -- SRL
            when "0110" =>
            Z <=  std_logic_vector(shift_right(unsigned(A), to_integer(unsigned(B))));
			zero <= '0';

            -- SRA
            when "0111" =>
            Z <=  std_logic_vector(shift_right(signed(A), to_integer(unsigned(B))));
			zero <= '0';

            -- SLT
            when "1000" =>
            if signed(A) < signed(B) then
                Z <= x"00000001";
				zero <= '1';
			else
				Z <= x"00000000";
				zero <= '0';
            end if;

            -- SLTU
            when "1001" =>
            if unsigned(A) < unsigned(B) then
                Z <= x"00000001";
				zero <= '1';
			else
				Z <= x"00000000";
				zero <= '0';
            end if;
			
            -- SGE
            when "1010" =>
            if signed(A) >= signed(B) then
                Z <= x"00000001";
				zero <= '1';
			else
				Z <= x"00000000";
				zero <= '0';
            end if;

            -- SGEU
            when "1011" =>
            if unsigned(A) >= unsigned(B) then
                Z <= x"00000001";
				zero <= '1';
			else
				Z <= x"00000000";
				zero <= '0';
            end if;

            -- SEQ
            when "1100" =>
            if A = B then
                Z <= x"00000001";
				zero <= '1';
			else
				Z <= x"00000000";
				zero <= '0';
            end if;

            -- SNE
            when "1101" =>
            if A /= B then
                Z <= x"00000001";
				zero <= '1';
			else
				Z <= x"00000000";
				zero <= '0';
            end if;

            when others => 
				Z <= "00000000000000000000000000000000";
				zero <= '0';
        end case;
    end process;
end trab6;