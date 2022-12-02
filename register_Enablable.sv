module register_Enablable 
       #(parameter width = 8)
        (input  logic             clk, reset, writeEnable,
         input  logic [width-1:0] writeData,
         output logic [width-1:0] readData);
  always_ff @(posedge clk, posedge reset)
    if(reset)               readData <= 0;
    else if(writeEnable)    readData <= writeData;
    //no need for an else here, but I could put else readData <= readData;
endmodule
