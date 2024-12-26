`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Saffox
// 
// Create Date: 05.12.2024 09:35:34
// Design Name: 
// Module Name: riscv_sng_cp
// Project Name: RISCV-CPU
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

import riscv_pkg::*;

module riscv_sng_cp(
    input CLK,
    input instruction instr_D,
    
    // Control Signal
    input wire FLG_ZR,
    output data_addr_t data_ADDR_CTRL,
    output alu_cmd_t ALU_CTRL,              
    output alu_src_t ALU_SRC_B,
    output imm_src_t IMM_SRC,
    output data_ext_t DATA_RES_CTRL,
    output logic RG_WR,
    output logic MEM_WR,            
    output pc_src_mux PC_SRC,
    output pc_plus_t PC_Plus
    );
    
    always_comb begin
        case (instr_D.data.opcode)
            7'b0110111: begin       // 'LUI' INSTRUCTION
                data_ADDR_CTRL = FULL_ADDR;
                ALU_SRC_B = IMM_ALU;
                ALU_CTRL = ALU_UNDEF;  // ALU NOT USE IN THIS INSTRUCTION
                IMM_SRC = IMM_SHIFT;
                DATA_RES_CTRL = DATA_NOMEM;
                RG_WR = 1'b1;
                //if(MEM_WR == 1'b1) MEM_WR = CLK;
                //else MEM_WR = 1'b0;
                MEM_WR = 1'b0;
                PC_Plus = UNDEF_IMM;
                PC_SRC = PC_CONST;
            end
            7'b0010111: begin       // 'AUIPC' INSTRUCTION
                data_ADDR_CTRL = FULL_ADDR;
                ALU_SRC_B = IMM_ALU;            
                IMM_SRC = IMM_SHIFT;     
                ALU_CTRL = ALU_ADD;       
                DATA_RES_CTRL = DATA_NOMEM;     
                RG_WR = 1'b1;                   
                //if(MEM_WR == 1'b1) MEM_WR = CLK;
                //else MEM_WR = 1'b0;
                MEM_WR = 1'b0;                  
                PC_Plus = PC_IMM;
                PC_SRC = PC_CONST;                             
            end
            7'b1100111, 7'b1101111: begin        // JUMP INSTRUCTIONS (JALx)
                data_ADDR_CTRL = UNDEF_ADDR;  
                ALU_SRC_B = IMM_ALU;
                ALU_CTRL = ALU_UNDEF;  // ALU NOT USE IN THIS INSTRUCTION
                if(instr_D.data.opcode[3] == 1'b1) begin
                    IMM_SRC = IMM_J;   //JAL
                    PC_Plus = PC_IMM;
                end
                else begin
                    IMM_SRC = IMM_I;   //JALR
                    PC_Plus = RG_IMM; 
                end     
                DATA_RES_CTRL = DATA_PC;    
                RG_WR = 1'b1;               
                //if(MEM_WR == 1'b1) MEM_WR = CLK;
                //else MEM_WR = 1'b0;
                MEM_WR = 1'b0;              
                PC_SRC = PC_TARGET;         
            end
            
            7'b1100011: begin       // BRANCH INSTRUCTIONS (Bxx)
                data_ADDR_CTRL = UNDEF_ADDR;
                ALU_SRC_B = REG_ALU;
                IMM_SRC = IMM_B;
                case (instr_D.B.funct3)             // FOR B-TYPE COMMANDS (BANCH)
                    3'b000: ALU_CTRL = ALU_SUB;     // BEQ (rs1 == rs2) | BNE (rs1 != rs2) 
                    3'b001: ALU_CTRL = ALU_SUB;     // BEQ (rs1 == rs2) | BNE (rs1 != rs2) 
                    3'b100: ALU_CTRL = ALU_SLT;     // BLT (rs1 < rs2) | BGE (rs1 >= rs2)
                    3'b101: ALU_CTRL = ALU_SLT;     // BLT (rs1 < rs2) | BGE (rs1 >= rs2)
                    3'b110: ALU_CTRL = ALU_SLTU;    // BLTU (urs1 < urs2) | BGEU (urs1 >= urs2)
                    3'b111: ALU_CTRL = ALU_SLTU;    // BLTU (urs1 < urs2) | BGEU (urs1 >= urs2)
                    default: ALU_CTRL = ALU_UNDEF;
                endcase
                DATA_RES_CTRL = DATA_UNDEF;
                RG_WR = 1'b0;
                //if(MEM_WR == 1'b1) MEM_WR = CLK;
                //else MEM_WR = 1'b0;
                MEM_WR = 1'b0;          
                PC_Plus = PC_IMM;
                if (instr_D.B.funct3[14:13] === 3'b00) begin
                    if(FLG_ZR === 1'b1 && instr_D.B.funct3[12] === 1'b0) PC_SRC = PC_TARGET;
                    else PC_SRC = PC_CONST;
                end
                else if (instr_D.B.funct3[14:13] === 3'b10) begin
                    if(FLG_ZR === 1'b1 && instr_D.B.funct3[12] === 1'b0) PC_SRC = PC_CONST;
                    else PC_SRC = PC_TARGET;
                end
                else begin
                    if(FLG_ZR === 1'b1 && instr_D.B.funct3[12] === 1'b1) PC_SRC = PC_CONST;
                    else PC_SRC = PC_TARGET;
                end
            end
            
            7'b0000011: begin       // LOAD INSTRUCTIONS (Lx[x])
                data_ADDR_CTRL = FULL_ADDR;
                ALU_SRC_B = IMM_ALU;
                IMM_SRC = IMM_I;
                ALU_CTRL = ALU_ADD;
                case (instr_D.I.funct3)
                    3'b000: DATA_RES_CTRL = DATA_B;
                    3'b001: DATA_RES_CTRL = DATA_H;
                    3'b010: DATA_RES_CTRL = DATA_FULL;
                    3'b100: DATA_RES_CTRL = DATA_BU;
                    3'b101: DATA_RES_CTRL = DATA_HU;
                    default: DATA_RES_CTRL = DATA_UNDEF;
                endcase
                RG_WR = 1'b1;
                //if(MEM_WR == 1'b1) MEM_WR = CLK;
                //else MEM_WR = 1'b0;
                MEM_WR = 1'b0;
                PC_Plus = UNDEF_IMM;          
                PC_SRC = PC_CONST;
            end
            
            7'b0100011: begin       // STORE INSTRUCTIONS (Sx)
                case (instr_D.S.funct3)
                    3'b000: data_ADDR_CTRL = BYTE_ADDR;
                    3'b001: data_ADDR_CTRL = HALF_ADDR;
                    3'b010: data_ADDR_CTRL = FULL_ADDR;
                    default: data_ADDR_CTRL = UNDEF_ADDR;
                endcase
                ALU_SRC_B = IMM_ALU;
                ALU_CTRL = ALU_ADD;
                IMM_SRC = IMM_S;
                DATA_RES_CTRL = DATA_UNDEF;
                RG_WR = 1'b0;
                MEM_WR = 1'b1;          
                PC_Plus = UNDEF_IMM;
                PC_SRC = PC_CONST;
            end
            7'b0010011: begin       // OP-IMM INSTRUCTIONS
                data_ADDR_CTRL = FULL_ADDR;
                if(instr_D.I.funct3[13:12] == 2'b01) ALU_SRC_B = REG_ALU;
                else ALU_SRC_B = IMM_ALU;
                case (instr_D.I.funct3)         // FOR I-TYPE COMMANDS (OP-IMM)
                    3'b000: ALU_CTRL = ALU_ADD; // ADDI
                    3'b010: ALU_CTRL = ALU_SLT; // SLTI
                    3'b011: ALU_CTRL = ALU_SLTU;// SLTIU
                    3'b100: ALU_CTRL = ALU_XOR; // XORI 
                    3'b110: ALU_CTRL = ALU_OR;  // ORI
                    3'b111: ALU_CTRL = ALU_AND; // ANDI
                    default: ALU_CTRL = ALU_UNDEF;
                endcase
                IMM_SRC = IMM_I;
                DATA_RES_CTRL = DATA_NOMEM;
                RG_WR = 1'b1;
                //if(MEM_WR == 1'b1) MEM_WR = CLK;
                //else MEM_WR = 1'b0;
                MEM_WR = 1'b0;          
                PC_Plus = UNDEF_IMM;
                PC_SRC = PC_CONST;
            end
            
            7'b0110011: begin       // OP INSTRUCTIONS
                data_ADDR_CTRL = FULL_ADDR;
                ALU_SRC_B = REG_ALU;
                case ({instr_D.R.funct7, instr_D.R.funct3}) // FOR R-TYPE COMMANDS (OP)
                    10'b0000000_000: ALU_CTRL = ALU_ADD;    // ADD
                    10'b0100000_000: ALU_CTRL = ALU_SUB;    // SUB
                    10'b0000000_001: ALU_CTRL = ALU_SLL;    // SLL
                    10'b0000000_010: ALU_CTRL = ALU_SLT;    // SLT
                    10'b0000000_011: ALU_CTRL = ALU_SLTU;   // SLTU
                    10'b0000000_100: ALU_CTRL = ALU_XOR;    // XOR
                    10'b0000000_101: ALU_CTRL = ALU_SRL;    // SRL
                    10'b0100000_101: ALU_CTRL = ALU_SRA;    // SRA
                    10'b0000000_110: ALU_CTRL = ALU_OR;     // OR
                    10'b0100000_110: begin                  // ORN (dop)
                        ALU_CTRL = ALU_OR;
                        ALU_SRC_B = INV_REG_ALU;
                    end
                    10'b0000000_111: ALU_CTRL = ALU_AND;    // AND
                    10'b0100000_111: begin                  // ANDN (dop)
                        ALU_CTRL = ALU_AND;    
                        ALU_SRC_B = INV_REG_ALU;
                    end
                    
                    default:  ALU_CTRL = ALU_UNDEF;
                endcase
                IMM_SRC = IMM_R;
                DATA_RES_CTRL = DATA_NOMEM;
                RG_WR = 1'b1;
                //if(MEM_WR == 1'b1) MEM_WR = CLK;
                //else MEM_WR = 1'b0;
                MEM_WR = 1'b0;          
                PC_Plus = UNDEF_IMM;
                PC_SRC = PC_CONST;
            end
        
            default: begin
                data_ADDR_CTRL = UNDEF_ADDR;
                ALU_CTRL = ALU_UNDEF;        
                ALU_SRC_B = UNDEF_ALU;
                IMM_SRC = IMM_UNDEF;
                DATA_RES_CTRL = DATA_UNDEF;
                RG_WR = 1'bX;
                MEM_WR = 1'bX;    
                PC_Plus = UNDEF_IMM;     
                PC_SRC = PC_UNDEF;
            end
        endcase 
    end
    
endmodule
