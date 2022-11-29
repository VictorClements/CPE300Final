module register 
       #(parameter width = 8)
        (input  logic clk, reset,
         input  logic [width-1:0] Rin,
         output logic [width-1:0] Rout);
  always_ff @(posedge clk, posedge reset)
    if(reset)   Rout <= 0;
    else        Rout <= Rin;
endmodule