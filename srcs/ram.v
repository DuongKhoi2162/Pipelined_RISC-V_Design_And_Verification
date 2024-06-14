//================================================
//  University  : UIT - www.uit.edu.vn
//  Course name : System-on-Chip Design
//  Lab name    : lab3
//  File name   : ram.v
//  Author      : Pham Thanh Hung
//  Date        : Oct 21, 2017
//  Version     : 1.0
//-------------------------------------------------
// Modification History
//
//================================================

module ram(
//input
wdata,
we,
re,
waddr,
raddr,
//output
rdata
);

//input
input [31:0] wdata;
input we;
input re;
input [31:0] waddr;
input [31:0] raddr;
//output
output [31:0] rdata;

reg [31:0] rdata;
reg [31:0] mem [0:2045];

always @(*) begin
    if(re) rdata = mem[raddr];
end
always @(*) begin
    if(we) mem[waddr] = wdata;
end

endmodule

