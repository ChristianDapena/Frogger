module Frog (x, y, up, down, left, right, game_over, reset, CLK);
	input logic up, down, left, right, reset, CLK, game_over;
	output logic [3:0] x, y;
	
	
	typedef enum logic [2:0] {RESET, GAME_ON, VICTORY, GAME_OVER} state_t;
	state_t state, next_state;
	
	
	
	always_ff @(posedge CLK) begin
			if(reset)
				state <= RESET;
			else
				state <= next_state;
	end
	
	
	always_comb begin
		case (state)
			RESET: 
				if(~reset)
					next_state = GAME_ON;
				else begin
					next_state = state;
				end
			GAME_ON: 
				if(reset) begin
					next_state = RESET;
				end
				else if (y == 0) begin
					next_state = VICTORY;
				end
				else if (game_over) begin
					next_state = GAME_OVER;
				end
				else
					next_state = state;
			VICTORY: 
				if(reset)
					next_state = RESET;
				else
					next_state = state;
			GAME_OVER:
				if(reset)
					next_state = RESET;
				else
					next_state = state;
					
			default: next_state = RESET;
		endcase
	end
		
		
		
	always_ff @(posedge CLK) begin
		if(state == RESET) begin
			x <= 8;
			y <= 15;
		end
		
		else if (state == GAME_ON) begin
			if(up & down) 
				y <= y;
			else if (down & y != 0)
				y <= y - 1;
			else if (up & y != 15)
				y <= y + 1;
			else
				y <= y;
				
			
			if (left & right)
				x <= x;
			else if (left & x != 0)
				x <= x - 1;
			else if (right & x != 15)
				x <= x + 1;
			else
				x <= x;
		end
		
		else if (state == VICTORY | state == GAME_OVER) begin
			x <= x;
			y <= y;
		end
	end
endmodule

module Frog_Testbench();
	logic [3:0] x, y;
	logic up, down, left, right, reset, CLK, game_over;
	
	Frog dut (.x(x), .y(y), .up(up), .down(down), .left(left), .right(right), .reset(reset), .CLK(CLK), .game_over(game_over));
	
	parameter CLOCK_PERIOD=100;

	
	initial begin
		CLK <= 0;
		forever #(CLOCK_PERIOD/2) CLK <= ~CLK; // Forever toggle the clock
	end
	
	initial begin
		up <= 0; down <= 0; left <=0; right <= 0; reset <= 1; game_over <= 0;	repeat(1) @(posedge CLK);
		up <= 0; down <= 0; left <=0; right <= 0; reset <= 0; game_over <= 0;	repeat(3) @(posedge CLK);
		
		
		up <= 1; down <= 0; left <=0; right <= 0; reset <= 0; game_over <= 0;	repeat(16) @(posedge CLK);	//	TEST WIN CONDITION
		up <= 0; down <= 0; left <=0; right <= 0; reset <= 0; game_over <= 0;	repeat(2) @(posedge CLK);	// Hold for 2 ticks
		up <= 0; down <= 0; left <=0; right <= 0; reset <= 1; game_over <= 0;	repeat(1) @(posedge CLK);	// TEST reset
		up <= 0; down <= 0; left <=0; right <= 0; reset <= 0; game_over <= 0;	repeat(1) @(posedge CLK);		
			
		up <= 0; down <= 1; left <=0; right <= 0; reset <= 0; game_over <= 0;	repeat(3) @(posedge CLK);	// TEST low boundary
		up <= 0; down <= 0; left <=0; right <= 0; reset <= 1; game_over <= 0;	repeat(1) @(posedge CLK);	// reset
		
		up <= 0; down <= 0; left <=0; right <= 1; reset <= 0; game_over <= 0;	repeat(10) @(posedge CLK);	// TEST right boundary
		up <= 0; down <= 0; left <=0; right <= 0; reset <= 1; game_over <= 0;	repeat(1) @(posedge CLK);	// reset
		up <= 0; down <= 0; left <=0; right <= 0; reset <= 0; game_over <= 0;	repeat(1) @(posedge CLK);	// Let sit for one tick
		
		up <= 0; down <= 0; left <=1; right <= 0; reset <= 0; game_over <= 0;	repeat(10) @(posedge CLK);	// TEST left boundary
		up <= 0; down <= 0; left <=0; right <= 0; reset <= 1; game_over <= 0;	repeat(1) @(posedge CLK);	// reset
		up <= 0; down <= 0; left <=0; right <= 0; reset <= 0; game_over <= 0;	repeat(1) @(posedge CLK);	// Let sit for one tick
		
		up <= 1; down <= 0; left <=0; right <= 0; reset <= 0; game_over <= 0;	repeat(20) @(posedge CLK);	// TEST VICTORY INPUT FREEZE
		up <= 0; down <= 0; left <=0; right <= 0; reset <= 1; game_over <= 0;	repeat(1) @(posedge CLK);	// reset
		up <= 0; down <= 0; left <=0; right <= 0; reset <= 0; game_over <= 0;	repeat(1) @(posedge CLK);	// Let sit for one tick
		
		up <= 0; down <= 0; left <=0; right <= 0; reset <= 0; game_over <= 1;	repeat(1) @(posedge CLK);	// GAME OVER
		up <= 0; down <= 1; left <=1; right <= 0; reset <= 0; game_over <= 0;	repeat(3) @(posedge CLK);	// TEST INPUTS
		up <= 1; down <= 0; left <=0; right <= 0; reset <= 0; game_over <= 0;	repeat(2) @(posedge CLK);	
		up <= 0; down <= 0; left <=0; right <= 1; reset <= 0; game_over <= 0;	repeat(1) @(posedge CLK);
		up <= 0; down <= 0; left <=0; right <= 0; reset <= 1; game_over <= 0;	repeat(1) @(posedge CLK);	// reset
		
		up <= 1; down <= 0; left <=0; right <= 0; reset <= 0; game_over <= 0;	repeat(8) @(posedge CLK);	// Move to board center for ease of use
		up <= 0; down <= 0; left <=1; right <= 1; reset <= 0; game_over <= 0;	repeat(1) @(posedge CLK);	// TEST simultaneous inputs - LEFT & RIGHT
		up <= 1; down <= 1; left <=0; right <= 0; reset <= 0; game_over <= 0;	repeat(1) @(posedge CLK);	// TEST simultaneous inputs - UP & DOWN
		up <= 1; down <= 1; left <=1; right <= 1; reset <= 0; game_over <= 0;	repeat(1) @(posedge CLK);	// TEST simultaneous inputs  - ALL 4 DIRECTIONS
		up <= 0; down <= 0; left <=0; right <= 0; reset <= 0; game_over <= 1;	repeat(1) @(posedge CLK);	//TEST GAME OVER THEN RESET
		reset <= 1;																					repeat(1) @(posedge CLK);	// TEST if reset pulls game_over to 0
		
		$stop;
	end
endmodule
		
		
		
		
		
