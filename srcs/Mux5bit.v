
module Mux5bit(
    input [4:0] A , 
    input [4:0] B , 
    input sel , 
    output [4:0] Result 
    );
    assign Result = (sel == 0) ? A : B ; 
endmodule