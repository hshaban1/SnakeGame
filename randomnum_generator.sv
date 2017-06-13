module randomnum_generator (clk, reset, Snake, Apple);

  //output logic reg [9:0] out;
  input logic clk, reset;
  logic [11:0] rndcoordinates; //12-bit LFSR
  output logic [5:0] Snake, Apple; //LFSR split into two 6-bit registers
  logic [2:0] SnakeX, SnakeY, AppleX, AppleY;
  logic xnorinput;
  logic ps, ns;
  //output logic [9:0] result;
  assign xnorinput = ~(rndcoordinates[11] ^ rndcoordinates[5] ^ rndcoordinates[3] ^ rndcoordinates[0]);
  assign Snake = rndcoordinates[11:6];
  assign SnakeX = rndcoordinates[11:9];
  assign SnakeY = rndcoordinates[8:6];
  assign Apple = rndcoordinates[5:0];
  assign AppleX = rndcoordinates[5:3];
  assign AppleY = rndcoordinates[2:0];
  always_comb begin
	if(Snake = Apple)
	ns xnorinput = ps xnorinput;
	else
	ns xnorinput = ns xnorinput;
	
	end

always_ff @(posedge clk, posedge reset)
  begin
    if (reset)
      rndcoordinates = 12'b0;
    else
      rndcoordinates = {rndcoordinates[10:0], xnorinput};
  end
endmodule


module randomnum_generator_testbench();
logic [5:0] Snake, Apple;
logic clk, reset;

randomnum_generator dut(.clk, .reset, .Snake, .Apple);

// Set up the clock.
	parameter CLOCK_PERIOD=100;
	initial clk=1;
	always begin
		#(CLOCK_PERIOD/2);
		clk = ~clk;
	end
		
	initial begin
	reset <= 1;	@(posedge clk);
	reset <= 0; @(posedge clk);
@(posedge clk);
@(posedge clk);
@(posedge clk);
@(posedge clk);
@(posedge clk);
@(posedge clk);
@(posedge clk);
@(posedge clk);
@(posedge clk);
@(posedge clk);
@(posedge clk);
@(posedge clk);
@(posedge clk);
@(posedge clk);
@(posedge clk);
@(posedge clk);
@(posedge clk);
@(posedge clk);
@(posedge clk);
@(posedge clk);
		$stop; // End the simulation.	
end
endmodule
