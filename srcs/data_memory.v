`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/26/2024 11:26:58 PM
// Design Name: 
// Module Name: data_memory
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


module data_memory(
    input clk , 
    input rst,
    input [31:0] Address ,
    input [31:0] WriteData , 
    input WriteEn,
    input [1:0] type,
    input u,
    output [31:0] ReadData 
    );
    reg [7:0] RAM [0:1023*4];
    integer i ;
    parameter byte_type = 2'b00, half_word_type = 2'b01, word_type = 2'b10; 
    initial begin 
        for(i = 0 ; i < 1024*4 ; i = i + 1 ) begin 
            RAM[i] = 32'b0 ; 
        end 
    end 

    always @ (posedge clk)
    begin
        if(WriteEn)
            if(type == byte_type) begin 
                RAM[Address] <= WriteData;
            end 
            else if(type == half_word_type) begin
                RAM[Address] <= WriteData[7:0];
                RAM[Address+1] <= WriteData[15:8];               
            end 
            else if(type == word_type) begin
                RAM[Address] <= WriteData[7:0];
                RAM[Address+1] <= WriteData[15:8];
                RAM[Address+2] <= WriteData[23:16];
                RAM[Address+3] <= WriteData[31:24];
            end 
    end
    assign ReadData = (!rst)? 32'd0:
                      (type == byte_type & u)? {24'b0,RAM[Address]} :
                      (type == byte_type & !u)? {{24{RAM[Address][7]}},RAM[Address]}:
                      (type == half_word_type & u)? {16'b0,RAM[Address+1],RAM[Address]} :
                      (type == half_word_type & !u)? {{16{RAM[Address+1][7]}},RAM[Address+1],RAM[Address]}:
                      {RAM[Address+3],RAM[Address+2],RAM[Address+1],RAM[Address]} ; 
                      

endmodule
