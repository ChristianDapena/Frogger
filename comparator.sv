module comparator( A, B, bool);
	input logic [9:0] A;
	input logic [9:0] B;
	output logic bool;
	

	always_comb begin
		bool = 1'b0;
		for(int i = 9; i >= 0; i--) begin
			if(A[i] < B[i]) begin
				bool = 1;
				break;
			end
			else if((A[i] > B[i])) begin
				break;
			end
		end
	end
endmodule



module comparator_Testbench();
	logic [9:0] A, B;
	logic bool;
	
	comparator dut (.A(A), .B(B), .bool(bool));
	
	initial begin
		A = 10'b1011001011; B = 10'b0101010101;		#10; // A > B
		A = 10'b0010000100; B = 10'b1001001011;		#10; // A < B
		A = 10'b0101011100; B = 10'b0101011100;		#10; // A = B
		
		A = 10'b0000000000; B = 10'b0000000000;		#10; // A = B = 0
		A = 10'b1111111111; B = 10'b1111111111;		#10; // A = B = Max num
		A = 10'b1111111111; B = 10'b0000000000;		#10; // A = Max, B = Min
		A = 10'b0000000000; B = 10'b1111111111;		#10; // A = Min, B = Max
		$stop;
	end
endmodule
	
				
	