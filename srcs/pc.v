`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/27/2024 12:12:43 AM
// Design Name: 
// Module Name: pc
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

module pc(
    input clk,
    input reset,
    input [31:0] d,
    output [31:0] q,
    input stall
     );
     reg [31:0] q_reg;
    initial begin 
        q_reg <= 32'b0 ; 
    end
     always@(posedge clk or negedge reset or posedge stall) begin
        if(stall) begin 
            q_reg <= q_reg;
            end
        else begin
            if(!reset)
                q_reg <= 32'b0;
            else
                q_reg <= d;
       end
    end
    assign q = q_reg;
endmodule