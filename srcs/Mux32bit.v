`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/26/2024 11:01:02 PM
// Design Name: 
// Module Name: Mux32bit
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


module Mux32bit(
    input [31:0] A , 
    input [31:0] B , 
    input sel , 
    output [31:0] Result 
    );
    assign Result = (sel == 0) ? A : B ; 
endmodule
