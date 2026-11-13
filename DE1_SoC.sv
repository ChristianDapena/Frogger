// I just want to specify: This DE1_SoC module is a *modified* version of the top-level module from the 16 x 16 bicolor LED Array board files

/* 
	To verify this, alongside the verbose code comments describing basic functionalities, please go to the DE1-SoC Interfaces and Peripherals
	page and download/view the files for the 16 x 16 bicolor LED array board. You should find it as the top level module of the led driver folder, 
	labeled "DE1_SoC". I showed this to Ayden already. 
*/


// Top-level module that defines the I/Os for the DE-1 SoC board
module DE1_SoC (HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, KEY, SW, LEDR, GPIO_1, CLOCK_50);
    output logic [6:0]  HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	 output logic [9:0]  LEDR;
    input  logic [3:0]  KEY;
    input  logic [9:0]  SW;
    output logic [35:0] GPIO_1;
    input logic CLOCK_50;

	 
	 logic R_into_userInput;
	 logic R;
	 logic Up_into_userInput;
	 logic Up;
	 logic Down_into_userInput;
	 logic Down;
	 logic L_into_userInput;
	 logic L;
	 logic [4:0] spawn_rate;
	 localparam whichClock = 15;
	 
	 
	 // Turn off HEX displays
    assign HEX0 = '1;
    assign HEX1 = '1;
    assign HEX2 = '1;
    assign HEX3 = '1;
    assign HEX4 = '1;
    assign HEX5 = '1;
	 
	 
	 /* Set up system base clock to 1526 Hz (50 MHz / 2**(14+1))
	    ===========================================================*/
	 logic [31:0] clk;
	 logic SYSTEM_CLOCK;
	 
	 logic [31:0]div_clk;
	 logic clkSelect;
	 
	 clock_divider divider (.clock(CLOCK_50), .divided_clocks(clk));
	 
	 assign SYSTEM_CLOCK = clk[14]; // 1526 Hz clock signal	 
	 
	 
	 /* If you notice flickering, set SYSTEM_CLOCK faster.
	    However, this may reduce the brightness of the LED board. */
	
	 
	 /* Set up LED board driver
	    ================================================================== */
	 logic [15:0][15:0]RedPixels; // 16 x 16 array representing red LEDs
    logic [15:0][15:0]GrnPixels; // 16 x 16 array representing green LEDs
	 logic RST;                   // reset - toggle this on startup
	 
	 assign RST = SW[9];
	 assign spawn_rate = {SW[5:0]};
	 
	 /* Standard LED Driver instantiation - set once and 'forget it'. 
	    See LEDDriver.sv for more info. Do not modify unless you know what you are doing! */
	 LEDDriver Driver (.CLK(SYSTEM_CLOCK), .RST, .EnableCount(1'b1), .RedPixels, .GrnPixels, .GPIO_1);
	 
	 
	 /* LED board test submodule - paints the board with a static pattern.
	    Replace with your own code driving RedPixels and GrnPixels.
		 
	 	 KEY0      : Reset
		 =================================================================== */
	// LED_test test (.RST(~KEY[0]), .RedPixels, .GrnPixels);
	 
	 	
	//DO NOT NEED TO TOUCH
	clock_divider cdiv (.clock(CLOCK_50), .divided_clocks(div_clk));

	// Clock selection; allows for easy switching between simulation and board
	// clocks

	// Uncomment ONE of the following two lines depending on intention    <-----   READ THIS
	assign clkSelect = CLOCK_50; // for simulation
	 //assign clkSelect = div_clk[whichClock]; // for board
	 
	 
	inSync L_intermediate (.in(KEY[0]), .CLK(clkSelect), .out(L_into_userInput));
	userInput L_out (.in(L_into_userInput), .CLK(clkSelect), .out(L));
	 
	inSync R_intermediate (.in(KEY[3]), .CLK(clkSelect), .out(R_into_userInput));
	userInput R_out (.in(R_into_userInput), .CLK(clkSelect), .out(R));
	 
	inSync Up_intermediate (.in(KEY[1]), .CLK(clkSelect), .out(Up_into_userInput));
	userInput up_out (.in(Up_into_userInput), .CLK(clkSelect), .out(Up));
	 
	inSync Down_intermediate (.in(KEY[2]), .CLK(clkSelect), .out(Down_into_userInput));
	userInput Down_out (.in(Down_into_userInput), .CLK(clkSelect), .out(Down));
	 
	Frogger lets_ribbit(.up(Up), .down(Down), .left(L), .right(R), .CLK(clkSelect), .reset(RST), .frog_pixel(GrnPixels), 
			.car_pixels(RedPixels), .spawn_rate(spawn_rate));
	 
	 
endmodule






module DE1_SoC_Testbench();
	 logic [6:0]  HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	 logic [9:0]  LEDR;
    logic [3:0]  KEY;
    logic [9:0]  SW;
    logic [35:0] GPIO_1;
    logic CLOCK_50;
	 
	 DE1_SoC dut (.HEX0(HEX0), .HEX1(HEX1), .HEX2(HEX2), .HEX3(HEX3), .HEX4(HEX4), .HEX5(HEX5),
								.KEY(KEY), .SW(SW), .LEDR(LEDR), .GPIO_1(GPIO_1), .CLOCK_50(CLOCK_50));
	
	
	parameter CLOCK_PERIOD=100;
	initial begin
		CLOCK_50 <= 0;
		forever #(CLOCK_PERIOD/2) CLOCK_50 <= ~CLOCK_50; // Forever toggle the clock
	end

	 
	initial begin
		SW[9] <= 0; KEY[3:0] <= 0; SW[4] <= 1; SW[3:0] <= 0;										repeat(1) @(posedge CLOCK_50);
		SW[9] <= 1; KEY[3:0] <= 0; SW[4] <= 1; SW[3:0] <= 0;										repeat(1) @(posedge CLOCK_50);
		SW[9] <= 0; KEY[3:0] <= 0; SW[4] <= 1; SW[3:0] <= 0;										repeat(1) @(posedge CLOCK_50);
		for(int i = 0; i < 16; i++) begin 
			SW[9] <= 0; KEY[3] <= 0; KEY[2] <= 1; KEY[1] <= 0; KEY[0] <= 0; SW[5] <= 0; SW[4] <= 1; SW[3:0] <= 0;		repeat(1) @(posedge CLOCK_50); // TEST GAME OVER OR VICTORY
			SW[9] <= 0; KEY[3:0] <= 0;																		repeat(1) @(posedge CLOCK_50);	// RESET
		end
		
		SW[9] <= 1; KEY[3:0] <= 0; SW[4] <= 1; SW[3:0] <= 0;										repeat(1) @(posedge CLOCK_50);
		SW[9] <= 0; KEY[3:0] <= 0; SW[4] <= 1; SW[3:0] <= 0;										repeat(1) @(posedge CLOCK_50);
		SW[9] <= 0; KEY[3] <= 0; KEY[2] <= 1; KEY[1] <= 0; KEY[0] <= 0; 						repeat(1) @(posedge CLOCK_50);	 //TEST if UP Key works



		SW[9] <= 1; KEY[3:0] <= 0; SW[4] <= 1; SW[3:0] <= 0;										repeat(1) @(posedge CLOCK_50);
		SW[9] <= 0; KEY[3:0] <= 0; SW[4] <= 1; SW[3:0] <= 0;										repeat(1) @(posedge CLOCK_50);
		SW[9] <= 0; KEY[3] <= 0; KEY[2] <= 0; KEY[1] <= 1; KEY[0] <= 0; 						repeat(1) @(posedge CLOCK_50);	 //TEST if DOWN Key works
		
		SW[9] <= 1; KEY[3:0] <= 0; SW[4] <= 1; SW[3:0] <= 0;										repeat(1) @(posedge CLOCK_50);
		SW[9] <= 0; KEY[3:0] <= 0; SW[4] <= 1; SW[3:0] <= 0;										repeat(1) @(posedge CLOCK_50);
		SW[9] <= 0; KEY[3] <= 0; KEY[2] <= 0; KEY[1] <= 1; KEY[0] <= 0; 						repeat(5) @(posedge CLOCK_50);	 //TEST if DOWN Key works as Pulse and not CONSTANT MOVEMENT
		
		
		SW[9] <= 1; KEY[3:0] <= 0; SW[4] <= 1; SW[3:0] <= 0;										repeat(1) @(posedge CLOCK_50);
		SW[9] <= 0; KEY[3:0] <= 0; SW[4] <= 1; SW[3:0] <= 0;										repeat(1) @(posedge CLOCK_50);
		SW[9] <= 0; KEY[3] <= 0; KEY[2] <= 0; KEY[1] <= 0; KEY[0] <= 1; 						repeat(1) @(posedge CLOCK_50);	 //TEST if RIGHT Key works
		
		SW[9] <= 1; KEY[3:0] <= 0; SW[4] <= 1; SW[3:0] <= 0;										repeat(1) @(posedge CLOCK_50);
		SW[9] <= 0; KEY[3:0] <= 0; SW[4] <= 1; SW[3:0] <= 0;										repeat(1) @(posedge CLOCK_50);
		SW[9] <= 0; KEY[3] <= 1; KEY[2] <= 0; KEY[1] <= 0; KEY[0] <= 0;						repeat(1) @(posedge CLOCK_50);	 //TEST if LEFT Key works
		
		SW[9] <= 1; KEY[3:0] <= 0; SW[4] <= 1; SW[3:0] <= 0;										repeat(1) @(posedge CLOCK_50);
		SW[9] <= 0; KEY[3:0] <= 0; SW[4] <= 1; SW[3:0] <= 0;										repeat(1) @(posedge CLOCK_50);
		SW[9] <= 0; KEY[3] <= 0; KEY[2] <= 0; KEY[1] <= 0; KEY[0] <= 0; SW[4] <= 0; SW[3:0] <= 4'b0;		repeat(20) @(posedge CLOCK_50);	 //TEST different ENABLE speed
		
		
		SW[9] <= 1; KEY[3:0] <= 0; SW[4] <= 1; SW[3:0] <= 0;										repeat(1) @(posedge CLOCK_50);
		SW[9] <= 0; KEY[3:0] <= 0; SW[4] <= 1; SW[3:0] <= 0;										repeat(1) @(posedge CLOCK_50);
		SW[9] <= 0; KEY[3] <= 1; KEY[2] <= 0; KEY[1] <= 0; KEY[0] <= 1; SW[4] <= 1; SW[3:0] <= 0;		repeat(1) @(posedge CLOCK_50);	// TEST LEFT and RIGHT at same time
		
		
		SW[9] <= 1; KEY[3:0] <= 0; SW[4] <= 1; SW[3:0] <= 0;										repeat(1) @(posedge CLOCK_50);
		SW[9] <= 0; KEY[3:0] <= 0; SW[4] <= 1; SW[3:0] <= 0;										repeat(1) @(posedge CLOCK_50);
		SW[9] <= 0; KEY[3] <= 0; KEY[2] <= 1; KEY[1] <= 1; KEY[0] <= 1; SW[4] <= 1; SW[3:0] <= 0;		repeat(1) @(posedge CLOCK_50);	// TEST UP AND DOWN at same time
		
		SW[9] <= 1; KEY[3:0] <= 0; SW[4] <= 1; SW[3:0] <= 0;										repeat(1) @(posedge CLOCK_50);
		SW[9] <= 0; KEY[3:0] <= 0; SW[4] <= 1; SW[3:0] <= 0;										repeat(3) @(posedge CLOCK_50);
		SW[9] <= 0; KEY[3] <= 1; KEY[2] <= 0; KEY[1] <= 0; KEY[0] <= 1;						repeat(3) @(posedge CLOCK_50);	// TEST GAME
		SW[9] <= 0; KEY[3] <= 0; KEY[2] <= 0; KEY[1] <= 0; KEY[0] <= 0;						repeat(1) @(posedge CLOCK_50);
		SW[9] <= 0; KEY[3] <= 1; KEY[2] <= 0; KEY[1] <= 0; KEY[0] <= 0;						repeat(1) @(posedge CLOCK_50);
		SW[9] <= 0; KEY[3] <= 0; KEY[2] <= 0; KEY[1] <= 1; KEY[0] <= 0;						repeat(1) @(posedge CLOCK_50);
		SW[9] <= 0; KEY[3] <= 0; KEY[2] <= 1; KEY[1] <= 0; KEY[0] <= 0;						repeat(1) @(posedge CLOCK_50);
		SW[9] <= 0; KEY[3] <= 0; KEY[2] <= 1; KEY[1] <= 0; KEY[0] <= 0;						repeat(1) @(posedge CLOCK_50);
		SW[9] <= 0; KEY[3] <= 0; KEY[2] <= 0; KEY[1] <= 1; KEY[0] <= 0;						repeat(1) @(posedge CLOCK_50);
		SW[9] <= 0; KEY[3] <= 1; KEY[2] <= 0; KEY[1] <= 0; KEY[0] <= 0;						repeat(1) @(posedge CLOCK_50);
		SW[9] <= 0; KEY[3] <= 0; KEY[2] <= 0; KEY[1] <= 0; KEY[0] <= 0;						repeat(1) @(posedge CLOCK_50);
		SW[9] <= 0; KEY[3] <= 0; KEY[2] <= 1; KEY[1] <= 0; KEY[0] <= 0;						repeat(1) @(posedge CLOCK_50);
		SW[9] <= 0; KEY[3] <= 1; KEY[2] <= 0; KEY[1] <= 0; KEY[0] <= 0;						repeat(1) @(posedge CLOCK_50);
		SW[9] <= 0; KEY[3] <= 0; KEY[2] <= 1; KEY[1] <= 0; KEY[0] <= 0;						repeat(1) @(posedge CLOCK_50);
		SW[9] <= 0; KEY[3] <= 0; KEY[2] <= 0; KEY[1] <= 0; KEY[0] <= 0;						repeat(1) @(posedge CLOCK_50);
		SW[9] <= 0; KEY[3] <= 0; KEY[2] <= 1; KEY[1] <= 0; KEY[0] <= 0;						repeat(1) @(posedge CLOCK_50);
		SW[9] <= 0; KEY[3] <= 0; KEY[2] <= 0; KEY[1] <= 0; KEY[0] <= 0;						repeat(1) @(posedge CLOCK_50);
		SW[9] <= 0; KEY[3] <= 0; KEY[2] <= 0; KEY[1] <= 0; KEY[0] <= 0;						repeat(1) @(posedge CLOCK_50);
		SW[9] <= 0; KEY[3] <= 0; KEY[2] <= 1; KEY[1] <= 0; KEY[0] <= 0;						repeat(1) @(posedge CLOCK_50);
		SW[9] <= 0; KEY[3] <= 1; KEY[2] <= 0; KEY[1] <= 0; KEY[0] <= 0;						repeat(1) @(posedge CLOCK_50);
		SW[9] <= 0; KEY[3] <= 0; KEY[2] <= 1; KEY[1] <= 0; KEY[0] <= 0;						repeat(1) @(posedge CLOCK_50);	//Odds are we've already died by this point. so let's reset next step
		SW[9] <= 1; KEY[3:0] <= 0; SW[4] <= 1; SW[3:0] <= 0;										repeat(1) @(posedge CLOCK_50);
		$stop;
	end
endmodule
		


