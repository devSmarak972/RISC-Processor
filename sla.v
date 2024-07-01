`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.10.2023 14:55:12
// Design Name: 
// Module Name: sla
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


  module sla(in1, in2, out);
    input [31:0] in1;
    input [31:0] in2;
    output [31:0] out;
   
    assign out = in2[0]==1?{in1[31], in1[29:0], 1'b0}:in1;
  endmodule
