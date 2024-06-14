`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/08/2024 04:26:31 PM
// Design Name: 
// Module Name: Mux3_1
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


module Mux3_1(
    input [31:0] a,
    input [31:0] b,
    input [31:0] c,
    input [1:0] s,
    output [31:0] d
    );
    assign d = (s==2'b00)? a :
               (s==2'b01)? b :
               (s==2'b10)? c : 32'bz ; 
endmodule
