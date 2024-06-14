`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/07/2024 04:39:36 PM
// Design Name: 
// Module Name: Pipeline_RISCV
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


module Pipeline_RISCV(
    input clk,
    input rst
    //output [31:0] pc_tb,
    //input [31:0] inst_tb
    );    
    wire [31:0] pc_jump,pc_out,pc_out_o,pc_incr4_out,pc_incr4_out_o,Imm_SE_o,rdata1,rdata2,Imm_SE,wdata;
    wire RegWriteW,MemWrite,branch,ALUSrc,RegWriteID ; 
    wire pc_src = 0 ; 
    wire [31:0] inst_out ;
    wire [3:0] ALUControl;
    wire [4:0] RdD,RS1_E,RS2_E; 
    reg stall_init;
    //wire used in EX
    wire [31:0] PC_Branch,ALU_Result,pc_incr4_out_EX,wdata_EX;
    wire PCSrcE,RegWrite_EX,ALU_zero,MemWrite_EX;
    wire [4:0] RdD_EX;
    //wire used in DM
    wire [31:0] ALU_Result_DM,RD,pc_incr4_out_DM;
    wire RegWrite_DM;
    wire [4:0] RdD_DM,waddr;
    //Instruction Fetch 
    wire [1:0] ForwardA_E,ForwardB_E,Result,Result_EX,Result_DM;
    wire [31:0] stall_inst;
    wire flush ; 
    wire [31:0] fl_pc ; 
    wire fl_signal ; 
    Pipeline_Stage1 IF(
                    .fl_pc(fl_pc),
                    .fl_signal(fl_signal),
                    .flush(flush),
                    .clk(clk), 
                    .rst(rst), 
                    .pc_src(PCSrcE), 
                    .pc_jump(PC_Branch),
                    .stall_inst(stall_inst),
                    .inst_out(inst_out),
                    .pc_out(pc_out),
                    .pc_incr4_out(pc_incr4_out),
                    .stall(stall)
                    );
    //Instruction Decode
    wire [1:0] RS_valid,type;  
    wire u,MemRead;
    wire [2:0] branch_type;
    wire [6:0] op;
    Pipeline_Stage2 ID(
                    .flush(flush),
                    .clk(clk), 
                    .rst(rst),
                    .waddr(waddr),
                    .inst_out(inst_out),
                    .pc_out(pc_out),
                    .pc_incr4_out(pc_incr4_out),
                    .wr_result(wdata), 
                    .RegWriteW(RegWriteID),
                    .Imm_SE_o(Imm_SE),
                    .pc_incr4_out_o(pc_incr4_out_o),
                    .pc_out_o(pc_out_o),
                    .RdD_o(RdD),
                    .rdata1_o(rdata1),
                    .rdata2_o(rdata2),
                    .ALUControl_o(ALUControl),
                    .branch_o(branch),
                    .MemWrite_o(MemWrite),
                    .Result_o(Result),
                    .ALUSrc_o(ALUSrc),
                    .RegWrite_o(RegWriteW),
                    .RS1_E(RS1_E),
                    .RS2_E(RS2_E),
                    .RS_valid_o(RS_valid),
                    .type_o(type),
                    .u_o(u),
                    .stall(stall),
                    
                    .MemRead_o(MemRead),
                    .branch_type_o(branch_type),
                    .op_out(op)
                    );
    //Execute 
    //[31:0] PC_Branch_o,[31:0] ALU_Result_o,pc_incr4_out_o,wdata_o[4:0] RdD_o,
    wire [1:0] type_EX;
    wire u_EX;
    wire [6:0] op_out;
    Pipeline_Stage3 EX(
                    .flush(flush),
                    .op(op),
                    .op_out(op_out),
                    .branch_type(branch_type),
                    .clk(clk),
                    .rst(rst),
                    .ForwardA_E(ForwardA_E),
                    .ForwardB_E(ForwardB_E), 
                    .WB_Data(wdata),
                    .Imm_SE(Imm_SE),
                    .pc_incr4_out(pc_incr4_out_o),
                    .pc_out(pc_out_o),
                    .RdD(RdD),
                    .rdata1(rdata1),
                    .rdata2(rdata2),
                    .ALUControl(ALUControl),
                    .branch(branch),
                    .MemWrite(MemWrite),
                    .Result(Result),
                    .ALUSrc(ALUSrc),
                    .RegWrite(RegWriteW),
                    .PC_Branch_o(PC_Branch),
                    .ALU_zero_o(ALU_zero),
                    .ALU_Result_o(ALU_Result),
                    .PCSrcE(PCSrcE),
                    .RegWrite_o(RegWrite_EX),
                    .MemWrite_o(MemWrite_EX),
                    .Result_o(Result_EX),
                    .RdD_o(RdD_EX),
                    .pc_incr4_out_o(pc_incr4_out_EX),
                    .wdata_o(wdata_EX),
                    .type(type),
                    .type_o(type_EX),
                    .u(u),
                    .u_o(u_EX) 
                    );
    //assign pc_src = PCSrcE;
    //Data Memory
    wire [6:0] op_out_DM;
    Pipeline_Stage4 DM(
                    .op(op_out),
                    .op_out(op_out_DM),
                    .clk(clk),
                    .rst(rst),
                    .RegWrite(RegWrite_EX), 
                    .MemWrite(MemWrite_EX), 
                    .Result(Result_EX),
                    .RdD(RdD_EX),
                    .pc_incr4_out(pc_incr4_out_EX), 
                    .wdata(wdata_EX),
                    .ALU_Result(ALU_Result),
                    .RegWrite_o(RegWrite_DM),
                    .Result_o(Result_DM),
                    .ALU_Result_o(ALU_Result_DM),
                    .ReadData_o(RD),
                    .RdD_o(RdD_DM),
                    .pc_incr4_out_o(pc_incr4_out_DM),
                    .type(type_EX),
                    .u(u_EX)
                    );                             
    //Write Back
    Pipeline_Stage5 WB( 
                    .RegWrite(RegWrite_DM),
                    .Result(Result_DM),
                    .ALU_Result(ALU_Result_DM),
                    .ReadData(RD),
                    .RdD(RdD_DM),
                    .pc_incr4_out(pc_incr4_out_DM),
                    .RdW(waddr),
                    .ResultW(wdata),
                    .RegWrite_o(RegWriteID)
                    );
        // Hazard Unit
    hazard_unit Forwarding_block (
                        .rst(rst), 
                        .RegWriteM(RegWrite_EX), 
                        .RegWriteW(RegWrite_DM), 
                        .RD_M(RdD_EX), 
                        .RD_W(RdD_DM), 
                        .Rs1_E(RS1_E), 
                        .Rs2_E(RS2_E), 
                        .ForwardAE(ForwardA_E), 
                        .ForwardBE(ForwardB_E),
                        .RS_valid(RS_valid)
                        );
       //
           //opcode_delay(for stall lw)
            //wire [6:0] op_delay; 
            wire [4:0] dest,stall_rs1,stall_rs2;  
            //assign op_delay = inst_out[6:0];
            assign dest = RdD ; 
            assign stall_rs1 = inst_out[19:15];
            assign stall_rs2 = inst_out[24:20];
            //assign stall = (op_delay == 3 & ( dest == inst_out[19:15] | dest == inst_out[24:20] ))? 1'b1 : 1'b0 ; 
            reg stall_r ;  
            always @(*) begin
                if( MemRead & (dest == stall_rs1 | dest == stall_rs2))
                    stall_r <= 1'b1;
                else stall_r <= 1'b0;
            end
            assign stall = stall_r ;
            reg flush_r = 0  ;  
            always @(*) begin
                if (inst_out[6:0]== 7'b1100011 | inst_out[6:0]== 7'b1101111 | inst_out[6:0]== 7'b1100111 )
                    flush_r <= 1'b1;
                if (op_out_DM[6:0] == 7'b1100011 | op_out_DM[6:0]== 7'b1101111 | op_out_DM[6:0]== 7'b1100111 ) 
                    flush_r <= 1'b0;
                end
            reg [31:0] flush_pc = 0;
            reg flush_signal = 0 ;

            always @(*) begin
                if (inst_out[6:0] ==7'b1100011)
                    flush_pc <= pc_incr4_out;   
                if (op == 7'b1100011) 
                    flush_signal <= 1'b1; 
                else flush_signal <= 1'b0;
            end
            assign fl_pc = flush_pc; 
            assign fl_signal = flush_signal;
            assign flush = flush_r;
endmodule
