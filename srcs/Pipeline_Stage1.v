`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/05/2024 02:28:44 PM
// Design Name: 
// Module Name: Pipeline_Stage1
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

module Pipeline_Stage1(
    input [31:0] fl_pc ,
    input fl_signal , 
    input clk, 
    input rst, 
    input pc_src, 
    input [31:0] pc_jump,
    output [31:0] stall_inst,
    output reg [31:0] inst_out,
    output reg [31:0] pc_out,
    output reg [31:0] pc_incr4_out,
    input stall,
    input flush
    //input [31:0] inst_tb,
    //output [31:0] pc_tb
    );
    //Mux
    wire [31:0] pc_temp0,pc_temp, pc_incr4,inst_ff; 
    wire [31:0] pc_in ; 
    Mux32bit MuxFlush(
                      .A(pc_incr4),
                      .B(fl_pc),
                      .sel(fl_signal),
                      .Result(pc_temp0)
                      );
    Mux32bit MuxPC(.A(pc_temp0),
                    .B(pc_jump),
                    .sel(pc_src),
                    .Result(pc_temp));

    //PC 
    pc ProgramCounter(.clk(clk),
                        .reset(rst),
                        .d(pc_temp),
                        .q(pc_in),
                        .stall(stall));
    //Adder
    Add Add4(.A(pc_in),
                .B(4),
                .sum(pc_incr4));
    //IMem
    instruction_mem IMem(.PC(pc_in), 
                            .Inst(inst_ff));
     //assign pc_tb = pc_in; 
     //assign inst_ff = inst_tb ; 
    //pipeline
     always@(posedge clk or negedge rst or negedge flush) begin 
        if(!flush) begin
            if(!stall) begin 
                if(!rst) begin
                    inst_out <= 0; 
                    pc_incr4_out <= 0; 
                    pc_out <= 0 ; 
                end 
                else begin
                    inst_out <= inst_ff;
                    pc_out <= pc_in; 
                    pc_incr4_out <= pc_incr4; 
                end
           end
       end
    end 
    assign stall_inst = inst_ff ; 
endmodule
