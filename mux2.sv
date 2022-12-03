module mux2
  #(parameter width = 8) // parameter so i dont have to make 70 billion different 2-to-1 mux modules
   (input  logic [width-1:0] d1, d0, // input signals that the mux is selecting between
    input  logic             s, // select line of mux
    output logic [width-1:0] y); // output of mux

   assign y = s ? d1 : d0; //if(s) then y = d1, else y = d0
endmodule
