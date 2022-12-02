module controlUnit(input  logic       clk, reset, z,
                   input  logic [7:0] Opcode,
                   output  logic      writeEnableAC, writeEnableR, writeEnableMem, // enables for R, AC, and memory
                   output  logic      PCEnable, instructionRegisterEnable, dataRegisterEnable, MSBaddressEnable, LSBaddressEnable, zeroEnable, // enables for other registers
                   output  logic      muxSelectPC, muxSelectZero, muxSelectAddress, muxSelectALUtoAC, muxSelectMEM_or_R_toAC);  // mux selectlines

// internal signals for which instruction the opcode represents
  logic INOP, ILDAC, ISTAC, IMVAC, IMOVR, IJUMP, IJMPZ, IJPNZ;
  logic IADD, ISUB, IINAC, ICLAC, IAND, IOR, IXOR, INOT;

  typedef enum logic [3:0] {S0, S1, S2, S3, S4, S5, S6, S7, S8, S9, S10} statetype;
  statetype state, nextstate;

// state register
  always_ff @(posedge clk, posedge reset)
    if (reset) state <= S0;
    else       state <= nextstate;

// next state logic
  always_comb
    case (state)
      S0:      nextstate = S1;

      S1:      if(INOP)             nextstate = S0;
               else if(Opcode[3])   nextstate = S2;
               else if(IMVAC)       nextstate = S3;
               else if(IMOVR)       nextstate = S4;
               else                 nextstate = S5;

      S2:      nextstate = S0;
      S3:      nextstate = S0;
      S4:      nextstate = S0;
      S5:      nextstate = S6;

      S6:      if(ISTAC)                    nextstate = S7;
               else if(ILDAC)               nextstate = S8;
               else if(IJMPZ&z | IJPNZ&~z)  nextstate = S0;
               else                         nextstate = S10;

      S7:      nextstate = S0;
      S8:      nextstate = S9;
      S9:      nextstate = S0;
      S10:     nextstate = S0;
      default: nextstate = S0;
    endcase

// output logic
  instructionDecoder decoder(Opcode, {INOT, IXOR, IOR, IAND, ICLAC, IINAC, ISUB, 
                             IADD, IJPNZ, IJMPZ, IJUMP, IMOVR, IMVAC, ISTAC, ILDAC, INOP});

// need
//  - all register enables:  R, AC, Z, PC, IR, DR, MA, LA, MEM
//  - all multiplexer lines: M1, M2, M3, M4, M5

assign writeEnableR                 = ;
assign writeEnableAC                = ;
assign writeEnableMem               = ;
assign PCEnable                     = ;
assign instructionRegisterEnable    = ;
assign dataRegisterEnable           = ;
assign MSBaddressEnable             = ;
assign LSBaddressEnable             = ;
assign zeroEnable                   = ;

assign muxSelectPC              = ;
assign muxSelectZero            = ;
assign muxSelectAddress         = ;
assign muxSelectALUtoAC         = ;
assign muxSelectMEM_or_R_toAC   = ;

endmodule
