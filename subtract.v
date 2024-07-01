`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.10.2023 14:52:44
// Design Name: 
// Module Name: subtract
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


module subtract(
    inp1, inp2, diff
    );
  input [31:0] inp1;
  input [31:0] inp2;
  output [31:0] diff;
   
  wire [31:0] bout;
   
    not_gate inv(inp2, bout);
    adder addition(inp1, bout, 1'b1, diff);    
endmodule


module and_gate(
    in1, in2, res
    );
  input [31:0] in1;
  input [31:0] in2;
  output [31:0] res;
 
    assign res = in1&in2;
endmodule