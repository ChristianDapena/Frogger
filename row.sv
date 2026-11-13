module row(y, frog_x, frog_y, reset_code, max_cars, CLK, enable, reset, game_over, car);
	input logic CLK, reset, enable;
	input logic [15:0] reset_code;
	input logic [15:0] frog_x, frog_y;
	input logic [4:0] max_cars;
	input logic [4:0] y;

	
	output logic game_over;
	output logic [15:0] car;
	logic [4:0] num_cars;
	
	
	
	// Treating car as shift register
	count_cars car_num (.cars(car), .num_cars(num_cars));
	
	always_ff @(posedge CLK) begin
		if(reset) begin
			car <= reset_code;
			game_over <= 0;
		end
		
		else if((car[frog_x]) & (frog_y == y)) begin
			game_over <= 1;
			car <= car;
		end
		else if (frog_y == 0) begin
			car <= car;
		end
		else if (enable & max_cars != 0) begin
			car[0] <= ((num_cars <= max_cars) & ((car[15] & car[14] & car[2] & car[3]) 
			| (~car[15] & ~car[14] & car[2] & car[3])
			| (~car[15] & car[14] & ~car[2] & car[3])
			| (~car[15] & car[14] & car[2] & ~car[3])
			| (car[15] & ~car[14] & ~car[2] & car[3])
			|	(car[15] & ~car[14] & car[2] & ~car[3])
			| (car[15] & car[14] & ~car[2] & ~car[3])
			| (~car[15] & ~car[14] & ~car[2] & ~car[3])	// LONG ASS XNOR DERIVATION FOR CAR SPAWN
			));
		
			car[1] <= car[0];
			car[2] <= car[1];
			car[3] <= car[2];
			car[4] <= car[3];
			car[5] <= car[4];
			car[6] <= car[5];
			car[7] <= car[6];
			car[8] <= car[7];
			car[9] <= car[8];
			car[10] <= car[9];
			car[11] <= car[10];
			car[12] <= car[11];
			car[13] <= car[12];
			car[14] <= car[13];
			car[15] <= car[14];
		end
	end
	
endmodule 



module row_Testbench();
	logic CLK, reset;
	logic [15:0] reset_code;
	logic [15:0] frog_x, frog_y;
	logic [4:0] max_cars;
	logic [4:0] y;
	logic game_over;
	logic [15:0] car;
	logic enable;
	
	
	row dut (.y(y), .frog_x(frog_x), .frog_y(frog_y), .reset_code(reset_code), .max_cars(max_cars), 
			.CLK(CLK), .enable(enable), .reset(reset), .game_over(game_over), .car(car));

			
	parameter CLOCK_PERIOD=100;

	
	initial begin
		CLK <= 0;
		forever #(CLOCK_PERIOD/2) CLK <= ~CLK; // Forever toggle the clock
	end
	
	
	initial begin
		//TEST reset properly implements reset_code, test collision, test max cars
		reset_code <= 16'b0; reset <=1; frog_x <= 4'b0111; frog_y <= 14; max_cars <= 7; y <= 14; enable <= 1;			repeat(1) @(posedge CLK);	// Sets up initial conditions
		reset <= 0; 																																repeat(16) @(posedge CLK);	// Test Collision when y == frog_y
		reset <= 1;																																	repeat(1) @(posedge CLK);	//	Test reset
		reset <= 0; frog_y <= 12;																												repeat(20) @(posedge CLK);	// Test no collision when y != frog_y, will also test 
		
		reset <= 0; 	enable <= 0;																											repeat(16) @(posedge CLK);	// Test Enable = 0 
		reset <= 0; frog_y <= 12;																												repeat(20) @(posedge CLK);	
		reset <= 1;		enable <= 1;																											repeat(1) @(posedge CLK);	//	Test reset

		
		reset_code <= 16'b0100100010000000; reset <=1; frog_x <= 4'b0111; frog_y <= 14; max_cars <= 7; y <= 14;		repeat(1) @(posedge CLK);	// Sets up initial conditions with 3 cars
		reset <= 0; 																																repeat(16) @(posedge CLK);	// Test Collision when y == frog_y
		reset <= 1;																																	repeat(1) @(posedge CLK);	//	Test reset
		reset <= 0; frog_y <= 12;																												repeat(20) @(posedge CLK);	// Test no collision when y != frog_y, will also test 
		
		
		reset_code <= 16'b0101110110111110; reset <=1; frog_x <= 4'b0111; frog_y <= 14; max_cars <= 7; y <= 14;		repeat(1) @(posedge CLK);	// Sets up initial conditions with # cars initially exceeding max_cars
		reset <= 0; 																																repeat(16) @(posedge CLK);	// Test Collision when y == frog_y
		reset <= 1;																																	repeat(1) @(posedge CLK);	//	Test reset
		reset <= 0; frog_y <= 12;																												repeat(20) @(posedge CLK);	// Test no collision when y != frog_y, will also test 
		
		$stop;
	end
endmodule


































