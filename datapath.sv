module datapath(input  logic       clk, reset,
                input  logic       writeEnableAC, writeEnableR, writeEnableMem, // enables for R, AC, and memory
                input  logic       PCEnable, instructionRegisterEnable, dataRegisterEnable, MSBaddressEnable, LSBaddressEnable, zeroEnable, // enables for other registers
                input  logic       muxSelectPC, muxSelectZero, muxSelectAddress, muxSelectALUtoAC, muxSelectMEM_or_R_toAC,  // mux selectlines
                output logic [7:0] instructionOut   // opcode to be sent to the control unit (read from memory)
                output logic       ACisZero);   // value of zero register to be sent to the control unit

//internal logic signals
  logic        ZeroFromAC, ZeroFromALU, ZeroIntoRegister; // all intermediary 1 bit wires to do with the zero regiter 
  logic [2:0]  ALUselectLine;  // selectline for the ALU operation to choose the correct output
  logic [7:0]  readDataAC, writeDataAC, readDataR, readDataMEM, aluResult, MEM_or_R_toAC; // all intermediary 8 bit busses to do with AC, R, ALU, and MEM
  logic [15:0] PCplus1, PCin, PCout, addressIn, fullAddress; // all intermediary 16 bit busses to do with PC and MEM addresses
  logic [7:0]  dataOut, MSBOut, LSBOut;  //all intermediary 8 bit busses to do with registers connected to MEM


//stuff for the PC 
  assign PCplus1 = PCout + 1;           // "counter" portion of PC
  mux2 #(16) write_to_PC(PCplus1, fullAddress, muxSelectPC, PCin);    // multiplexer for choosing between pc + 1 or the address we are jumping to from jump instructions
  register_Enablable #(16) pc(clk, reset, PCEnable, PCin, PCout); // register module instantiation for PC


//stuff for main MEM and instruction/data/address registers
  mux2 #(16) write_to_address(PCout, fullAddress, muxSelectAddress, addressIn); //multiplexer for choosing between the fullAddress read in from memory, or the current value of PC
  memory MEM (clk, addressIn, readDataAC, writeEnableMem, readDataMEM); //instantiation of module to hold instruction and data memory
  register_Enablable #(8) instructionRegister (clk, reset, instructionRegisterEnable, readDataMEM, instructionOut); // instruction register that reads in from MEM and holds opcode of current instruction
  register_Enablable #(8) dataRegister        (clk, reset, dataRegisterEnable,        readDataMEM, dataOut);
  
  register_Enablable #(8) MSBaddressRegister  (clk, reset, MSBaddressEnable,          readDataMEM, MSBOut);
  register_Enablable #(8) LSBaddressRegister  (clk, reset, LSBaddressEnable,          readDataMEM, LSBOut);
  assign fullAddress = {MSBOut, LSBOut};


//stuff for R, AC, and the ALU         
  mux2 #(8) write_to_AC_from_R_or_mem (readDataR,     dataOut,       muxSelectMEM_or_R_toAC, MEM_or_R_toAC);
  mux2 #(8) write_to_AC_from_ALU      (aluResult,     MEM_or_R_toAC, muxSelectALUtoAC,       writeDataAC);

  register_Enablable #(8)  accumulator (clk, reset, writeEnableAC, writeDataAC, readDataAC);
  register_Enablable #(8)  generalR    (clk, reset, writeEnableR,  readDataAC,  readDataR);

  assign ALUselectLine = instructionOut[2:0];
  alu alu(clk, reset, readDataAC, readDataR, ALUselectLine, aluResult);

  
//stuff for zero register // change to ~(|readDataAC) if we decide that the reading of zero bit is from wrong location
  assign ZeroFromAC  = ~(|writeDataAC); // ZeroFromAC = (writeDataAC == 0)
  assign ZeroFromALU = ~(|aluResult);   // ZeroFromAC = (aluResult == 0)

  mux2 #(1) write_to_Zero_Register (ZeroFromALU, ZeroFromAC, muxSelectZero, ZeroIntoRegister);
  register_Enablable #(1)  zeroRegister(clk, reset, zeroEnable, ZeroIntoRegister, ACisZero); 

endmodule
