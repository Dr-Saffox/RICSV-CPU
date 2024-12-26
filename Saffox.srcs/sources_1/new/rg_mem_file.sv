`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Saffox
// 
// Create Date: 03.12.2024 15:22:30
// Design Name: 
// Module Name: rg_mem_file
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

module rg_mem_file #(
    parameter DWIDTH = 8,
    parameter REG_CNT = 16,
    localparam AWIDTH = $clog2(REG_CNT)
    )(
    // Cntrl lines
    input CLK,
    //input ARST,
    input WR,
    //Data input
    input logic [DWIDTH-1:0] D,
    input logic [AWIDTH-1:0] WAddr,
    input logic [AWIDTH-1:0] RAddr_a,
    input logic [AWIDTH-1:0] RAddr_b,
    //Data output
    output logic [DWIDTH-1:0] Q_a,
    output logic [DWIDTH-1:0] Q_b
    );
    
    logic [DWIDTH-1:0] mem[REG_CNT];
    
    //assign Q <= nRST === 'b1 ? 'b0 : Q;
    
    always_comb begin
        if (RAddr_a == 1'b0) Q_a = 'b0;
        else Q_a = mem[RAddr_a];
        
        if (RAddr_b == 1'b0) Q_b = 'b0;
        else Q_b = mem[RAddr_b];
    end
        
    always_ff @(posedge CLK) begin
        if (WAddr != 0) mem[WAddr] <= D;           
    end
endmodule 
