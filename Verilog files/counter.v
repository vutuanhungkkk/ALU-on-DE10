module counter(
	input clk,
	input clr,
	input rst,
	output [6:0] count
	);
	
	wire [5:0] D;
	reg[5:0] Q;
	
	always @(negedge clk or posedge rst) begin
		if(rst)
			Q <= 0;
		else if(clr)
			Q <= 0;
		else if(~clk)
			Q <= Q + 1;
	end
	
	assign count = Q;
	
endmodule
