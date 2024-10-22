
// Converts the keyboard input digits into numbers up to 3 digits

module operands(
input [7:0] data, // 1st digit
input [7:0] data1,// 2nd digit
input [7:0] data2,// 3rd digit
input FPGAClk,
input op,
input [2:0] digits,
output reg [15:0] a
);


	always @(posedge FPGAClk) begin
		if(op) begin
		
			case(digits)
			
			3'd2: begin
				a <= (data*16'd1); // 1 digit
			end
			3'd3: begin
				a <= (data*16'd10) + (data1*16'd1) + (data2*16'd0); // 2 digits
			end
			3'd4: begin
				a <= (data*16'd100) + (data1*16'd10) + (data2*16'd1); // 3 digits
			end
			
			default: a <= a;
			endcase
			
		end

		else begin
			a <= a;
	end
	end
	
endmodule	
