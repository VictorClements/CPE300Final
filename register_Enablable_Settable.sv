module register_Enablable_Settable 
       #(parameter width = 8) // parameter so i dont have to make 70 billion different register modules
        (input  logic             clk, set, writeEnable, // input clock, set, and enable signals
         input  logic [width-1:0] writeData, // input of register
         output logic [width-1:0] readData); // output of register
  always_ff @(posedge clk, posedge set)
    if(set)                 readData <= 1; // if set is high, register will hold value of 1
    else if(writeEnable)    readData <= writeData; // else if enable is high, then read in value at input of register
endmodule