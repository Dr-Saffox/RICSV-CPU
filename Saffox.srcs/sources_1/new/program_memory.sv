`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Saffox
// 
// Create Date: 04.12.2024 17:32:12
// Design Name: 
// Module Name: program_memory
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


module program_memory #(
    parameter DWIDTH = 8,
    parameter COUNT = 16
    )(
    input logic WE,
    input logic [DWIDTH-1:0] ADDR,
    output logic [DWIDTH-1:0] DATA_RD
    );
    
    logic [DWIDTH-1:0] mem[COUNT];
    
    always_comb DATA_RD = mem[ADDR];

endmodule
