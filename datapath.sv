module datapath(input  logic       clk, reset,
                input  logic       writeEnableAC, writeEnableR, writeEnableMem, //enables for R, AC, and memory
                input  logic       PCEnable, instructionRegisterEnable, MSBaddressEnable, LSBaddressEnable, zeroEnable,//enables for other registers (except Zero)
                input  logic       muxSelectPC, muxSelectZero, muxSelectAddress, muxSelectALUtoAC, muxSelectMEM_or_R_toAC, // mux selectlines
                input  logic [2:0] ALUselectLine);

//internal logic signals
  logic [7:0]  readDataAC, writeDataAC, readDataR, readDataMEM, aluResult;
  logic [15:0] PCplus1, PCin, PCout, addressIn;

//stuff for the PC 
  assign PCplus1 = PCout + 1;
  mux2 #(16) write_to_PC(PCplus1, );
  register_Enablable #(16) pc(clk, reset, PCEnable, PCin, PCout);

//stuff for mainMEM and instruction/address registers
  memory MEM (clk, addressIn, readDataAC, writeEnableMem, readDataMEM);
  register_Enablable #(8) instructionRegister (clk, reset, instructionRegisterEnable, readDataMem, );
  register_Enablable #(8) MSBaddressRegister  (clk, reset, MSBaddressEnable,          );
  register_Enablable #(8) LSBaddressRegister  (clk, reset, LSBaddressEnable,          );

assign fullAddress = {};

//stuff for R, AC, and the ALU
  mux2 #(8) write_to_AC_from_R_or_mem (mem, readDataR, LDAC, );
  mux2 #(8) write_to_AC_from_ALU      ();

  register_Enablable #(8)  accumulator (clk, reset, writeEnableAC, writeDataAC, readDataAC);
  register_Enablable #(8)  generalR    (clk, reset, writeEnableR,  readDataAC,  readDataR);

  alu alu(clk, reset, readDataAC, readDataR, ALUselectLine, aluResult);

  
//stuff for zero register
  register_Enablable #(1)  zeroRegister(clk, reset, zeroEnable,    regIn,       ACisZero); // may have to change the enable to regWrite signal


endmodule

/*
  logic z;
//if (selectLine != 0) then z = (result == 0), otherwise, z = 0
  assign z = (|selectLine) ? ~(|result) : 1'b0;
//assign z = (selectLine != 8'b0) ? (result == 8'b0) : 1'b0;

//zero register will be zero if the result is zero
  always_ff@(posedge clk, posedge reset)
    if(reset)   zero <= 1'b0;
    else        zero <= z; // zero <= (result == 8'b0);
*/
