

module synch(
	input PS2Clk,
	input FPGAClk,
	input rst,
	output midout,
	output [5:0] count
	);
	
	reg clr;
	wire comp20;
	wire [5:0]cout;
	reg Q1;
	reg Q2;
	
	counter c(.clk(PS2Clk),.clr(Q2),.rst(rst),.count(cout));
	assign comp20 = (cout == 32) ? 1 : 0;
	assign count = cout;

	
	//FIRST REGISTER
	
	always @(posedge FPGAClk) begin
		if(FPGAClk)
			Q1 <= comp20;
		else 
			Q1 <= Q1;
	end
	
	assign midout = Q1;
	
	//SECOND REGISTER
	
	always @(posedge FPGAClk) begin
		if(FPGAClk)
			Q2 <= Q1;
		else
			Q2 <= Q2;
	end
	
	
endmodule

		
