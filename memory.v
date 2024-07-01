module Memory (
    addr,
    datain,
    dataout,
    sigwr,
    sigon,
    clk
);
  input [4:0] addr;
  input [31:0] datain;
  output reg [31:0] dataout;
  input sigwr;
  input sigon;
  input clk;

  reg [31:0] mem[31:0];

  integer i;

  initial begin
    for (i = 0; i < 32; i = i + 1) begin
      mem[i] = 32'b0;
    end
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