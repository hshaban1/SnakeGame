module Snake_holdNmove(clk, reset, length_up, KeyInput, head_position, eachbody, allbody, headplusbody, snake_up);
	input logic clk, reset, length_up;
	input logic [3:0] KeyInput;
	output logic [7:0][7:0] head_position;
	output logic [7:0][7:0] allbody, headplusbody;
	output logic [63:0][7:0][7:0] eachbody;
	output logic snake_up;
	integer body_index, sweepupdate, display_x, display_y, body_count, incbody; //x,y coordinate
    
	parameter [1:0] LEFT = 2'b00, RIGHT = 2'b01, UP = 2'b10, DOWN = 2'b11;

	
	always_ff @(posedge clk) begin
		if (reset | allbody[display_y][display_x] == 1) begin
			display_x = 1;
			display_y = 3;
			headplusbody <= {8'd0, 8'd0, 8'd0, 8'd0, 8'd0, 8'd0, 8'd0, 8'd0};
			snake_up <= 0;
			for (body_index = 4; body_index < 64; body_index++) begin
				eachbody[body_index] <= {8'd0, 8'd0, 8'd0, 8'd0, 8'd0, 8'd0, 8'd0, 8'd0};
			end	
			body_count <= 4;
			incbody <= 0;

			
			head_position <= {8'd0, 8'd0, 8'd0, 8'd0, 8'b00000010, 8'd0, 8'd0, 8'd0};
			eachbody[0] <= {8'd0, 8'd0, 8'd0, 8'd0, 8'b00000100, 8'd0, 8'd0, 8'd0};
         eachbody[1] <= {8'd0, 8'd0, 8'd0, 8'd0, 8'b00001000, 8'd0, 8'd0, 8'd0};
			eachbody[2] <= {8'd0, 8'd0, 8'd0, 8'd0, 8'b00010000, 8'd0, 8'd0, 8'd0};	
			eachbody[3] <= {8'd0, 8'd0, 8'd0, 8'd0, 8'b00100000, 8'd0, 8'd0, 8'd0};
			end
		else begin
				
            if (length_up) begin
					 incbody++;
					 body_count <= body_count + incbody;
                eachbody[body_count] <= eachbody[body_count - 1];
					 snake_up <= 1;
            end
            snake_up <= 0;
			case (KeyInput)
				
				LEFT: begin
                    head_position[display_y][display_x + 1] <= 1;
                    display_x <= (display_x + 1);
						  if(display_x > 7)
						  head_position[display_y][0] <= 1;
						  display_x <= 0;
				end

				RIGHT: begin
                    head_position[display_y][display_x - 1] <= 1;
                    display_x <= (display_x - 1);
						  if(display_x < 0)
						  head_position[display_y][7] <= 1;
						  display_x <= 7;
				end

				UP: begin
                    head_position[display_y + 1][display_x] <= 1;
                    display_y <= (display_y + 1);
						  if(display_y > 8)
						  head_position[0][display_x] <= 1;
						  display_y <= 0;
				end
				
				DOWN: begin
                    head_position[display_y - 1][display_x] <= 1;
                    display_y <= (display_y - 1);
						  if(display_y < 0)
						  head_position[7][display_x] <= 1;
						  display_y <= 7;
				end
			endcase
			head_position[display_y][display_x] <= 0;	

			for (sweepupdate = 63; sweepupdate >= 1; sweepupdate--) begin
                if ((eachbody[sweepupdate] != {8'd0, 8'd0, 8'd0, 8'd0, 8'd0, 8'd0, 8'd0, 8'd0}) && (body_count > sweepupdate))
					 eachbody[sweepupdate] <= eachbody[sweepupdate - 1];
			end		 
					 eachbody[0] <= head_position;
					 
					 
					 headplusbody <= (head_position|eachbody[0]|eachbody[1]|eachbody[2]|eachbody[3]|eachbody[4]|eachbody[5]|eachbody[6]|eachbody[7]|eachbody[8]|eachbody[9]|eachbody[10]|eachbody[11]|eachbody[12]|eachbody[13]|eachbody[14]|eachbody[15]|eachbody[16]|eachbody[17]|eachbody[18]|eachbody[19]|eachbody[20]|eachbody[21]|eachbody[22]|eachbody[23]|eachbody[24]|eachbody[25]|eachbody[26]|eachbody[27]|eachbody[28]|eachbody[29]|eachbody[30]|eachbody[31]|eachbody[32]|eachbody[33]|eachbody[34]|eachbody[35]|eachbody[36]|eachbody[37]|eachbody[38]|eachbody[39]|eachbody[40]|eachbody[41]|eachbody[42]|eachbody[43]|eachbody[44]|eachbody[45]|eachbody[46]|eachbody[47]|eachbody[48]|eachbody[49]|eachbody[50]|eachbody[51]|eachbody[52]|eachbody[53]|eachbody[54]|eachbody[55]|eachbody[56]|eachbody[57]|eachbody[58]|eachbody[59]|eachbody[60]|eachbody[61]|eachbody[62]|eachbody[63]);
								  
					 allbody <= (eachbody[0]|eachbody[1]|eachbody[2]|eachbody[3]|eachbody[4]|eachbody[5]|eachbody[6]|eachbody[7]|eachbody[8]|eachbody[9]|eachbody[10]|eachbody[11]|eachbody[12]|eachbody[13]|eachbody[14]|eachbody[15]|eachbody[16]|eachbody[17]|eachbody[18]|eachbody[19]|eachbody[20]|eachbody[21]|eachbody[22]|eachbody[23]|eachbody[24]|eachbody[25]|eachbody[26]|eachbody[27]|eachbody[28]|eachbody[29]|eachbody[30]|eachbody[31]|eachbody[32]|eachbody[33]|eachbody[34]|eachbody[35]|eachbody[36]|eachbody[37]|eachbody[38]|eachbody[39]|eachbody[40]|eachbody[41]|eachbody[42]|eachbody[43]|eachbody[44]|eachbody[45]|eachbody[46]|eachbody[47]|eachbody[48]|eachbody[49]|eachbody[50]|eachbody[51]|eachbody[52]|eachbody[53]|eachbody[54]|eachbody[55]|eachbody[56]|eachbody[57]|eachbody[58]|eachbody[59]|eachbody[60]|eachbody[61]|eachbody[62]|eachbody[63]);
        end
	end
	endmodule
	
	module Snake_holdNmove_testbench();
	logic clk, reset, length_up;
	logic [3:0] KeyInput;
	logic [3:0] LEFT = 4'b0001, RIGHT = 4'b0010, UP = 4'B0100, DOWN = 4'b1000;
	logic [7:0][7:0] head_position;
	logic [63:0][7:0][7:0] eachbody;
   logic [7:0][7:0] allbody, headplusbody;
	reg [2:0] display_x , display_y; //INTEGER IN MODULE BUT 3 BITS FOR 8 VALUE INDEX

	Snake_holdNmove dut(.clk, .reset, .length_up, .KeyInput, .head_position, .eachbody, .allbody, .headplusbody);
		
	parameter CLOCK_PERIOD = 100;
	initial begin
		clk <= 1;
		forever #(CLOCK_PERIOD/2) clk <= ~clk;
	end
	
	initial begin                    
			
	reset <=1; @(posedge clk);    
	@(posedge clk);    
	reset <=0;  
	KeyInput <= RIGHT; display_x = 3'b001; display_y = 3'b011;
	@(posedge clk);   
	@(posedge clk);                     
	@(posedge clk); 
	length_up <= 1;
	@(posedge clk);                     
	@(posedge clk); 
	@(posedge clk);                     
	@(posedge clk); 
	length_up <= 0; KeyInput <= LEFT; @(posedge clk);   
	@(posedge clk);                     
	@(posedge clk); 
	@(posedge clk); 
	length_up <= 1;	
	@(posedge clk); 
	@(posedge clk);                     
	@(posedge clk); 	
	length_up <= 0; KeyInput <= UP; @(posedge clk);
	@(posedge clk);          
	@(posedge clk);         
	@(posedge clk);
	length_up <= 1;
	@(posedge clk);                            
	@(posedge clk);  								
	@(posedge clk);                
	@(posedge clk); 
	length_up <= 0; KeyInput <= DOWN; @(posedge clk);   
	@(posedge clk);                     
	@(posedge clk); 
	@(posedge clk);                     
	@(posedge clk); 
	@(posedge clk);                     
	@(posedge clk); 
	reset <=1; @(posedge clk);    
	@(posedge clk);    
	reset <=0;  
	KeyInput <= RIGHT;	
	@(posedge clk);   
	@(posedge clk);                     
	@(posedge clk); 
	@(posedge clk);				
	$stop; // End the simulation.  
	end 
endmodule 
	