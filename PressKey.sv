module PressKey (clk, reset, KeyR, KeyL, KeyD, KeyU, Keyout);
	input logic clk, reset;
	input logic KeyR, KeyL, KeyD, KeyU;
	output logic [3:0] Keyout;
	logic [1:0] ps, ns;
	logic psa;
	parameter [1:0] LEFT = 2'b00, RIGHT = 2'b01, UP = 2'b10, DOWN = 2'b11;
	//NOTE: opposite directions were not accounted for as states to prevent instant end of game
	always_comb
		case (ps)

			LEFT:
				if (KeyD) 
				ns = DOWN;
				else if (KeyU)
				ns = UP;
				else 
				ns = LEFT;
				
			RIGHT:
				if (KeyU) 
				ns = UP;
				else if (KeyD) 
				ns = DOWN;
				else 
				ns = RIGHT;
			
			DOWN:
				if (KeyL)
				ns = LEFT;
				else if (KeyR)
				ns = RIGHT;
				else 
				ns = DOWN;
				
			UP:
				if (KeyR) 
				ns = RIGHT;
				else if (KeyL) 
				ns = LEFT;
				else 
				ns = UP;	
		endcase  
	assign Keyout = ps;
		
   always_ff @(posedge clk)
		if (reset)
			ps <= RIGHT;
		else
         ps <= ns;      
	endmodule
	
	module PressKey_testbench();
   logic clk, reset;
	logic KeyR, KeyL, KeyD, KeyU;
	logic [3:0] Keyout;
	logic [3:0] ps, ns;
	
		PressKey dut(.clk, .reset, .KeyR, .KeyL, .KeyD, .KeyU, .Keyout);
	
	parameter CLOCK_PERIOD = 100;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk;
	end
	
	
	initial begin                    
	 reset <=1; @(posedge clk);       
	 reset <= 0; KeyR <= 1; @(posedge clk);     
	 @(posedge clk);
	 KeyR <= 0; KeyU <= 1;@(posedge clk);          
	 @(posedge clk);
	 @(posedge clk);
	 @(posedge clk);
	 KeyU <= 0; KeyL <= 1;@(posedge clk);          
	 @(posedge clk);
	 @(posedge clk);
	 @(posedge clk);
	 KeyL <= 0; KeyD <= 1;@(posedge clk);          
	 @(posedge clk);
	 @(posedge clk);
	 @(posedge clk);
	 reset <=1; @(posedge clk);       
	 reset <= 0; KeyR <= 0; KeyU <= 1;@(posedge clk);          
	 @(posedge clk);
	 @(posedge clk);
	 @(posedge clk);
					
		$stop; // End the simulation.  
		end 
	endmodule 
	
