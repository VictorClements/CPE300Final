module memory(input  logic        clk,
              input  logic [15:0] address,
              input  logic [7:0]  writeData,
              input  logic        writeEnable,
              output logic [7:0]  readData);
//for a combined instruction and data memory, we need a few things:
/*
    - need a read  port
    - need a read  enable??? do we tho
    - need a write port
    - need a write enable
*/

// for the combined instruction and data mem, we should assume that
//our instructions will be stored in the first 16 values?
//and any data will be stored in the last 16 values?

  logic [7:0] MEM [31:0] //should be [65535:0], but is smaller for testing purposes
  $readmemh("memory.txt", MEM);

  assign readData = MEM[address[4:0]];

  always_ff@(posedge clk)
    if(writeEnable)    MEM[address[4:0]] <= writeData;

endmodule
