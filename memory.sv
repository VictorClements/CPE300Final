module memory();
//for a combined instruction and data memory, we need a few things:
/*
for the Instruction memory:
    - need a read port

for the Data memory:
    - need a read  port
    - need a read  enable
    - need a write port
    - need a write enable
*/

logic [7:0] MEM [63:0] //should be [65535:0], but is smaller for testing purposes

endmodule