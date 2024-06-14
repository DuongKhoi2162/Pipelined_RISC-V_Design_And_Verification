`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/26/2024 11:04:14 PM
// Design Name: 
// Module Name: Registers
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

module Registers(
input [4:0] raddr1_regf ,
input [4:0] raddr2_regf , 
input [4:0] waddr_regf , 
input [31:0] wdata_regf , 
output [31:0] regf_rdata1 , 
output [31:0] regf_rdata2 , 
input reg_write ,
input clk,
input rst
);
reg [31:0] regf [0:31] ;
integer i ; 
initial begin 
    for(i = 0 ; i < 32 ; i = i + 1 ) begin 
        regf[i] = 32'b0 ; 
    end 
end 
always@(*) begin 
     regf[0] = 0 ; 
end 
always@(negedge clk) begin 
if(reg_write) begin //write
  regf[waddr_regf] <= wdata_regf;
 end
end 
assign regf_rdata2 =  (!rst)? 32'b0:regf[raddr2_regf] ; 
assign regf_rdata1 =  (!rst)? 32'b0:regf[raddr1_regf] ; 
endmodule

