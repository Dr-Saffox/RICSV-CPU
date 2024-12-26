`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Saffox
// 
// Create Date: 02.12.2024 16:40:28
// Design Name: 
// Module Name: riskv_pkg
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


package riscv_pkg;

    parameter XLEN = 32;

    // ALU_CTRL
    typedef enum {
        ALU_UNDEF,
        ALU_ADD,
        ALU_SUB,
        ALU_AND,
        ALU_OR,
        ALU_XOR,
        ALU_SLL,
        ALU_SRL,
        ALU_SRA,
        ALU_SLT,
        ALU_SLTU
    } alu_cmd_t;

    // ALU_SRC_B
    typedef enum {
        UNDEF_ALU,
        REG_ALU,
        INV_REG_ALU,
        IMM_ALU,
        PC_IMM_ALU
    } alu_src_t;

    // DATA_ADDR_CTRL
    typedef enum {
        UNDEF_ADDR,
        BYTE_ADDR,
        HALF_ADDR,
        FULL_ADDR
    } data_addr_t;

    // IMM_SRC
    typedef enum {
        IMM_UNDEF,
        IMM_R,
        IMM_I,
        IMM_S,
        IMM_B,
        IMM_J,
        IMM_U,
        IMM_SHIFT   // haram ?..
    } imm_src_t;
    
    // DATA_RES_CTRL
    typedef enum {
        DATA_UNDEF,
        DATA_FULL,
        DATA_B,
        DATA_BU,
        DATA_H,
        DATA_HU,
        DATA_NOMEM,
        DATA_PC
    } data_ext_t;
    
    // PC_PLus
    typedef enum {
        UNDEF_IMM,
        RG_IMM,
        PC_IMM
    } pc_plus_t;

    // PC_SRC
    typedef enum {
        PC_UNDEF,
        PC_TARGET,
        PC_CONST
    } pc_src_mux;

    // --- INSTRUCTIONS ----
    typedef struct packed {
        logic [31:25] funct7;
        logic [24:20] rs2;
        logic [19:15] rs1;
        logic [14:12] funct3;
        logic [11:7] rd;
        logic [6:0] opcode;
    } r_cmd_t;
    
    typedef struct packed {
        logic [31:20] imm;
        logic [19:15] rs1;
        logic [14:12] funct3;
        logic [11:7] rd;
        logic [6:0] opcode;
    } i_cmd_t;
    
    typedef struct packed {
        logic [31:25] imm_11_5;
        logic [24:20] rs2;
        logic [19:15] rs1;
        logic [14:12] funct3;
        logic [11:7] imm_4_0;
        logic [6:0] opcode;
    } s_cmd_t;
    
    typedef struct packed {
        logic imm_12;
        logic [30:25] imm_10_5;
        logic [24:20] rs2;
        logic [19:15] rs1;
        logic [14:12] funct3;
        logic [11:8] imm_4_1;
        logic imm_11;
        logic [6:0] opcode;
    } b_cmd_t;
    
    typedef struct packed {
        logic [31:12] imm;
        logic [11:7] rd;
        logic [6:0] opcode;
    } u_cmd_t;
    
    
    typedef struct packed {
        logic imm_20;
        logic [30:21] imm_10_1;
        logic imm_11;
        logic [19:12] imm_19_12;
        logic [11:7] rd;
        logic [6:0] opcode;
    } j_cmd_t;
    // ----------------------
    
    typedef union packed {
        struct packed {
            logic [31:7] bits;
            logic [6:0] opcode;
        } data;
        r_cmd_t R;
        i_cmd_t I;
        s_cmd_t S;
        b_cmd_t B;
        u_cmd_t U;
        j_cmd_t J;
    } instruction;

endpackage : riscv_pkg;
