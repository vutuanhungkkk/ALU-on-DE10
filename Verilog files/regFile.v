

module regFile(
   input rst,
	input del,
	input [7:0] writeData,
	input writeEnable,
	input [3:0] readAddress1,
	input [3:0] writeAddress,
	input clk,
   output [7:0] readData1,
	output [7:0] readData2,
	output [7:0] readData3
 	);
 	
  reg[7:0] register[5:0];
 
  always @ (posedge clk)
   begin
		if(writeEnable)
			begin
				register[writeAddress] = writeData;
			end
		else if (rst)
			begin
				register[0] = 0;
				register[1] = 0;
				register[2] = 0;
				register[3] = 0;
				register[4] = 0;
				register[5] = 0;
				
			end
   end
  
  assign readData1 = register[0];
  assign readData2 = register[1];
  assign readData3 = register[2];
	
endmodule
