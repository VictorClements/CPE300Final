module smg_testbench();

// signals for the DUT
  logic clk, reset;
  logic [15:0] dataAddress;
  logic [7:0] dataValue, opcode;

// want to check the data at address 0x0015
  assign dataAddress = 16'h0015;

// instantiation of dut (smg)
  smg dut (clk, reset, dataAddress, dataValue, opcode);

// pulse reset at start of simulation
  initial
    begin
      reset <= 1; # 27; reset <= 0;
    end

// generate clock to sequence tests
  always
    begin
      clk <= 1;
      # 5; 
      clk <= 0;
      # 5; // clock duration
    end

  // check the contents of memory location 0x0015. It must be 2
  always @ (negedge clk)
  begin
    if (opcode == 8'h0 & ~reset) begin // if opcode is NOP and we are not in reset
      if (dataValue === 8'd2) begin  // if data the data value at address 0x0015 is 2, then simulation was successful
        $display ("Simulation succeeded");
        $stop;
      end 
      else begin  // otherwise, unsuccessful
        $display ("Simulation failed");
        $stop;
      end
    end
  end

endmodule