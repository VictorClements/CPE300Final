module instructionDecoder(input  logic [7:0]  opcode, // opcode from Instruction Register
                          output logic [15:0] decoded); // 16 bits of Decoded signals for showing which instruction has been provided

  logic en; // "enable" signal
  // NOR of upper 4 bits to see if they are zero
  assign en = ~(|opcode[7:4]);   // en = (opcode[7:4] == 4'b0);

  always_comb
    casez({en, opcode[3:0]})
      5'b0????: decoded = 16'b0000_0000_0000_0001; // same as NOP

      5'b10000: decoded = 16'b0000_0000_0000_0001; // NOP  is high
      5'b10001: decoded = 16'b0000_0000_0000_0010; // LDAC is high
      5'b10010: decoded = 16'b0000_0000_0000_0100; // STAC is high
      5'b10011: decoded = 16'b0000_0000_0000_1000; // MVAC is high

      5'b10100: decoded = 16'b0000_0000_0001_0000; // MOVR is high
      5'b10101: decoded = 16'b0000_0000_0010_0000; // JUMP is high
      5'b10110: decoded = 16'b0000_0000_0100_0000; // JMPZ is high
      5'b10111: decoded = 16'b0000_0000_1000_0000; // JPNZ is high

      5'b11000: decoded = 16'b0000_0001_0000_0000; // ADD  is high
      5'b11001: decoded = 16'b0000_0010_0000_0000; // SUB  is high
      5'b11010: decoded = 16'b0000_0100_0000_0000; // INAC is high
      5'b11011: decoded = 16'b0000_1000_0000_0000; // CLAC is high

      5'b11100: decoded = 16'b0001_0000_0000_0000; // AND  is high
      5'b11101: decoded = 16'b0010_0000_0000_0000; // OR   is high
      5'b11110: decoded = 16'b0100_0000_0000_0000; // XOR  is high
      5'b11111: decoded = 16'b1000_0000_0000_0000; // NOT  is high

      default:  decoded = 16'b0000_0000_0000_0001; //same as NOP
    endcase

endmodule
