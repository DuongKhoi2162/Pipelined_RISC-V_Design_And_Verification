`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/10/2024 02:02:06 PM
// Design Name: 
// Module Name: riscv_test_top
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
`include "Packet.sv"
parameter R_OP =  7'b0110011;
parameter I_OP = 7'b0010011 ; 
parameter I_LOAD_OP =  7'b0000011 ;
parameter STORE_OP =  7'b0100011;
parameter BRANCH_OP =  7'b1100011;  
parameter AUIPC_OP = 7'b0010111; 
parameter JAL_OP = 7'b1101111; 
parameter LUI_OP = 7'b0110111; 
parameter JALR_OP = 7'b1100111;
module riscv_test_top;
    parameter simulation_cycle = 100;
    bit SystemClock;
    riscv_io top_io (SystemClock);
    test t(top_io);
    Pipeline_RISCV dut (.rst(top_io.reset_n),
                        .clk(top_io.clock));
                        //.data(top_io.data));
//pc_tb(top_io.addr));
    initial begin
        SystemClock = 0;
        forever begin #(simulation_cycle/2) SystemClock = !SystemClock;        
        end 
    end
endmodule

program automatic test(riscv_io.TB cpu_io);
logic [3:0] n;
logic [31:0] inst_arr [16];
logic [7:0] inst [16*4];
Packet pkt2send;
integer i,j;
initial begin 
    reset();
    gen();
    driver2();
    #100000;

end
task reset();
    cpu_io.reset_n <= 0;
    @cpu_io.cb;
    cpu_io.reset_n <= 1; 
endtask
task gen();   
    n = 12;
    i = 0;
    //Lui x2,0xA
        pkt2send = new();
        pkt2send.randomize() with{
            opcode == LUI_OP;
            rd == 2;
            imm_1 == 20'hB;
            };
        pkt2send.gen();
        pkt2send.display("Instruction:");
        inst_arr[0]=pkt2send.inst;
    //ADDI x2,x2, 0xAA0
        pkt2send = new();
        pkt2send.randomize() with{
            opcode == I_OP;
            funct3 ==0;
            rd == 2;
            rs1 == 2;
            imm_0 == 12'hAA0;
            };
        pkt2send.gen();
        pkt2send.display("Instruction:");
        inst_arr[1]=pkt2send.inst;
    //LUI x4, 0xAAAA0    
        pkt2send = new();
        pkt2send.randomize() with{
            opcode == LUI_OP;
            rd == 4;
            imm_1 == 20'hAAAA0;
            };
        pkt2send.gen();
        pkt2send.display("Instruction:");
        inst_arr[2]=pkt2send.inst;
   //LUI x3,0x0
        pkt2send = new();
        pkt2send.randomize() with{
            opcode == LUI_OP;
            rd == 3;
            imm_1 == 0;
            };
        pkt2send.gen();
        pkt2send.display("Instruction:");
        inst_arr[3]=pkt2send.inst;
   //ORI x3,x3, 0x10
        pkt2send = new();
        pkt2send.randomize() with{
            opcode == I_OP;
            rd == 3;
            funct3 == 6;
            rs1 == 3;
            imm_0 == 12'h10;
            };
        pkt2send.gen();
        pkt2send.display("Instruction:");
        inst_arr[4]=pkt2send.inst;
  //ADDI x3,x3,0x4
        pkt2send = new();
        pkt2send.randomize() with{
            opcode == I_OP;
            rd == 3;
            funct3 ==0;
            rs1 == 3;
            imm_0 == 12'h004;
            };
        pkt2send.gen();
        pkt2send.display("Instruction:");
        inst_arr[5]=pkt2send.inst;
  //ADDI x2,x2,0x1
        pkt2send = new();
        pkt2send.randomize() with{
            opcode == I_OP;
            rd == 2;
            rs1 == 2;
            funct3 ==0;
            imm_0 == 12'h001;
            };
        pkt2send.gen();
        pkt2send.display("Instruction:");
        inst_arr[6]=pkt2send.inst;
  //SW x0, 0(x3)
        pkt2send = new();
        pkt2send.randomize() with{
            opcode == STORE_OP;
            rs2 == 0;
            rs1 == 3;
            funct3 == 2;
            imm_0 == 0;
            };
        pkt2send.gen();
        pkt2send.display("Instruction:");
        inst_arr[7]=pkt2send.inst;
    //SH x2,2(x3)
        pkt2send = new();
        pkt2send.randomize() with{
            opcode == STORE_OP;
            rs2 == 2;
            rs1 == 3;
            funct3 ==1;
            imm_0 == 2;
            };
        pkt2send.gen();
        pkt2send.display("Instruction:");
        inst_arr[8]=pkt2send.inst;
    //LW x1,0(x3)
        pkt2send = new();
        pkt2send.randomize() with{
            opcode == I_LOAD_OP;
            rd == 1;
            rs1 == 3;
            funct3 == 2;
            imm_0 == 0;
            };
        pkt2send.gen();
        pkt2send.display("Instruction:");
        inst_arr[9]=pkt2send.inst;
    //BNE x1,x4,loop 20
        pkt2send = new();
        pkt2send.randomize() with{
            opcode == BRANCH_OP;
            rs1 == 1;
            rs2 == 4;
            funct3 == 1;
            imm_0 == 13'h1FEC;
            };
        pkt2send.gen();
        pkt2send.display("Instruction:");
        inst_arr[10]=pkt2send.inst;
    //done: JAL x4,done
        pkt2send = new();
        pkt2send.randomize() with{
            opcode == JAL_OP;
            rd == 4;
            imm_1 == 8'h00;
            };
        pkt2send.gen();
        pkt2send.display("Instruction:");
        inst_arr[11]=pkt2send.inst;
    for (i=n;i<16;i=i+1) begin
        inst_arr[i] = 32'h00000000;
    end    
