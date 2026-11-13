module count_cars(cars, num_cars);
	input logic [15:0] cars;
	output logic [4:0] num_cars;
	
	int cars_counted;
	always_comb begin
		cars_counted = 0;
		for(int i = 0; i < 16; i++)
			cars_counted = cars_counted + cars[i];
		num_cars = cars_counted;
	end
endmodule 