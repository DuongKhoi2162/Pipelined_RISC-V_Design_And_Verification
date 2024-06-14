`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/27/2024 01:50:50 PM
// Design Name: 
// Module Name: rom
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

//================================================
//  University  : UIT - www.uit.edu.vn
//  Course name : System-on-Chip Design
//  Lab name    : lab3
//  File name   : rom.v
//  Author      : Pham Thanh Hung
//  Date        : Oct 21, 2017
//  Version     : 1.0
//-------------------------------------------------
// Modification History
//
//================================================
module rom(
//input
addr,
//output
data
);

input [31:0] addr;
output [31:0] data;

reg [7:0] ROM [1024:0] ; 
initial $readmemb("instruction.txt" , ROM )  ; 
assign data[31:24] = ROM[addr] ; 
assign data[23:16] = ROM[addr+1] ; 
assign data[15:8] = ROM[addr+2] ; 
assign data[7:0] = ROM[addr+3] ; 
endmodule
