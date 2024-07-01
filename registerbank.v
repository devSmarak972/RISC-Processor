module RegisterBank (
    wVal,
    wReg,
    rReg1,
    rReg2,
    sig,
    rVal1,
    rVal2,
    clk
);
  input [31:0] wVal;  //value to be written
  input [4:0] wReg;  //register to write to
  input [4:0] rReg1;  //register to read
  input [4:0] rReg2;  //register to read
  input sig;  //write if sig is 1
  output [31:0] rVal1;  //read value
  output [31:0] rVal2;  //read value
  input clk;

  reg [31:0] regBank[31:0];

  integer i;
  initial begin
    for (i = 0; i < 32; i = i + 1) begin
      regBank[i] <= 0;
    end
  end

  assign rVal1 = regBank[rReg1];
  assign rVal2 = regBank[rReg2];

  always @(sig or wVal) begin
    //     $display(" rval1: %d,rval2: %d,  wval: %d,  wReg: %d,  sig: %d, reg1 %d,reg2 %d,reg3 %d",
    //              rVal1, rVal2, wVal, wReg, sig, regBank[1], regBank[2], regBank[3]);

    if (sig == 1) begin
      regBank[wReg] = wVal;
    end
  end
endmodule