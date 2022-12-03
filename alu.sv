module alu(input  logic       clk, // input clock signal
           input  logic [7:0] AC, R, // values of the accumulator and the R registers
           input  logic [2:0] selectLine, // the selectLine from opcode to determine which operation to do
           output logic [7:0] result); // output result of the ALU operation
           
// select which operation ALU should do based on the select line
// (the selectLine comes directly from opcode, because its the simplest)
  always_comb
    case(selectLine)
      3'b000:  result =  AC + R; // ADD
      3'b001:  result =  AC - R; // SUB
      3'b010:  result =  AC + 1; // INAC
      3'b011:  result =  8'b0;   // CLAC
      3'b100:  result =  AC & R; // AND
      3'b101:  result =  AC | R; // OR
      3'b110:  result =  AC ^ R; // XOR
      3'b111:  result = ~AC;     // NOT
      default: result =  AC; //wont matter what this default is, (since all cases are covered), so I will make it a pass through
    endcase
endmodule
