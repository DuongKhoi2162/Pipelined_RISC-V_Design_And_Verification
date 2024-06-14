`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/26/2024 10:08:22 PM
// Design Name: 
// Module Name: ALU
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


module ALU(
    input [3:0] op, 
    input [31:0] operand1 , 
    input [31:0] operand2 , 
    output zero,
    output [31:0] result
    );
assign result = (op == 4'b0000)? operand1 + operand2 : //add
                (op == 4'b0001)? operand1 - operand2 : //sub
                (op == 4'b0010)? operand1 ^ operand2 : //xor
                (op == 4'b0011)? operand1 | operand2 : //or
                (op == 4'b0100)? operand1 & operand2 : //and
                (op == 4'b1001)? operand1 < operand2 : //slt
                (op == 4'b0110)? operand1 << operand2[4:0]: //sll, slli
			    (op == 4'b0111)? operand1 >> operand2[4:0]: //srl, srli
			    (op == 4'b1000)? operand1 >>> operand2[4:0]: //sra, srai
			    (op == 4'b0101)? 
			                     (({operand1[31],operand2[31]} == 2'b01)? 0 :
			                     ({operand1[31],operand2[31]} == 2'b10)? 1 :
			                     operand1[30:0] < operand2[30:0] ): //sltu 
			    operand1 + operand2 ; 		                  		                     
assign zero = (result == 0)? 1'b1 : 1'b0 ; 
endmodule

