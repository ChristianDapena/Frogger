module Frogger(up, down, left, right, CLK, reset, frog_pixel, car_pixels, spawn_rate);
	input logic up, down, left, right, CLK, reset;
	input logic [4:0] spawn_rate; //covers how fast these things spawn (Higher switches = slower movement)
	
	output logic [15:0][15:0] frog_pixel;
	output logic [15:0][15:0] car_pixels;
	

	
	logic [15:0] frog_x;
	logic [15:0] frog_y;
	
	
	logic [15:0] game_over_rows;
	logic game_over;
	
	logic [15:0][15:0] game_seed;
	logic [3:0] boundary_low;
	logic [3:0] boundary_high;
	
	assign boundary_low = 0;
	assign boundary_high = 15;

	
	assign game_seed[0] = 16'b1101001011010100;
	assign game_seed[1] = 16'b1001010000001100;
	assign game_seed[2] = 16'b1001101100100000;
	assign game_seed[3] = 16'b0111101101010101;
	assign game_seed[4] = 16'b0110001000010100;
	assign game_seed[5] = 16'b0111001001110010;
	assign game_seed[6] = 16'b0110100011001101;
	assign game_seed[7] = 16'b0110000010101010;
	assign game_seed[8] = 16'b0100000100101010;
	assign game_seed[9] = 16'b1000010101000000;
	assign game_seed[10] = 16'b1001000010100011;
	assign game_seed[11] = 16'b1000110001000101;
	assign game_seed[12]	= 16'b1000010010011010;
	assign game_seed[13] = 16'b0010100000011010;
	assign game_seed[14] = 16'b0101001000010000;
	assign game_seed[15] = 16'b0000000000000000;
	
	
	
	logic [31:0] divided_clock;
	clock_divider div (.clock(CLK), .divided_clocks(divided_clock));
	
	logic car_enable;
	userInput car_pulse (.in(divided_clock[spawn_rate]), .CLK(CLK), .out(car_enable));
	
	
	
	
	
	//If frog motion is lopsided or incorrect, look here first!!!!
	genvar frogXFor, frogYFor;
	generate
		for (frogYFor = 0; frogYFor < 16; frogYFor++) begin : Y_Direction
			for(frogXFor = 0; frogXFor < 16; frogXFor++) begin : X_Direction
				assign frog_pixel[frogYFor][frogXFor] = (frogXFor == frog_x) & (frogYFor == frog_y);
			end
		end
	endgenerate
	


	Frog kermit (.x(frog_x), .y(frog_y), .up(up), .down(down), .left(left), .right(right), .game_over(game_over),
	.reset(reset), .CLK(CLK));
	
	

	
	genvar i;
	generate
		for(i = 0; i <= 15; i++) begin : frogRows
			if(i == 0 || i % 6 == 0 || i == 15) begin
				row rows_with_cars (.y(i), .frog_x(frog_x), .frog_y(frog_y), .reset_code(game_seed[15]),
				.max_cars(boundary_low), .CLK(CLK), .enable(car_enable), .reset(reset), .game_over(game_over_rows[i]), .car(car_pixels[i]));
			end
			else begin
				row rows_with_cars (.y(i), .frog_x(frog_x), .frog_y(frog_y), .reset_code(game_seed[i - 1]),
				.max_cars(5), .CLK(CLK), .enable(car_enable), .reset(reset), .game_over(game_over_rows[i]), .car(car_pixels[i]));
			end
		end
	endgenerate
				
	
				
				
				
				
	always_comb begin
		game_over = |game_over_rows;
	end
endmodule






module Frogger_testbench();
	logic up, down, left, right, CLK, reset;	// input
	logic [15:0][15:0] frog_pixel;				// output
	logic [15:0][15:0] car_pixels;				// output
	logic [4:0] spawn_rate; //covers how fast these things spawn (Higher switches = slower movement) 	input
	
	Frogger dut (.up(up), .down(down), .left(left), .right(right), .CLK(CLK), .reset(reset), .frog_pixel(frog_pixel), .car_pixels(car_pixels), .spawn_rate(spawn_rate));
	
	
	parameter CLOCK_PERIOD=100;

	
	initial begin
		CLK <= 0;
		forever #(CLOCK_PERIOD/2) CLK <= ~CLK; // Forever toggle the clock
	end
	
	
	
	
	
	initial begin
		/*
		Test Cases: 
				test up, down, left, right, and reset work, and that spawn_rate adjusts slower movement works as intended
		*/
		
		up <= 0; down <= 0; left <= 0; right <= 0; reset <= 1; spawn_rate <= 31;	repeat(1) @(posedge CLK);
		up <= 0; down <= 0; left <= 0; right <= 0; reset <= 0; spawn_rate <= 31;	repeat(1) @(posedge CLK);
		up <= 1; down <= 0; left <= 0; right <= 0; reset <= 0; spawn_rate <= 31;	repeat(16) @(posedge CLK); // Tests to see that either game over or victory are triggered
		
		up <= 0; down <= 0; left <= 1; right <= 0; reset <= 0; spawn_rate <= 31;	repeat(2) @(posedge CLK);
		up <= 0; down <= 0; left <= 0; right <= 0; reset <= 0; spawn_rate <= 31;	repeat(2) @(posedge CLK);
		up <= 1; down <= 0; left <= 1; right <= 0; reset <= 0; spawn_rate <= 31;	repeat(1) @(posedge CLK);
		up <= 0; down <= 0; left <= 0; right <= 0; reset <= 1; spawn_rate <= 31;	repeat(1) @(posedge CLK);
		up <= 1; down <= 1; left <= 0; right <= 0; reset <= 0; spawn_rate <= 31;	repeat(1) @(posedge CLK);
		
		up <= 0; down <= 0; left <= 0; right <= 0; reset <= 1; spawn_rate <= 4;	repeat(1) @(posedge CLK);
		up <= 0; down <= 0; left <= 0; right <= 0; reset <= 0; spawn_rate <= 4;	repeat(64) @(posedge CLK);	// Tests how cars in rows move.
		
		$stop;
	end
endmodule
	
