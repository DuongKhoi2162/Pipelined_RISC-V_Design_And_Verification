`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/07/2024 10:04:35 AM
// Design Name: 
// Module Name: Pipeline_Stage4
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


module Pipeline_Stage4(
    input [6:0] op,
    output reg [6:0] op_out,
    input clk,
    input rst,
    input RegWrite, 
    input MemWrite, 
    input [1:0] Result,
    input [4:0] RdD,
    input [31:0] pc_incr4_out, 
    input [31:0] wdata,
    input [31:0] ALU_Result,
    input [1:0] type,
    input u,
    output reg RegWrite_o,
    output reg [1:0] Result_o,
    output reg [31:0] ALU_Result_o,
    output reg [31:0] ReadData_o,
    output reg [4:0] RdD_o,
    output reg [31:0] pc_incr4_out_o
    );
    //wire for DMem 
    //input
    wire [31:0] Address;
    wire [31:0] WriteData;
    wire WriteEn; 
    assign Address = ALU_Result;
    assign WriteData = wdata;
    assign WriteEn = MemWrite;
    //output  
    wire [31:0] ReadData;
    //DMem
    data_memory DMEM(
                    .clk(clk),
                    .rst(rst),
                    .Address(Address),
                    .WriteData(WriteData), 
                    .WriteEn(WriteEn),
                    .ReadData(ReadData),
                    .type(type),
                    .u(u) //u == 1 => unsigned
                    );
    //pipeline
    always @(posedge clk or negedge rst) begin
        if(!rst) begin
            RegWrite_o <= 0; 
            Result_o <= 0;
            ALU_Result_o <= 0;
            ReadData_o <= 0;
            RdD_o <= 0;
            pc_incr4_out_o <= 0;
            op_out <= 0;
        end
        else begin
            RegWrite_o <= RegWrite; 
            Result_o <= Result;
            ALU_Result_o <= ALU_Result;
            ReadData_o <= ReadData;
            RdD_o <= RdD;
            pc_incr4_out_o <= pc_incr4_out;
            op_out <= op;
        end
    end
endmodule
