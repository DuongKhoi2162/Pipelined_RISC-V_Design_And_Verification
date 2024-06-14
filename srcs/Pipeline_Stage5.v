`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/07/2024 11:13:50 AM
// Design Name: 
// Module Name: Pipeline_Stage5
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


module Pipeline_Stage5( 
    input RegWrite,
    input [1:0] Result,
    input [31:0] ALU_Result,
    input [31:0] ReadData,
    input [4:0] RdD,
    input [31:0] pc_incr4_out,
    output [4:0] RdW,
    output [31:0] ResultW,
    output RegWrite_o
    );
    assign ResultW = (Result == 2'b10)? pc_incr4_out:
                     (Result == 2'b01)? ReadData : ALU_Result;
    assign RdW = RdD;
    assign RegWrite_o = RegWrite ; 
endmodule