endtask
task driver2();
    j = 0;
    for (i=0;i<16;i=i+1) begin
        inst[j] = inst_arr[i][31:24];
        inst[j+1] = inst_arr[i][23:16];
        inst[j+2] = inst_arr[i][15:8];
        inst[j+3] = inst_arr[i][7:0];
        j = j + 4;
    end 
    $writememb("instruction.txt",inst);
    $readmemb("instruction.txt",dut.IF.IMem.ROM);
endtask: driver2
task driver();
    i = 0;
    repeat(30) begin
    @(cpu_io.addr) begin
    case(cpu_io.addr)
    32'h00000000: cpu_io.cb.data <= inst_arr[0]; 
    32'h00000004: cpu_io.cb.data <= inst_arr[1]; 
    32'h00000008: cpu_io.cb.data <= inst_arr[2]; 
    32'h0000000c: cpu_io.cb.data <= inst_arr[3]; 
    32'h00000010: cpu_io.cb.data <= inst_arr[4]; 
    32'h00000014: cpu_io.cb.data <= inst_arr[5]; 
    32'h00000018: cpu_io.cb.data <= inst_arr[6]; 
    32'h0000001c: cpu_io.cb.data <= inst_arr[7]; 
    32'h00000020: cpu_io.cb.data <= inst_arr[8]; 
    32'h00000024: cpu_io.cb.data <= inst_arr[9]; 
    32'h00000028: cpu_io.cb.data <= inst_arr[10]; 
    32'h0000002c: cpu_io.cb.data <= inst_arr[11]; 
    32'h00000030: cpu_io.cb.data <= inst_arr[12]; 
    32'h00000034: cpu_io.cb.data <= inst_arr[13]; 
    32'h00000038: cpu_io.cb.data <= inst_arr[14]; 
    32'h0000003c: cpu_io.cb.data <= inst_arr[15]; 
    default: cpu_io.cb.data <= 32'h00000000; 
    endcase
    end
    end
endtask
endprogram:test

