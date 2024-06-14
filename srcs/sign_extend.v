`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/26/2024 11:03:42 PM
// Design Name: 
// Module Name: sign_extend
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


module sign_extend(
        input [31:0] Imm,
        input [2:0] ImmSrc,
        output [31:0] SE);
assign SE = (ImmSrc == 3'b000)? {{20{Imm[31]}},Imm[31:20]} :
            (ImmSrc == 3'b001)? {{20{Imm[31]}},Imm[31:25],Imm[11:7]}  :
            (ImmSrc == 3'b010)? {{11{Imm[31]}},Imm[31],Imm[19:12],Imm[20],Imm[30:21],1'b0} : 
            (ImmSrc == 3'b011)? {{19{Imm[31]}},Imm[31],Imm[7],Imm[30:25],Imm[11:8],1'b0} : 
            (ImmSrc == 3'b100)? {Imm[31:12],12'b0} : 32'bx ;  
endmodule