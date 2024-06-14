`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/07/2024 08:44:50 AM
// Design Name: 
// Module Name: Pipeline_Stage3
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


module Pipeline_Stage3(
    input flush,
    input [6:0] op,
    output reg [6:0] op_out,
    input [2:0] branch_type,
    input clk,
    input rst,
    input [1:0] ForwardA_E,
    input [1:0] ForwardB_E, 
    input [31:0] WB_Data,
    input [31:0] Imm_SE,
    input [31:0] pc_incr4_out,
    input [31:0] pc_out,
    input [4:0] RdD,
    input [31:0] rdata1,
    input [31:0] rdata2,
    input [3:0] ALUControl,
    input branch,
    input MemWrite,
    input [1:0] Result,
    input ALUSrc,
    input RegWrite,
    output [31:0] PC_Branch_o,
    output reg ALU_zero_o,
    output reg [31:0] ALU_Result_o,
    output  PCSrcE,
    output reg RegWrite_o,
    output reg MemWrite_o,
    output reg [1:0] Result_o,
    output reg [4:0] RdD_o, 
    output reg [31:0] pc_incr4_out_o,
    output reg [31:0] wdata_o,
    input [1:0] type,
    output reg [1:0] type_o,
    input u,
    output reg u_o 
    );
    parameter BEQ = 3'b000,BNE = 3'b001,BLT = 3'b100,BGE = 3'b101,BLTU = 3'b110,BGEU = 3'b111; 
    //MuxALU1
    wire [31:0] rdata1_o;
    Mux3_1 Mux_ALUA (
                    .a(rdata1),
                    .b(WB_Data), //new
                    .c(ALU_Result_o), //new
                    .s(ForwardA_E), //neww
                    .d(rdata1_o) //new
                    );
    //MuxALU2 
    wire [31:0] rdata2_o; 
    Mux3_1 Mux_ALUB (
                    .a(rdata2),
                    .b(WB_Data), //new
                    .c(ALU_Result_o),
                    .s(ForwardB_E), //new
                    .d(rdata2_o) //new
                    );
    //wire for ALU_mux
    //input
    wire [31:0] RD2;
    wire [31:0] ImmExt;
    assign RD2 = rdata2_o ; 
    assign ImmExt = Imm_SE;
    //output
    wire [31:0] ALU_In2; 
    //ALU_Mux
    Mux32bit ALU_Mux(RD2,ImmExt,ALUSrc,ALU_In2);
    //wire for ALU
    //input
    wire [31:0] A,B; 
    wire [3:0] ALUSel;
    assign A = rdata1_o;
    assign B = ALU_In2;
    assign ALUSel = ALUControl;
    //output
    wire [31:0] ALU_Result,ALU_Result_temp;
    wire ALU_zero;
    //ALU
    ALU ALU_block(
                .op(ALUSel), 
                .operand1(A), 
                .operand2(B), 
                .zero(ALU_zero),
                .result(ALU_Result_temp)
                );
    //wire for Adder
    //////JALR JALR JALR JALR 
    assign ALU_Result = (op == 7'b1100111 ) ? {ALU_Result_temp[31:1],1'b0} :
                                              ALU_Result_temp ; 
    //input
    wire [31:0] PC;
    wire [31:0] SE;
    assign PC = pc_out;
    assign SE = Imm_SE;
    //output
    wire [31:0] PC_Branch;
    //Adder
    Add Add_Branch(
               .A(PC),
               .B(SE),
               .sum(PC_Branch)
               );
    assign PC_Branch_o = PC_Branch;
    assign PCSrcE =(branch && ((branch_type == BEQ && ALU_zero)||
                                (branch_type == BNE && !ALU_zero)||
                                (branch_type == BLT && ALU_Result)|| //slt
                                (branch_type == BGE && !ALU_Result)|| //slt
                                (branch_type == BLTU && ALU_Result)|| //sltu
                                (branch_type == BGEU && !ALU_Result)||
                                (op == 7'b1101111) ||
                                (op == 7'b1100111)           
                                ))? 1'b1 : 1'b0;
    //pipeline
    always @(posedge clk or negedge rst) begin
        if(rst == 1'b0) begin
            RegWrite_o <= 0; 
            MemWrite_o <= 0; 
            Result_o <= 0;
            RdD_o <= 0;
            pc_incr4_out_o <= 0; 
            wdata_o <= 0; 
            ALU_Result_o <= 0;
            type_o <= 1'bx;
            u_o <= 0;
            op_out <= 0 ; 
        end
        else begin
            
            RegWrite_o <= RegWrite; 
            MemWrite_o <= MemWrite; 
            Result_o <= Result;
            RdD_o <= RdD;
            pc_incr4_out_o <= pc_incr4_out; 
            wdata_o <= RD2; 
            ALU_Result_o <= ALU_Result;
            type_o <= type;
            u_o <= u;
            op_out <= op ; 
        end
    end
endmodule
