module mux2
  #(parameter width = 8)
   (input  logic [width-1:0] d1, d0, 
    input  logic             s,
    output logic [width-1:0] y);

   assign y = s ? d1 : d0; 
endmodule
