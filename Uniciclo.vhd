--#########################################################
--#* Programa principal, que executa todos os componentes
--#*                                              			   
--#* João Pedro de Oliveira Silva               190057807          
--#* Gabriel Ritter Domingues dos Santos        190067543                     
--#*                                              
--#########################################################
library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
use work.riscv_pkg.all;

entity rv_uniciclo is
    port(
        clk			: in std_logic;
        clk_rom		: in std_logic;
        rst	   		: in std_logic;
        data  		: out std_logic_vector(WORD_SIZE-1 downto 0)
        );
end rv_uniciclo;
architecture projeto of rv_uniciclo is

    --Sinais para cada component

    -- SInais para o PC e Memoria ROM(instruções)
    signal PC_dataIn : std_logic_vector(WORD_SIZE-1 downto 0);
    signal endere_instruction : std_logic_vector(WORD_SIZE-1 downto 0); 
    signal instruction : std_logic_vector(WORD_SIZE-1 downto 0);

    -- Sinais para controle
    signal branch: std_logic;
    signal reg_destino: std_logic;
    signal memToReg : std_logic;
    signal memRead: std_logic;
    signal ALUop: std_logic_vector(1 downto 0);
    signal ULASrc: std_logic;
    signal memWrite: std_logic;
    signal regWrite: std_logic;
    signal aux_is_LUI   : std_logic;
    signal aux_is_AUIPC : std_logic;
    signal jalx : std_logic;
    signal jalRx : std_logic;

    -- Sinal para Registers
    signal reset: std_logic;
    signal regWriteData: std_logic_vector(WORD_SIZE-1 downto 0);
    signal s_rs1: std_logic_vector(WORD_SIZE-1 downto 0);
    signal s_rs2: std_logic_vector(WORD_SIZE-1 downto 0);

    -- sinal para Saída de 1 de Register
    signal Ula_saida_read_data_1: std_logic_vector(WORD_SIZE-1 downto 0);

    --Sinal para gerador de imediatos
    signal imm32: std_logic_vector(WORD_SIZE-1 downto 0);

    --Sinais para Ula
    signal ULADataIn1: std_logic_vector(WORD_SIZE-1 downto 0);
    signal ULACtr: std_logic_vector(3 downto 0);
    signal ULAResult: std_logic_vector(WORD_SIZE-1 downto 0);
    signal ULAZero: std_logic;

    --sinal pra memoria de dados
    signal D_memory_out: std_logic_vector(WORD_SIZE-1 downto 0);
    
    -- Sinal da soma de PC + 4
    signal PC_soma_4: std_logic_vector(WORD_SIZE-1 downto 0);

    --Sinal do somador com shift
    signal PC_soma_shift: std_logic_vector(WORD_SIZE-1 downto 0);

    -- Sinal da operação de AND
    signal AND_branch_ULAzero: std_logic;
   
    -- Sinal pro Mux que recebe o seletor MemToReg e faz Data Memory com ALU(alu result)
    signal writeBackData: std_logic_vector(WORD_SIZE-1 downto 0);

    -- Saída do pc que será feito mux com imm32, depende se é JALR
    signal PC_imm: std_logic_vector(WORD_SIZE-1 downto 0);

    -- As etapas correspondem ao caminho no projeto.
    begin
        PC_init: pc port map(
            clk => clk,
            we => '1',
            addr_in => PC_dataIn,
            addr_out => endere_instruction
        );
    
        Intruction_Memory: rom_rv port map(
            address => endere_instruction(11 downto 0), --(0000000000000000000xxxxxxxxxxxx)
            dataout => instruction                      -- recebe toda instrução e passará cada parte pra cada operação
        );
    
        -- tirando o opcode, o restante são todas as saídas do controle, com adição de outras coisas
        Intruction_to_Control: control port map (
            opcode => instruction(6 downto 0),  --segundo o riscv, opcode são os ultimos 7 bits
            op_ula => ALUop,
            reg_dst => reg_destino,
            branch => branch,
            mem2reg => memToReg,
            mem_read => memRead,
            mem_wr => memWrite,
            alu_src => ULASrc,
            lui => aux_is_LUI,
            auipc => aux_is_AUIPC,
            jal => jalx,
            jalr => jalRx,
            breg_wr => regWrite
        );
    
        Registers: XREGS port map (
            clk => clk,
            wren => regWrite,
            rst => reset,
            rs1 => instruction(19 downto 15), -- bits referentes a rs1
            rs2 => instruction(24 downto 20), -- bits referentes a rs2
            rd => instruction(11 downto 7),   -- bits referentes a rd
            data => regWriteData,              -- 
            ro1 => s_rs1,                     --saída
            ro2 => s_rs2                      --saída
        );

        -- Ula recebe a saída de read data 1
        Ula_saida_read_data_1 <= s_rs1;
    
        GenImm32_i: genImm32 port map (
            instr => instruction,
            imm32 => imm32              -- saída do imediato
        );
    
        --Mux pra entrar na Alu (AluResult)
        MuxAluResult: mux2p1 port map (
            sel => ULASrc,              --recebe o sinal que sai do controle
            A => s_rs2,                 -- s_rs2 é saída 2 do Registers
            B => imm32,                 -- imm32 é a sáida do immediato
            X => ULADataIn1             -- será a entrada para Alu (Alu Result)
        );
        
        -- Controle da Ula
        Alu_Control: alu_controle port map ( 
            op_alu => ALUop,                                   --ALUop é a saída do Control
            funct3 => instruction(14 downto 12),               -- intrução do 14 ao 12 é funct 3
            funct7 => instruction(WORD_SIZE-1 downto 25),      -- intrução do 31 ao 25 é funct7
            alu_ctr => ULACtr                                  -- saída da Ula, será o seletor da ALU (Alu result)
        );
    
        -- Ula (Alu Result)
        ULA_i: ulaRV port map (
            opcode => ULACtr,                           -- o que sai da Alu_Control
            A => Ula_saida_read_data_1,                 -- entrada é o que sai de Registers 
            B => ULADataIn1,                            -- outra entrada é o que sai do Mux(MuxAluResult)
            Z => ULAResult,                             -- Saída da ULA(ALuResult)
            zero => ULAZero                             -- sinal que irá fazer um "AND" com Branch pra entrar em um Mux
        );
        
        -- Memoria de dados
        Data_Memory: ram_rv port map (
            clock => clk,
            we => memWrite,                            -- sinal que sai do controle
            address => ULAResult(11 downto 0),
            datain => s_rs2,                           -- saída 2 do Registers
            dataout => D_memory_out                    -- saída da memória de dados 
        );
    
        --Mux que recebe o seletor MemToReg e faz Data Memory com ALU(alu result)
        MuxMemToReg_ALU: mux2p1 port map (
            sel => memToReg,                    --mem2reg
            A => ULAResult,                     -- recebe saída da ALU result
            B => D_memory_out,                  -- recebe saída da Data Memory
            X => writeBackData                  -- valor que volta pra Registers
        );
        
        -- Inicio do Diagrama, PC + 4
        PC_4: adder port map (
            A => endere_instruction,                    -- Recebe o valor que sai do PC
            B => std_logic_vector(to_signed(4, 32)),    -- Recebe o valor '4' em binário
            res => PC_soma_4                            -- Valor da soma de PC + 4
        );
        
        -- Soma de PC + imm32(shiftado)
        PC_SUM_SHIFT: adder port map (
            A => PC_imm,                                -- Depende do valor de JALR
            B => imm32,                                  --valor do imediato
            res => PC_soma_shift                         -- valor do pc somado com shift
        );
        
        -- AND da saída branch de REGISTERS com a saída ULA zero 
        AND_branch_ULAzero <= (branch and ULAZero) or (jalx);


        -- Entrada do PC é a saída do Mux PC_soma_shift
        PC_MUX: mux2p1 port map (
            sel => AND_branch_ULAzero,              --seletor é a AND da saída branch de REGISTERS com a saída ULA zero 
            A => PC_soma_4,                         --saida do somador PC + 4
            B => PC_soma_shift,                     --saida do somador PC + imm32 shiftado
            X => PC_dataIn                          --será a entrada no PC
        );
    
        -- Seleciona a entrada para o banco de registradores
        -- Caso a operação seja um JAL, é necessário salvar o endereço de retorno
        JAL_RETURN_SAVE_MUX: mux2p1 port map (
            sel => jalx,                            -- vai ser jal
            A => writeBackData,                     -- valor que volta pro Registers
            B => PC_soma_4,                         -- é a saída do PC+4            
            X => regWriteData                       -- valor que sai do XREGS
        );
    
        -- Seleciona a entrada para o somador de PC com imediato
        -- Caso a operação seja um JALR, é necessário somar o valor em rs1 com o imediato
        JALR_RS1_MUX: mux2p1 port map (
            sel => jalRx,                         -- se é jalR
            A => endere_instruction,                -- saída do PC
            B => s_rs1,                             -- saída do XREGS
            X => PC_imm                             -- pra somar PC + shift
        );
  end projeto;