`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/26/2024 11:48:30 PM
// Design Name: 
// Module Name: instruction_mem
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


module instruction_mem(
    input [31:0] PC , 
    output [31:0] Inst 
    );
reg [7:0] ROM [0:1023];
initial $readmemb("instruction.txt" , ROM )  ; 
assign Inst[31:24] = ROM[PC] ; 
assign Inst[23:16] = ROM[PC+1] ; 
assign Inst[15:8] = ROM[PC+2] ; 
assign Inst[7:0] = ROM[PC+3] ; 
endmodule
