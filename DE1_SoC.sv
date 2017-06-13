module DE1_SoC (CLOCK_50, SW, KEY, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, GPIO_0);   
   input logic  CLOCK_50; 
   input logic [3:0] KEY; 
   input logic [9:0] SW; 
	logic [31:0] clk;	
	logic reset;
	logic [63:0][7:0][7:0] eachBody;
	logic [7:0][7:0] allBody, headplusbody, headpos, applepos;
	logic [3:0] Keyout;
	logic length_up;
	logic snake_up;
	logic [5:0] score;
	integer size;
   output logic  [6:0]  HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;                   
	output logic [35:0] GPIO_0;
	
	//comment when simulating
	parameter matrixClock = 4;
	parameter AppleClock = 10;
	parameter SnakeClock = 17;
	parameter scoreDisplayClock = 17;
	clock_divider cdiv (CLOCK_50, clk);    

	assign HEX2 = 7'b1111111;
	assign HEX3 = 7'b1111111;
	assign HEX4 = 7'b1111111;
	assign HEX5 = 7'b1111111;
	
	assign reset = SW[9];


		PressKey direction(.clk(CLOCK_50), .reset(reset), .KeyR(~KEY[0]), .KeyL(~KEY[3]), .KeyD(~KEY[1]), .KeyU(~KEY[2]), .Keyout(Keyout));
		
		Snake_holdNmove Snakemodule(.clk(clk[SnakeClock]), .reset(reset), .length_up(length_up), .KeyInput(Keyout), .head_position(headpos), .eachbody(eachBody), .allbody(allBody), .headplusbody(headplusbody), .snake_up(snake_up));
		
		randomapple_generator applemodule(.clk(clk[AppleClock]), .reset(reset), .snake_feedback(snake_up), .allbody(allBody), .Snakehead_position(headpos), .apple_position(applepos), .length_up(length_up));
		
		ScoreDisplay scoreManager(.clk(clk[scoreDisplayClock]), .reset(reset), .snake_feedback(snake_up), .HexTens(HEX1), .HexOnes(HEX0));
		
		led_matrix_driver displaygame (.clock(clk[matrixClock]), .reset(reset), .red_array(applepos), .green_array(headplusbody), .red_driver(GPIO_0[27:20]), .green_driver(GPIO_0[35:28]), .row_sink(GPIO_0[19:12]));
  
endmodule                 

module DE1_SoC_testbench;
	logic CLOCK_50;
	logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	logic [9:0] LEDR;
	logic [3:0] KEY; 
	logic [9:0] SW;
    logic [35:0] GPIO_0;
    logic [7:0][7:0] head;
	logic [63:0][7:0][7:0] body;

	DE1_SoC dut (.CLOCK_50, .HEX0, .HEX1, .HEX2, .HEX3, .HEX4, .HEX5, .KEY, .SW, .GPIO_0);
	
	parameter CLOCK_PERIOD = 100;
	initial begin
		CLOCK_50 <= 0;
		forever #(CLOCK_PERIOD/2) CLOCK_50 <= ~CLOCK_50;
	end
	
	initial KEY[0] = 1;
	
	 // Set up the inputs to the design. Each line is a clock cycle.
	initial begin
		@(posedge CLOCK_50); SW[9] = 1;
		@(posedge CLOCK_50); SW[9] = 0; KEY[3] = 1;
		@(posedge CLOCK_50); KEY[3] = 0;

		@(posedge CLOCK_50); KEY[3] = 1;
		@(posedge CLOCK_50); KEY[3] = 0;
		@(posedge CLOCK_50); KEY[3] = 1;
		@(posedge CLOCK_50); KEY[3] = 0;

		@(posedge CLOCK_50); KEY[3] = 1;
		@(posedge CLOCK_50); KEY[3] = 0;
		@(posedge CLOCK_50); KEY[3] = 1;
		@(posedge CLOCK_50); KEY[3] = 0;
		@(posedge CLOCK_50); KEY[3] = 1;
		@(posedge CLOCK_50); 
		@(posedge CLOCK_50);
		@(posedge CLOCK_50);
		@(posedge CLOCK_50); KEY[3] = 1;
		@(posedge CLOCK_50); KEY[3] = 0;
		@(posedge CLOCK_50); KEY[3] = 1;
		@(posedge CLOCK_50); KEY[3] = 0;
		@(posedge CLOCK_50); KEY[3] = 1;
		@(posedge CLOCK_50); KEY[3] = 1;
		@(posedge CLOCK_50); KEY[3] = 0;
		@(posedge CLOCK_50); KEY[3] = 1;
		@(posedge CLOCK_50); KEY[3] = 0;
		@(posedge CLOCK_50); KEY[3] = 1;

		@(posedge CLOCK_50); $stop;
	end
	
endmodule



// divided_clocks[0] = 25MHz, [1] = 12.5Mhz, ... [23] = 3Hz, [24] = 1.5Hz, [25] = 0.75Hz, ...    
module clock_divider (clock, divided_clocks);       
   input  logic          clock;   
   output logic  [31:0]  divided_clocks;      
   initial      
      divided_clocks <= 0;  
   always_ff @(posedge clock)  
      divided_clocks <= divided_clocks + 1;   
endmodule 