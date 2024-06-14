`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/10/2024 08:44:32 PM
// Design Name: 
// Module Name: riscv_io
// Project Name: 
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


interface riscv_io(input bit clock);
    logic reset_n;
    logic [31:0] addr;
    logic [31:0] data;
clocking cb@(posedge clock);
    default input #1ns output #1ns ;
    output reset_n;
    output data;
    input addr;
endclocking:cb
modport TB(clocking cb, output reset_n, input addr);
endinterface
