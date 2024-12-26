`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Saffox
// 
// Create Date: 02.12.2024 16:43:32
// Design Name: 
// Module Name: alu
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

module alu #(parameter DWIDTH = 32)(
    input logic [DWIDTH-1:0] op1,
    input logic [DWIDTH-1:0] op2,
    input alu_cmd_t cmd,
    output logic flg_zr,
    output logic [DWIDTH-1:0] res
    );
    
    logic [31:0] comp;
    
    assign flg_zr = res === 'b0 ? 1'b1 : 1'b0;   // res > 'b0 ? 1'b0 : 1'b1;
    
    always_comb begin
        if(op1 == 'bX || op2 == 'bX) res = 'bX;
        else begin
            if (cmd == ALU_SUB) comp = (-op2);
            else comp = op2;
            
            case (cmd)
                ALU_ADD: res = op1 + comp;
                ALU_SUB: res = op1 + comp;
                ALU_XOR: res = op1 ^ op2;
                ALU_OR: res = op1 | op2;
                ALU_AND: res = op1 & op2;
                ALU_SLL: res = op1 << op2[4:0];
                ALU_SRL: res = op1 >> op2[4:0];
                ALU_SRA: res = op1 >>> op2;
                ALU_SLT: res = $signed(op1) < $signed(op2) ? 1'b1 : 1'b0;
                ALU_SLTU: res = op1 < op2 ? 1'b1 : 1'b0;
                default: res = 'bX;
            endcase
        end
    end

endmodule
