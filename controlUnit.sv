module controlUnit(input  logic       clk, reset, // input clock and reset signals
                   input  logic       z, //output of zero register from Datapath
                   input  logic [7:0] opcode, //opcode from instruction register in Datapath
                   output logic       writeEnableAC, writeEnableR, writeEnableMem, // enables for R, AC, and memory
                   output logic       PCEnable, instructionRegisterEnable, dataRegisterEnable, MSBaddressEnable, LSBaddressEnable, zeroEnable, // enables for other registers
                   output logic       muxSelectPC, muxSelectAddress, muxSelectALUtoAC, muxSelectMEM_or_R_toAC);  // mux selectlines

// internal signals for which instruction the opcode represents
  logic INOP, ILDAC, ISTAC, IMVAC, IMOVR, IJUMP, IJMPZ, IJPNZ;
  logic IADD, ISUB, IINAC, ICLAC, IAND, IOR, IXOR, INOT;

// instruction decoder instantiation
  instructionDecoder decoder(opcode, {INOT, IXOR, IOR, IAND, ICLAC, IINAC, ISUB, IADD, 
                             IJPNZ, IJMPZ, IJUMP, IMOVR, IMVAC, ISTAC, ILDAC, INOP});

  typedef enum logic [3:0] {S0, S1, S2, S3, S4, S5, S6, S7, S8, S9, S10} statetype;
  statetype state, nextstate;

// state register
  always_ff @(posedge clk, posedge reset)
    if (reset) state <= S0;
    else       state <= nextstate;

// next state logic
  always_comb
    case (state)
      // FETCH OPCODE STATE
      S0:      nextstate = S1;
      // DECODE STATE
      S1:      if(INOP)             nextstate = S0;
               else if(opcode[3])   nextstate = S2;
               else if(IMVAC)       nextstate = S3;
               else if(IMOVR)       nextstate = S4;
               else                 nextstate = S5;
      // ALU INSTRUCTION STATE
      S2:      nextstate = S0;
      // MVAC INSTRUCTION STATE
      S3:      nextstate = S0;
      // MOVR INSTRUCTION STATE
      S4:      nextstate = S0;
      // GAMMA INSTRUCTION STATE (FETCH MSB OF ADDRESS)
      S5:      nextstate = S6;
      // FETCH LSB OF ADDRESS
      S6:      if(ISTAC)                    nextstate = S7;
               else if(ILDAC)               nextstate = S8;
               else if(IJMPZ&~z | IJPNZ&z)  nextstate = S0;
               else                         nextstate = S10;
      // STAC STATE
      S7:      nextstate = S0;
      // LDAC STATE (LOAD MEMORY TO DATA REGISTER)
      S8:      nextstate = S9;
      // WRITE MEMORY TO ACCUMULATOR
      S9:      nextstate = S0;
      // JUMP STATE (FOR ALL JUMP INSTRUCTIONS) 
      S10:     nextstate = S0;

      default: nextstate = S0;
    endcase

// output logic
  assign writeEnableR                 = (state == S3); // R is only written to in the MVAC instruction, so enable is on in state 3
  assign writeEnableAC                = (state == S2) | (state == S4) | (state == S9); // AC is written to in ALU instructions, as well as MOVR and LDAC, so enable is on in states 2, 4, and 9
  assign writeEnableMem               = (state == S7); // memory is only written to in the STAC instruction, so enable is on in state 7
  assign PCEnable                     = (state == S0) | (state == S5) | (state == S6) | (state == S10); // PC is written to in all fetch states, and the jump instructions, so enable is on in states 0, 5, 6, and 10
  assign instructionRegisterEnable    = (state == S0); // opcode is only written in the first fetch state, so enable is on in state 0
  assign dataRegisterEnable           = (state == S8); // data register is only written to in the load data state, so enable is on in state 8
  assign MSBaddressEnable             = (state == S5); // MSB register is only written to in second fetch state, so enable is on in state 5
  assign LSBaddressEnable             = (state == S6); // MSB register is only written to in third  fetch state, so enable is on in state 6
  assign zeroEnable                   = (state == S2) | (state == S4) | (state == S9); // zero register only changes during ALU, MOVR, and LDAC instructions, so enable is on in states 2, 4, and 9

  assign muxSelectPC              = ~(state == S10); // must be false for S10 
  assign muxSelectAddress         =  (state == S0) | (state == S5) | (state == S6); // must be false for S7 and S8
  assign muxSelectALUtoAC         =  (state == S2);  // must be false for S4 and S9
  assign muxSelectMEM_or_R_toAC   =  (state == S4);  // must be false for S9

endmodule
