`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Skit / Saffox
// 
// Create Date: 06.12.2024 09:43:26
// Design Name: 
// Module Name: top
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

module top( 
        input CLK, RST,
        
        output logic [7:0] led,     // For FPGA
        input logic [7:0] switch    // For FPGA
    );
    
   logic [XLEN-1:0] dop_RD_data;    // For FPGA
    
    logic [XLEN-1:0] instr_ADDR;
    // Programm MEM
    instruction instr_D;
    // Data MEM
    logic [XLEN-1:0] data_ADDR;
    logic [XLEN-1:0] data_WR;
    logic [XLEN-1:0] data_RD;
    // Control Signal
    wire FLG_ZR;            
    data_addr_t data_ADDR_CTRL;   
    alu_cmd_t ALU_CTRL;   
    alu_src_t ALU_SRC_B;          
    imm_src_t IMM_SRC;          
    data_ext_t DATA_RES_CTRL;     
    logic RG_WR; 
    logic MEM_WR;     
    pc_src_mux PC_SRC;            
    pc_plus_t PC_Plus;
    
    prog_mem prog_mem_inst (
        .a      (instr_ADDR[XLEN-1:2]),
        .spo    (instr_D[XLEN-1:0])
    );
    
    data_mem data_mem_inst (
        .a      (data_ADDR[XLEN-1:2]),
        .d      (data_WR),
        .clk    (CLK),
        .we     (MEM_WR & (~data_ADDR[XLEN-1])),    // MEM_WR without FPGA
        .spo    (data_RD[XLEN-1:0])
    );
    
    riscv_sng_dp dp_inst(
        .CLK            (CLK),
        .RST            (RST),
        // Counter
        .instr_ADDR     (instr_ADDR),
        // Programm MEM
        .instr_D        (instr_D),
        // Data MEM
        .data_ADDR      (data_ADDR),
        .data_WR        (data_WR),
        .data_RD        (dop_RD_data),  // data_RD without FPGA
        
        // Control Signal
        .FLG_ZR         (FLG_ZR),                 
        .data_ADDR_CTRL (data_ADDR_CTRL),   
        .ALU_CTRL       (ALU_CTRL),           
        .ALU_SRC_B      (ALU_SRC_B),          
        .IMM_SRC        (IMM_SRC),            
        .DATA_RES_CTRL  (DATA_RES_CTRL),     
        .RG_WR          (RG_WR),                   
        .PC_SRC         (PC_SRC),            
        .PC_Plus        (PC_Plus)     
    );
    
    
    riscv_sng_cp cp_instr(
        .CLK            (CLK),
        .instr_D        (instr_D),
        // Control Signal
        .FLG_ZR         (FLG_ZR),
        .data_ADDR_CTRL (data_ADDR_CTRL),
        .ALU_CTRL       (ALU_CTRL),              
        .ALU_SRC_B      (ALU_SRC_B), 
        .IMM_SRC        (IMM_SRC),
        .DATA_RES_CTRL  (DATA_RES_CTRL),
        .RG_WR          (RG_WR),
        .MEM_WR         (MEM_WR),            
        .PC_SRC         (PC_SRC),
        .PC_Plus        (PC_Plus)
    );
    
    // -- BLOCK FOR INSTALL IN FPGA ----- 
    ila_riscv_fpga ila_instr(
        .clk    (CLK),
        .probe0 (instr_ADDR),
        .probe1 (instr_D),
        .probe2 (data_ADDR),
        .probe3 (data_WR),
        .probe4 (data_RD),
        .probe5 (MEM_WR),
        .probe6 (RST)
    );
           
    always_comb begin
        dop_RD_data = data_ADDR[XLEN-1] ? {24'b0, switch} : data_RD;
    end
    
    always_ff @(posedge CLK) begin
        if(data_ADDR[XLEN-1] == 1'b1 && MEM_WR == 1'b1) led <= data_WR;
    end
    // ----------------------------------
    
endmodule
