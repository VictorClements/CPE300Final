module datapath(input  logic        clk, reset, // input clock and reset signals
                input  logic        writeEnableAC, writeEnableR, writeEnableMem, // enables for R, AC, and memory
                input  logic        PCEnable, instructionRegisterEnable, dataRegisterEnable, MSBaddressEnable, LSBaddressEnable, zeroEnable, // enables for other registers
                input  logic        muxSelectPC, muxSelectAddress, muxSelectALUtoAC, muxSelectMEM_or_R_toAC,  // mux selectlines
                input  logic [15:0] dataAddress, // for testbench, is the data Address we are trying to read from
                output logic [7:0]  dataValue,   // for testbench, is the dataValue from address we read from
                output logic [7:0]  opcode,   // opcode to be sent to the control unit (read from memory)
                output logic        ACisZero);   // value of zero register to be sent to the control unit

// internal logic signals
  logic        ZeroFromAC; // intermediary 1 bit wire to do with the zero register 
  logic [2:0]  ALUselectLine;  // selectline for the ALU operation to choose the correct output
  logic [7:0]  readDataAC, writeDataAC, readDataR, readDataMEM, aluResult, MEM_or_R_toAC; // all intermediary 8 bit busses to do with AC, R, ALU, and MEM
  logic [15:0] PCplus1, PCin, PCout, addressIn, fullAddress; // all intermediary 16 bit busses to do with PC and MEM addresses
  logic [7:0]  dataOut, MSBOut, LSBOut;  //all intermediary 8 bit busses to do with registers connected to MEM


// stuff for the PC 
  assign PCplus1 = PCout + 1;           // "counter" portion of PC
  mux2 #(16) write_to_PC(PCplus1, fullAddress, muxSelectPC, PCin);    // multiplexer for choosing between pc + 1 or the address we are jumping to from jump instructions
  register_Enablable #(16) pc(clk, reset, PCEnable, PCin, PCout); // register module instantiation for PC


// stuff for main MEM and instruction/data/address registers
  mux2 #(16) write_to_address(PCout, fullAddress, muxSelectAddress, addressIn); //multiplexer for choosing between the fullAddress read in from memory, or the current value of PC
  memory MEM (clk, addressIn, readDataAC, writeEnableMem, dataAddress, dataValue, readDataMEM); //instantiation of module to hold instruction and data memory
  register_Enablable #(8) instructionRegister (clk, reset, instructionRegisterEnable, readDataMEM, opcode); // instruction register that reads in from MEM and holds opcode of current instruction
  register_Enablable #(8) dataRegister        (clk, reset, dataRegisterEnable,        readDataMEM, dataOut); // data register that reads in from MEM when the LDAC instruction is used
  
  register_Enablable #(8) MSBaddressRegister  (clk, reset, MSBaddressEnable,          readDataMEM, MSBOut); // MSB address register that reads in from MEM when a Gamma instruction is used
  register_Enablable #(8) LSBaddressRegister  (clk, reset, LSBaddressEnable,          readDataMEM, LSBOut); // LSB address register that reads in from MEM when a Gamma instruction is used
  assign fullAddress = {MSBOut, LSBOut}; // the full address is the concatination of the MSB and LSB register outputs


// stuff for R, AC, and the ALU         
  mux2 #(8) write_to_AC_from_R_or_mem (readDataR,     dataOut,       muxSelectMEM_or_R_toAC, MEM_or_R_toAC); // mux for selecting between memory and R register to go to the Accumulator input
  mux2 #(8) write_to_AC_from_ALU      (aluResult,     MEM_or_R_toAC, muxSelectALUtoAC,       writeDataAC); // mux for selecting between ALU and output of previous mux to go to the Accumulator input

  register_Enablable #(8)  accumulator (clk, reset, writeEnableAC, writeDataAC, readDataAC); // accumulator register instantiaion
  register_Enablable #(8)  generalR    (clk, reset, writeEnableR,  readDataAC,  readDataR); // R register instantiaion

  assign ALUselectLine = opcode[2:0]; // the ALU select line is just the lower 3 bits of the opcode (simplest way to get the selectline)
  alu alu(clk, readDataAC, readDataR, ALUselectLine, aluResult); // ALU instantiation

  
// stuff for zero register
  assign ZeroFromAC  = ~(|writeDataAC); // ZeroFromAC = (writeDataAC == 0) // assigns the signal which is the input to the zero register (NOR of all the writeDataAC bits)
  register_Enablable_Settable #(1)  zeroRegister(clk, reset, zeroEnable, ZeroFromAC, ACisZero); // Zero register that stores whether or not the Accumulator holds a value of zero

endmodule
