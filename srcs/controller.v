`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/27/2024 12:08:27 PM
// Design Name: 
// Module Name: controller
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
module controller( input [6:0] Opcode,
                   input [6:0] Funct_7bit, 
                   input [2:0] Funct_3bit,
                   output [2:0] ImmSrc,
                   output [3:0] ALUControl,
                   output branch,
                   output MemWrite,
                   output [1:0] ResultSrc,
                   output ALUSrc,
                   output RegWrite,
                   output AUIPC,
                   output [1:0] RS_valid,
                   output [1:0] type,
                   output u,
                   output MemRead,
                   output [2:0] branch_type
                   );
parameter R_OP =  7'b0110011;
parameter I_OP = 7'b0010011 ; 
parameter I_LOAD_OP =  7'b0000011 ;
parameter STORE_OP =  7'b0100011;
parameter BRANCH_OP =  7'b1100011;  
parameter AUIPC_OP = 7'b0010111; 
parameter JAL_OP = 7'b1101111; 
parameter LUI_OP = 7'b0110111; 
parameter JALR_OP = 7'b1100111;
parameter BEQ = 3'b000,BNE = 3'b001,BLT = 3'b100,BGE = 3'b101,BLTU = 3'b110,BGEU = 3'b111; 
wire [1:0] ALUOp;  
assign branch_type = Funct_3bit;
assign type = Funct_3bit[1:0];
assign u = Funct_3bit[2];
assign AUIPC = (Opcode == AUIPC_OP)? 1 : 0;       
assign RegWrite = (Opcode == JAL_OP | Opcode == JALR_OP | Opcode == I_LOAD_OP | Opcode == R_OP | Opcode == I_OP | Opcode == LUI_OP | Opcode == AUIPC_OP )? 1 : 0;
assign ImmSrc = (Opcode == I_LOAD_OP | Opcode == I_OP | Opcode == JALR_OP)? 3'b000 :
                (Opcode == STORE_OP)? 3'b001 :
                (Opcode == JAL_OP)? 3'b010 :
                (Opcode == BRANCH_OP)? 3'b011 : 
                (Opcode == LUI_OP | Opcode == AUIPC_OP)? 3'b100 : 3'bxxx ; 
assign ALUSrc = (Opcode == JALR_OP | Opcode == I_LOAD_OP | Opcode == STORE_OP | Opcode == I_OP | Opcode == LUI_OP | Opcode == AUIPC_OP)? 1 : 0;
assign MemWrite = (Opcode == STORE_OP)? 1 : 0;
assign MemRead = (Opcode == I_LOAD_OP)? 1 : 0;
assign ResultSrc = (Opcode == JAL_OP | Opcode == JALR_OP)? 2'b10 : 
                    (Opcode == I_LOAD_OP)? 2'b01 : 2'b00;
assign branch = (Opcode == BRANCH_OP | Opcode == JAL_OP | Opcode == JALR_OP)? 1 : 0;
assign ALUOp = (Opcode == R_OP)? 2'b10 :
               (Opcode == BRANCH_OP)? 2'b01 : 2'b00;
assign RS_valid = (Opcode == R_OP | Opcode == STORE_OP | Opcode == BRANCH_OP)? 2'b00 : //dung rs2,rs1
                  (Opcode == JALR_OP | Opcode == I_LOAD_OP | Opcode == I_OP)? 2'b01 :  //dung rs1 
                  2'b10 ;
assign ALUControl = (Opcode == R_OP && Funct_3bit == 3'b000 && Funct_7bit[5] == 0)? 4'b0000 : //add
                    ((Opcode == BRANCH_OP && (Funct_3bit == BEQ || Funct_3bit == BNE))|
                    (Opcode == R_OP && Funct_3bit == 3'b000 && Funct_7bit[5] == 1))? 4'b0001 : //sub
                    ((Opcode == R_OP || Opcode == I_OP) && Funct_3bit == 3'b111)? 4'b0100 : //and
                    ((Opcode == R_OP || Opcode == I_OP) && Funct_3bit == 3'b110)? 4'b0011 : //or
                    ((Opcode == R_OP || Opcode == I_OP) && Funct_3bit == 3'b001)? 4'b0110 : //sll
                    ((Opcode == BRANCH_OP && (Funct_3bit == BLT || Funct_3bit == BGE))|
                    ((Opcode == R_OP || Opcode == I_OP) && Funct_3bit == 3'b010))? 4'b1001 : //slt
                    ((Opcode == BRANCH_OP && (Funct_3bit == BLTU || Funct_3bit == BGEU))|
                    ((Opcode == R_OP || Opcode == I_OP) && Funct_3bit == 3'b011))? 4'b0101 : //sltu
                    ((Opcode == R_OP || Opcode == I_OP) && Funct_3bit == 3'b101 && Funct_7bit[5] == 0)? 4'b0111 : //srl
                    ((Opcode == R_OP ||  Opcode == I_OP) && Funct_3bit == 3'b101 && Funct_7bit[5] == 1)? 4'b1000 ://sra
                    ((Opcode == R_OP || Opcode == I_OP) && Funct_3bit == 3'b100)? 4'b0010 : 4'b0000;//xor

endmodule 
