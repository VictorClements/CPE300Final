module smg(input  logic        clk, reset,  // clock and reset input signals
           input  logic [15:0] dataAddress, // for testbench, holds a specific data address
           output logic [7:0]  dataValue,   // for testbench, returns the data held and the specific address specified above
           output logic [7:0]  opcode);     // opcode signal to be read into IR inside the Datapath then given to the Control Unit

// control signals from Control unit (outputs of CU) to Datapath (inputs of DP)
  logic writeEnableAC, writeEnableR, writeEnableMem;
  logic PCEnable, instructionRegisterEnable, /*dataRegisterEnable,*/ MSBaddressEnable, LSBaddressEnable, zeroEnable; 
  logic muxSelectPC, muxSelectAddress, muxSelectALUtoAC, muxSelectMEM_or_R_toAC;

// Zero register value that is output of Datapath and input of Control Unit
  logic ACisZero;

  datapath    DP(clk, reset, //clock and reset input signals
                 writeEnableAC, writeEnableR, writeEnableMem, // enables for AC, R and MEM
                 PCEnable, instructionRegisterEnable, /*dataRegisterEnable,*/ // enables for PC, IR, and DR
                 MSBaddressEnable, LSBaddressEnable, zeroEnable, // enables for MA, LA, and Z
                 muxSelectPC, muxSelectAddress, muxSelectALUtoAC, muxSelectMEM_or_R_toAC, // select lines for muxes
                 dataAddress, dataValue, // for testbench, to find value stored at specific address
                 opcode, ACisZero); // opcode from Instruction Register (IR) and value of Zero register (Z) outputs

  controlUnit CU(clk, reset, //clock and reset input signals
                 ACisZero, opcode, // zero register and opcode input signals from the Datapath
                 writeEnableAC, writeEnableR, writeEnableMem, // enables for AC, R and MEM
                 PCEnable, instructionRegisterEnable, /*dataRegisterEnable,*/ // enables for PC, IR, and DR
                 MSBaddressEnable, LSBaddressEnable, zeroEnable, // enables for MA, LA, and Z
                 muxSelectPC, muxSelectAddress, muxSelectALUtoAC, muxSelectMEM_or_R_toAC); // select lines for muxes

endmodule
