module Processor (
    clk
);
  input clk;

  reg [ 2:0] state;
  reg [15:0] imm1;
  reg [20:0] imm2;
  reg [25:0] imm3;

  reg [6:0] pc, npc;
  wire [31:0] ir;
  reg  [ 4:0] mar;
  reg  [31:0] datain;
  wire [31:0] dataout;
  reg signed [31:0] A, B;
  wire [31:0] alu_out;
  reg  [31:0] wVal;
  wire [31:0] rVal1, rVal2;
  reg [4:0] wReg, rReg1, rReg2;
  reg [4:0] sp;
  reg[31:0] stackin;
  wire [31:0] stackout;


  wire sigwr, sigon;
  reg ifsig;
  wire [1:0] alusc, wrreg, res;
  wire [2:0] br, st;
  wire [3:0] alu_op;
  reg regwr;
  reg memwr, memon, cond;
  reg stackwr, stackon;

  initial begin
    pc = 0;
    state = 0;
  end

  InsMem ins (
      pc,
      0,
      ir,
      0,
      ifsig,
      clk
  );
  ControlUnit cu (
      ir,
      alu_op,
      alusc,
      wrreg,
      sigwr,
      sigon,
      res,
      br,
      st,
      clk
  );
  Memory data (
      mar,
      datain,
      dataout,
      memwr,
      memon,
      clk
  );
  Memory stack (
      sp,
      stackin,
      stackout,
      stackwr,
      stackon,
      clk
  );
  ALU alu (
      A,
      B,
      alu_out,
      alu_op,
      clk
  );
  RegisterBank regb (
      wVal,
      wReg,
      rReg1,
      rReg2,
      regwr,
      rVal1,
      rVal2,
      clk
  );

  always @(posedge clk) begin
    $display(
        "state: %d, pc: %d, ir: %b, A: %d, B: %d, datain: %d, dataout: %d, alusc: %d, wrreg: %d, wReg: %d, alu_out: %d, wVal: %d",
        state, pc, ir, A, B, datain, dataout, alusc, wrreg, wReg, alu_out, wVal);
    if (pc == 9) begin
      state <= 1;
      $finish;
    end
    case (state)
      0: begin  //IF Stage
        state <= 1;
        ifsig <= 1;
        npc = pc + 1;
      end
      1: begin  //ID state
        state <= 2;
        ifsig <= 0;
        rReg1 <= ir[25:21];
        rReg2 <= ir[20:16];
        imm1  <= ir[15:0];
        imm2  <= ir[20:0];
        imm3  <= ir[25:0];
      end
      2: begin  //EX Stage
        state <= 3;
        if (br == 0) A <= rVal1;
        else A <= pc;

        if (alusc == 1) B <= {imm1[15] == 1 ? 16'b1111111111111111 : 16'b0000000000000000, imm1};
        else if (alusc == 2) B <= {imm2[20] == 1 ? 11'b11111111111 : 11'b00000000000, imm2};
        else if (alusc == 3) B <= {imm3[25] == 1 ? 6'b111111 : 6'b000000, imm3};
        else B <= rVal2;

        if (br == 1) cond <= 1;
        else if (br == 2) cond <= (rVal1 > 0);
        else if (br == 3) cond <= (rVal1 > 0);
        else if (br == 4) cond <= (rVal1 == 0);
        else cond <= 0;
      end
      3: begin  //MEM Stage
        state <= 4;
        if (cond) pc <= alu_out;
        else pc <= npc;

        if (sigon == 1) mar <= alu_out;
        if (sigwr == 1) datain <= rVal2;
        memwr <= sigwr;
        memon <= sigon;

        if(st==1) begin
          sp <= alu_out;
          stackin <= rVal2;
        end
        else if(st==2)  begin

        end

      end
      4: begin  //WB Stage
        state <= 0;
        if (wrreg == 1) wReg <= ir[15:11];
        else if (wrreg == 2) wReg <= ir[20:16];
        else if (wrreg == 3) wReg <= ir[25:21];

        if (res == 1) wVal <= rVal1;
        else if (res == 2) wVal <= alu_out;
        else if (res == 3) wVal <= dataout;
        memwr <= 0;
        memon <= 0;
        regwr <= 1;
        #20 regwr <= 0;
        $display("\n");
      end
    endcase
  end
endmodule