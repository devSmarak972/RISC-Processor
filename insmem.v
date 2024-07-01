module InsMem (
    addr,
    datain,
    dataout,
    sigwr,
    sigon,
    clk
);
  input [6:0] addr;
  input [31:0] datain;
  output reg [31:0] dataout;
  input sigwr;
  input sigon;
  input clk;

  reg [31:0] mem[127:0];

  initial begin
    mem[0] <= 32'b01100100010000000000000000000010;  //BZ R2, 2
    mem[1] <= 32'b00000100001000000000000000000011;  //ADDI R1, 3
    mem[2] <= 32'b00000100010000000000000000000110;  //ADDI R2, 6
    mem[3] <= 32'b00000000001000100001100000000000;  //ADD R3, R1, R2
    mem[4] <= 32'b01001100011000111111111111111010;  //ST R3, -6(R3)
    mem[5] <= 32'b01001000010001001111111111111010;  //LD R4, -6(R2)
    mem[6] <= 32'b00001100100000000000000000000100;  //SUBI R4, 4
    mem[7] <= 32'b01111000100001010000000000000000;  //MOVE R5, R4
    mem[8] <= 32'b00000000101000100010100000000000;  //ADD R5, R5, R2
  end

  always @(posedge clk) begin
    if (sigon) begin
      if (sigwr) begin
        mem[addr] = datain;
        dataout   = datain;
      end else begin
        dataout = mem[addr];
      end
    end
  end
endmodule