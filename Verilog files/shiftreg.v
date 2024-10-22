

module shiftreg (
	input 		clk,
	input 		rst,
	input 		shren,
	input 		din,
	output [10:0] dout
	);

	reg [10:0] ShiftRegister;
	
	always @ (posedge clk or posedge rst) begin
		if (rst)	// Active High Reset (if Active Low is needed just negate ~rst)
			ShiftRegister <= 0;
		else if (shren)	// Shift Enable input
			ShiftRegister[10:0] <= {din,ShiftRegister[10:1]};
	end
	
	// Combinatorial Output, the output of the Right ShiftRegister is always the LSb
	assign dout = ShiftRegister[10:0];
	
endmodule
