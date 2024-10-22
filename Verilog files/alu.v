

module alu (
	 input [15:0] a,
	 input [15:0] b,
	 input [15:0] op,
	 output reg [15:0] r
);	

parameter ALU_ADD = 16'd11, ALU_SUB = 16'd12, ALU_MULT = 16'd13, ALU_DIV = 16'd14;

always @ (*) begin
			case(op)
			
			ALU_ADD: begin
				r = a + b;
			end	
			ALU_SUB: begin
				r = a - b;
			end
			ALU_MULT: begin
				r = a * b;
			end
			ALU_DIV: begin
				r = a / b;
			end
				
			default: begin
				r = 8'bx;
			end
			endcase
	end

endmodule
