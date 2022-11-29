module instructionDecoder(input  logic [7:0]  instr,
                          output logic [15:0] decoded);
                          //lsb is INOP, msb is INOT

  logic en; //enable signal
  // NOR of upper 4 bits to see if they are zero
  assign en = ~(|instr[7:4]);   // en = (instr[7:4] == 4'b0);

  always_comb
    casez({en, instr[3:0]})
      5'b0????: decoded = 16'b0;

      5'b10000: decoded = 16'b0000_0000_0000_0001;
      5'b10001: decoded = 16'b0000_0000_0000_0010;
      5'b10010: decoded = 16'b0000_0000_0000_0100;
      5'b10011: decoded = 16'b0000_0000_0000_1000;

      5'b10100: decoded = 16'b0000_0000_0001_0000;
      5'b10101: decoded = 16'b0000_0000_0010_0000;
      5'b10110: decoded = 16'b0000_0000_0100_0000;
      5'b10111: decoded = 16'b0000_0000_1000_0000;

      5'b11000: decoded = 16'b0000_0001_0000_0000;
      5'b11001: decoded = 16'b0000_0010_0000_0000;
      5'b11010: decoded = 16'b0000_0100_0000_0000;
      5'b11011: decoded = 16'b0000_1000_0000_0000;

      5'b11100: decoded = 16'b0001_0000_0000_0000;
      5'b11101: decoded = 16'b0010_0000_0000_0000;
      5'b11110: decoded = 16'b0100_0000_0000_0000;
      5'b11111: decoded = 16'b1000_0000_0000_0000;

      default:  decoded = 16'b0;
    endcase

endmodule

/*
output logic       INOP, ILDAC, ISTAC, IMVAC,
output logic       IMOVR, IJUMP, IJMPZ, IJPNZ,
output logic       IADD, ISUB, IINAC, ICLAC,
output logic       IAND, IOR, IXOR, INOT
*/