module LSFR(CLK, out, reset_code, Reset);
	input logic CLK, Reset;
	input logic [9:0] reset_code;
	output logic [9:0] out;
	

	always_ff @(posedge CLK) begin
		if(Reset)
			out <= reset_code;
		else begin
			out[0] <= (out[9] & out[6]) | (~out[9] & ~out[6]);
			out[1] <= out[0];
			out[2] <= out[1];
			out[3] <= out[2];
			out[4] <= out[3];
			out[5] <= out[4];
			out[6] <= out[5];
			out[7] <= out[6];
			out[8] <= out[7];
			out[9] <= out[8];
		end
	end
endmodule
	
	
module LSFR_Testbench();
	logic CLK, Reset;
	logic [9:0] out, reset_code;
	
	LSFR dut(.CLK(CLK), .out(out), .reset_code(reset_code), .Reset(Reset));
	
	
	parameter CLOCK_PERIOD=100;
	initial begin
		CLK <= 0;
		forever #(CLOCK_PERIOD/2) CLK <= ~CLK; // Forever toggle the clock
	end
	
	assign reset_code = 10'b0000000000;
	initial begin
		Reset <= 1;				repeat(5)  @(posedge CLK);
		Reset <= 0;				repeat(20) @(posedge CLK);
		Reset <= 1;				repeat(5)  @(posedge CLK);
		Reset <= 0;				repeat(10) @(posedge CLK);
		$stop;
	end
endmodule
		