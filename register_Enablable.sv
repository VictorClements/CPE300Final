module register_Enablable 
       #(parameter width = 8) // parameter so i dont have to make 70 billion different register modules
        (input  logic             clk, reset, writeEnable, // input clock, reset, and enable signals
         input  logic [width-1:0] writeData, // input of register
         output logic [width-1:0] readData); // output of register
  always_ff @(posedge clk, posedge reset)
    if(reset)               readData <= 0; // if reset, then register will hold 0
    else if(writeEnable)    readData <= writeData; // else if enable is high, then read in value at input of register
endmodule
