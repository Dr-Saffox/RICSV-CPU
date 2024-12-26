`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Saffox
// 
// Create Date: 04.12.2024 17:32:12
// Design Name: 
// Module Name: data_memory
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


module data_memory #(
    parameter DWIDTH = 8,
    parameter COUNT = 16
    )(
    input logic CLK,
    input logic WE,
    input logic [DWIDTH-1:0] ADDR,
    input logic [DWIDTH-1:0] DATA_WR,
    output logic [DWIDTH-1:0] DATA_RD
    );
    
    logic [DWIDTH-1:0] mem[COUNT];
    
    always_ff @(posedge CLK) begin
        DATA_RD = mem[ADDR];
        if (WE == 'b1) mem[ADDR] = DATA_WR; 
    end 

endmodule
