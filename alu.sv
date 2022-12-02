module alu(input  logic       clk, reset,
           input  logic [7:0] AC, R,
           input  logic [2:0] selectLine,
           output logic [7:0] result);
//select which operation ALU should do based on the select line (this will come from control unit)
  always_comb
    case(selectLine)
      3'b000:  result =  AC + R;
      3'b001:  result =  AC - R;
      3'b010:  result =  AC + 1;
      3'b011:  result =  8'b0;
      3'b100:  result =  AC & R;
      3'b101:  result =  AC | R;
      3'b110:  result =  AC ^ R;
      3'b111:  result = ~AC; 
      default: result =  AC;     //unsure what to put here, will be just pass through
    endcase

endmodule
