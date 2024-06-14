`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/08/2024 03:33:38 AM
// Design Name: 
// Module Name: hazard_unit
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

module hazard_unit(
    input rst, 
    input RegWriteM, 
    input RegWriteW, 
    input [4:0] RD_M,
    input [4:0] RD_W, 
    input [4:0] Rs1_E,
    input [4:0] Rs2_E, 
    output [1:0] ForwardAE,
    output [1:0] ForwardBE,
    input [1:0] RS_valid);
    

     assign ForwardAE =  (rst == 1'b0) ? 2'b00 : 
                       ((RegWriteM == 1'b1) & (RD_M != 5'h00) & (RD_M == Rs1_E) & RS_valid != 2'b10) ? 2'b10 :
                       ((RegWriteW == 1'b1) & (RD_W != 5'h00) & (RD_W == Rs1_E) & RS_valid != 2'b10) ? 2'b01 : 2'b00;
             
     assign ForwardBE = (rst == 1'b0) ? 2'b00 : 
                       ((RegWriteM == 1'b1) & (RD_M != 5'h00) & (RD_M == Rs2_E) &  RS_valid == 2'b00) ? 2'b10 :
                       ((RegWriteW == 1'b1) & (RD_W != 5'h00) & (RD_W == Rs2_E) & RS_valid == 2'b00) ? 2'b01 : 2'b00;                
     
endmodule
