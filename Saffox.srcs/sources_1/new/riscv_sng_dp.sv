`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Saffox
// 
// Create Date: 04.12.2024 12:52:18
// Design Name: 
// Module Name: riscv_sng_dp
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

module riscv_sng_dp(
    input CLK,
    input RST,
    // Counter
    output logic [XLEN-1:0] instr_ADDR,
    
    // Programm MEM
    input instruction instr_D,
    
    // Data MEM
    output logic [XLEN-1:0] data_ADDR,
    output logic [XLEN-1:0] data_WR,
    input logic [XLEN-1:0] data_RD,
    
    // Control Signal
    output wire FLG_ZR,                 
    input data_addr_t data_ADDR_CTRL,   
    input alu_cmd_t ALU_CTRL,           
    input alu_src_t ALU_SRC_B,          
    input imm_src_t IMM_SRC,            
    input data_ext_t DATA_RES_CTRL,     
    input logic RG_WR,                   
    input pc_src_mux PC_SRC,            
    input pc_plus_t PC_Plus             
    );
    
    
    // COUNTER CONNECT
    logic [XLEN-1:0] PC_out_next;
    logic [XLEN-1:0] PCTarget;
    
    prog_counter #(
        .DWIDTH (XLEN)
    ) COUNTER (
        .CLK                (CLK),
        .RST                (RST),
        .PCSrc              (PC_SRC),
        .D_Target           (PCTarget),
        .instr_ADDR         (instr_ADDR),
        .next_instr_ADDR    (PC_out_next)
    );
    
    // REG FILE CONNECT
    logic [XLEN-1:0]WR_D3;
    logic [$clog2(XLEN)-1:0] A1;
    logic [$clog2(XLEN)-1:0] A2;
    logic [$clog2(XLEN)-1:0] A3;
    logic [XLEN-1:0] RD1;
    logic [XLEN-1:0] RD2;

    rg_mem_file #(
        .DWIDTH (XLEN),
        .REG_CNT (XLEN)
    ) RG_MEM (
        .CLK     (CLK),
        .WR      (RG_WR),
        .D       (WR_D3),
        .RAddr_a (A1),
        .RAddr_b (A2),
        .WAddr   (A3),
        .Q_a     (RD1),
        .Q_b     (RD2)
    );
    
    // ALU CONNECT
    logic [XLEN-1:0] ALU_RESULT;
    logic [XLEN-1:0] SRC_A;
    logic [XLEN-1:0] SRC_B;
    
    alu #(
        .DWIDTH (XLEN)
    ) ALU (
        .op1    (SRC_A),
        .op2    (SRC_B),
        .cmd    (ALU_CTRL),
        .flg_zr (FLG_ZR),
        .res    (ALU_RESULT)
    );
    
    
    // FUNCTIONAL
    logic [XLEN-1:0] IMM_EXT;
    logic [XLEN-1:0] RESULT;
    
    // INIT WIRES
    assign SRC_A = RD1;
    assign WR_D3 = RESULT;  // for 16 bit cmd 
    assign data_WR = RD2;
    
    assign A1 = instr_D[19:15];
    assign A2 = instr_D[24:20];
    assign A3 = instr_D[11:7];
    
    
    always_comb begin
        // 2nd OPERAND FOR PCTarget
        PCTarget = IMM_EXT + (PC_Plus == PC_IMM ? instr_ADDR : RD1);
    end    
    
    always_comb begin
        case (data_ADDR_CTRL)
            BYTE_ADDR: data_ADDR = ALU_RESULT[7:0];
            HALF_ADDR: data_ADDR = ALU_RESULT[15:0];
            default: data_ADDR = ALU_RESULT;
        endcase 
    end
    
    always_comb begin
    // EXTEND2 BLOCK (FOR LBx HBx) in ALU MUX RES
        case (DATA_RES_CTRL)       
            DATA_FULL: RESULT = data_RD;
            DATA_B: RESULT = {{24{data_RD[7]}}, data_RD[7:0]};
            DATA_BU: RESULT = {{24{1'b0}}, data_RD[7:0]};
            DATA_H: RESULT = {{16{data_RD[15]}}, data_RD[15:0]}; 
            DATA_HU: RESULT = {{16{1'b0}}, data_RD[15:0]};
            DATA_NOMEM: RESULT = ALU_RESULT;
            DATA_PC: RESULT = PC_out_next;
            default: RESULT = 'bX;   // (NOT NORMAL)
        endcase  
    end
    
    always_comb begin
        // ALU MUX SRC
        if(ALU_SRC_B == REG_ALU) SRC_B = RD2;
        else if(ALU_SRC_B == INV_REG_ALU) SRC_B = ~RD2;
        else if(ALU_SRC_B == IMM_ALU) SRC_B = IMM_EXT;  
        else SRC_B = PCTarget;
    end
    
    always_comb begin
    // EXTEND BLOCK
        case (IMM_SRC) 
            IMM_I: IMM_EXT = {{20{instr_D.data[31]}}, instr_D.I.imm};
            IMM_U: IMM_EXT = {{12{instr_D.data[31]}}, instr_D.U.imm};
            IMM_S: IMM_EXT = {{20{instr_D.data[31]}}, instr_D.S.imm_11_5, instr_D.S.imm_4_0}; 
            IMM_B: IMM_EXT = {{20{instr_D.data[31]}}, instr_D.B.imm_12, instr_D.B.imm_11, instr_D.B.imm_10_5, instr_D.B.imm_4_1, 1'b0};
            IMM_J: IMM_EXT = {{12{instr_D.data[31]}}, instr_D.J.imm_20, instr_D.J.imm_19_12, instr_D.J.imm_11, instr_D.J.imm_10_1, 1'b0};
            IMM_SHIFT: IMM_EXT = {{12{instr_D.data[31]}}, instr_D.U.imm} << 12; 
            default: IMM_EXT = 'hX;
        endcase
    end
     
endmodule
