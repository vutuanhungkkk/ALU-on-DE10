
module reg8(
   input rst,
	input [7:0] D,
	input writeEnable,
	input clk,
   output reg [16:0] Q
 	);
 	

  always @ (posedge clk)
   begin
		if(writeEnable)
			begin
				Q <= D;
			end
		else if (rst)
			begin
				Q <= 0;
				
			end
   end
	
endmodule
