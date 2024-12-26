`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Saffox
// 
// Create Date: 04.12.2024 12:45:15
// Design Name: 
// Module Name: prog_counter
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

module prog_counter #(parameter DWIDTH = 32)(
    input logic CLK,
    input logic RST,
    input pc_src_mux PCSrc,
    input logic [DWIDTH-1:0] D_Target,
    output logic [DWIDTH-1:0] instr_ADDR,
    output logic [DWIDTH-1:0] next_instr_ADDR
    );
    
    always_ff @(posedge CLK) begin
        next_instr_ADDR = instr_ADDR == (2**DWIDTH)-1 ? 0 : instr_ADDR + 'b100;
        
        if (RST === 'b1) instr_ADDR = 'b0;
        else begin 
            if(PCSrc == PC_TARGET) instr_ADDR = D_Target;
            else instr_ADDR = next_instr_ADDR;   // default PC +4
        end
        
        next_instr_ADDR = instr_ADDR == (2**DWIDTH)-1 ? 0 : instr_ADDR + 'b100;
    end

endmodule
