module userInput(in, CLK, out);
	input logic in, CLK;
	output logic out;
	
	logic prevCycle;
	
	always_ff @(posedge CLK) begin
		prevCycle <= in;
		out <= in & ~prevCycle;
	end
	
endmodule
	


module userInput_Testbench();
	logic in, CLK, out;
	

	userInput dut (.in(in), .CLK(CLK), .out(out));
	parameter CLOCK_PERIOD=100;

	
	initial begin
		CLK <= 0;
		forever #(CLOCK_PERIOD/2) CLK <= ~CLK; // Forever toggle the clock
	end
	
	initial begin
		in <= 0; 		repeat(2) @(posedge CLK);
		in <= 1;		repeat(4) @(posedge CLK);
		in <= 0;		repeat(2) @(posedge CLK);
		in <= 1;		repeat(4) @(posedge CLK);
		in <= 0;		repeat(2) @(posedge CLK);
		
		$stop;
	end
	
endmodule