module memory(input  logic        clk, // input clock signal
              input  logic [15:0] address, // input address which is to be accessed
              input  logic [7:0]  writeData, // data to be written to memory
              input  logic        writeEnable, // enable for writing to memory
              input  logic [15:0] dataAddress, // for testbench, is the data Address we are trying to read from
              output logic [7:0]  dataValue,   // for testbench, is the dataValue from address we read from
              output logic [7:0]  readData); // data being read from the current address of memory

  logic [7:0] MEM [31:0]; //should be [65535:0], but is smaller for testing purposes
  initial begin
    $readmemh("memory.txt", MEM); //initialize the memory to some arbitrary instruction and data from a text file
  end

  assign dataValue = MEM[dataAddress]; // assigning the testbench value

  assign readData = MEM[address[4:0]]; // assigning which data is currently being read based of the provided address
  // note that only the lower 5 bits are provided for the sake of testing purposes, the full system would have all 16 bits

  always_ff@(posedge clk)
    if(writeEnable)    MEM[address[4:0]] <= writeData; // registered input that writes the passed value to the current address if the enable is on

endmodule
