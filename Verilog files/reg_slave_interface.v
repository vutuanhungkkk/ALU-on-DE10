

// Registers interface to communicate between the FPGA and the HPS 

module reg_slave_interface(
	input clk, 
   input rst,
	input writeEnable,
	input [15:0] a, // operand a
	input [15:0] b, // operand b
	input [15:0] op_code, // operation opcode
	input [15:0] r, // result
	input [15:0] status, // status flag
	input [3:0] readAddress,
   output [15:0] readData // data output
 	);
 	
  reg[15:0] register[4:0];
 
  always @ (posedge clk)
   begin
		if(writeEnable)
			begin
				register[0] = a;
				register[1] = b;
				register[2] = op_code;
				register[3] = r;
				register[4] = status;
			end
		else if (rst)
			begin
				register[0] = 0;
				register[1] = 0;
				register[2] = 0;
				register[3] = 0;
				register[4] = 0;
				
			end
   end
  
  assign readData = register[readAddress];
	
endmodule
