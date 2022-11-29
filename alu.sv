module alu(input  logic       clk, reset,
           input  logic [7:0] AC, R,
           input  logic [7:0] selectLine,
           output logic [7:0] result
           output logic       zero);

  logic z;
//if (selectLine != 0) then z = (result == 0)
//otherwise, z = 0
  assign z = (|selectLine) ? ~(|result) : 1'b0;
//assign z = (selectLine != 8'b0) ? (result == 8'b0) : 1'b0;

//based on the selectLine, we assign the result
//this is the "ALU" part of this alu module
  always_comb
    case(selectLine)
      8'h01:    result =  AC + R;
      8'h02:    result =  AC - R;
      8'h04:    result =  AC + 1;
      8'h08:    result =  8'b0;
      8'h10:    result =  AC & R;
      8'h20:    result =  AC | R;
      8'h40:    result =  AC ^ R;
      8'h80:    result = ~AC; 
      default:  result =  AC;     //unsure what to put here, will be just pass through
    endcase

//zero register will be zero if the result is zero
  always_ff@(posedge clk, posedge reset)
    if(reset)   zero <= 1'b0;
    else        zero <= z; // zero <= (result == 8'b0);

endmodule