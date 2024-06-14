`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/05/2024 03:11:02 PM
// Design Name: 
// Module Name: Pipeline_Stage2
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


module Pipeline_Stage2(
    input flush,
    input clk, 
    input rst,
    input [4:0] waddr,
    input [31:0] inst_out,
    input [31:0] pc_out,
    input [31:0] pc_incr4_out,
    input [31:0] wr_result, 
    input RegWriteW,
    input stall,
    output reg [31:0] Imm_SE_o,
    output reg [31:0] pc_incr4_out_o,
    output reg [31:0] pc_out_o,
    output reg [4:0] RdD_o,
    output reg [31:0] rdata1_o,
    output reg [31:0] rdata2_o,
    output reg [3:0] ALUControl_o,
    output reg branch_o,
    output reg MemWrite_o,
    output reg [1:0] Result_o,
    output reg ALUSrc_o,
    output reg RegWrite_o,
    output reg [4:0] RS1_E,
    output reg [4:0] RS2_E,
    output reg [1:0] RS_valid_o,
    output reg [1:0] type_o,
    output reg u_o,
    output reg MemRead_o,
    output reg [2:0] branch_type_o,
    output reg [6:0] op_out
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
    //wire for Control Unit
    //input
    wire [6:0] op,funct7; 
    wire [2:0] funct3; 
    assign op = inst_out[6:0];
    assign funct7 = inst_out[31:25];
    assign funct3 = inst_out[14:12];
    //output
    wire [2:0] ImmSrc;
    wire [1:0] RS_valid;
    wire [3:0] ALUControl;
    wire branch,MemWrite,ALUSrc,RegWrite,AUIPC;
    wire [1:0]type,Result;
    wire u;
    wire MemRead;
    wire [2:0] branch_type;
    //Control_Unit
    controller Control_Unit(
                            .Opcode(op),
                            .Funct_7bit(funct7),
                            .Funct_3bit(funct3),
                            .ImmSrc(ImmSrc),
                            .ALUControl(ALUControl),
                            .branch(branch),
                            .MemWrite(MemWrite),
                            .ResultSrc(Result),
                            .ALUSrc(ALUSrc),
                            .RegWrite(RegWrite),
                            .AUIPC(AUIPC),
                            .RS_valid(RS_valid),
                            .type(type),
                            .u(u),
                            .MemRead(MemRead),
                            .branch_type(branch_type)
                            );
    //Wire for Register_File
    //input 
    wire [4:0] raddr1,raddr2,raddr3; 
    wire [31:0] wdata; 
    wire RegWr ; 
    assign raddr1 = inst_out[19:15]; 
    assign raddr2 = inst_out[24:20];
    assign raddr3 = waddr;
    assign wdata = wr_result; 
    assign RegWr = RegWriteW; 
    //output 
    wire [31:0] rdata1,rdata2,rdata1_t; 
    //Register_File 
    Registers Register_File(
                            .raddr1_regf(raddr1),
                            .raddr2_regf(raddr2),
                            .waddr_regf(raddr3),
                            .wdata_regf(wdata),
                            .regf_rdata1(rdata1_t),
                            .regf_rdata2(rdata2),
                            .reg_write(RegWr),
                            .clk(clk),
                            .rst(rst)
                            );
     Mux32bit AUIPC_mux(
                        .A(rdata1_t),
                        .B(pc_out),
                        .sel(AUIPC),
                        .Result(rdata1)
                        );                       
    //wire for Extend
    //input
    wire [31:0] Imm;  
    assign Imm = inst_out[31:0]; 
    //output
    wire [31:0] Imm_SE;                  
    //Extend 
    sign_extend Extend(
                       .Imm(Imm),
                       .ImmSrc(ImmSrc),
                       .SE(Imm_SE)
                       );

    //pipeline 
    wire [4:0] RdD;  
    //Imm_SE,pc_incr4_out,pc_out,RdD,RD1,RD2,6 control signal
    assign RdD = inst_out[11:7];
    always@(posedge clk or negedge rst) begin 
        if(!rst) begin
            Imm_SE_o <= 0; 
            pc_incr4_out_o <= 0; 
            pc_out_o <= 0; 
            RdD_o <= 0; 
            rdata1_o <= 0; 
            rdata2_o <= 0; 
            ALUControl_o <= 0; 
            branch_o <= 0; 
            MemWrite_o <= 0; 
            Result_o <= 0; 
            ALUSrc_o <= 0; 
            RegWrite_o <= 0; 
            RS1_E <= 0;
            RS2_E <= 0;
            RS_valid_o <= 0 ; 
            type_o <= 0;
            u_o <= 0;
        end
        else begin
            Imm_SE_o <= Imm_SE; 
            pc_incr4_out_o <= pc_incr4_out; 
            pc_out_o <=  pc_out; 
            RdD_o <= RdD; 
            rdata1_o <= rdata1; 
            rdata2_o <= rdata2; 
            op_out <= op;
            RS_valid_o <= RS_valid;  
            RS1_E <= inst_out[19:15];
            RS2_E <= inst_out[24:20]; 
            branch_o = branch;
            branch_type_o <= branch_type;
            if (!stall) begin//ex
                ALUSrc_o <= ALUSrc;
                ALUControl_o <= ALUControl;
                if(!flush) begin 
 //ex
                    MemWrite_o <= MemWrite; //m 
                    type_o <= type;
                    u_o <= u;
                    MemRead_o <= MemRead;
                    Result_o <= Result;
                    RegWrite_o <= RegWrite;
               end
               else begin
                    Result_o <= Result; //ex
                    MemWrite_o <= 0; //m //wb
                    type_o <= 0;                   
                    u_o <= 0;
                    if(op == 7'b1100111) begin  
                        RegWrite_o <= RegWrite;   
                    end
                    else
                     RegWrite_o <= 0 ; 
                    MemRead_o <= 0;
                end
            end
            else begin 
                Result_o <= Result;//ex
                branch_o <= 0; //ex
                MemWrite_o <= 0; //m //wb
                ALUSrc_o <= 0; //ex
                type_o <= 0;
                u_o <= 0;    
                RegWrite_o <= 0;   
                MemRead_o <= 0;
                branch_type_o <= 0; 
            end
        end
    end 

endmodule
