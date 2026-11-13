module inSync (in, CLK, out);
	input logic in, CLK;
	output logic out;
	
	logic synchronized;
	
	always_ff @(posedge CLK) begin
		synchronized <= in;
		out <= synchronized;
	end
endmodule



module inSync_Testbench();
	logic in, CLK, out;
	
	inSync dut(.in(in), .CLK(CLK), .out(out));
	
	parameter CLOCK_PERIOD=100;

	
	initial begin
		CLK <= 0;
		forever #(CLOCK_PERIOD/2) CLK <= ~CLK; // Forever toggle the clock
	end
	
	initial begin
		in <= 0; 	repeat(4) @(posedge CLK);
		in <= 1;		repeat(4) @(posedge CLK);
		in <= 0;		repeat(4) @(posedge CLK);
		in <= 1;		repeat(4) @(posedge CLK);
		in <= 0;		repeat(4) @(posedge CLK);
		
		$stop;
	end
	
endmodule