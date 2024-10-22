
module decoder(
					input [7:0]in,
					output reg [6:0]outSeg,
					output reg [7:0]key_detect);

always @ (*)
	begin 
		key_detect = 8'd0;
		case (in)
		8'h69: begin
		
		outSeg = 7'b1111001;//1
		key_detect = 8'd1;	//1
		end
		8'h72: begin
		outSeg = 7'b0100100;//2
		key_detect = 8'd2;	//2
		end
		8'h7A: begin
		outSeg = 7'b0110000;//3
		key_detect = 8'd3;	//3
		end
		8'h6B: begin
		outSeg = 7'b0011001;//4
		key_detect = 8'd4;	//4
		end
		8'h73: begin
		outSeg = 7'b0010010;//5
		key_detect = 8'd5;	//5
		end
		8'h74: begin
		outSeg = 7'b0000010;//6
		key_detect = 8'd6;	//6
		end
		8'h6C: begin
		outSeg = 7'b1111000;//7
		key_detect = 8'd7;	//7
		end
		8'h75: begin
		outSeg = 7'b0000000;//8
		key_detect = 8'd8;	//8
		end
		8'h7D: begin
		outSeg = 7'b0010000;//9
		key_detect = 8'd9;	//9
		end
		8'h70: begin
		outSeg = 7'b1000000;//0
		key_detect = 8'd0;	//0
		end
		
		8'h79: begin
		outSeg = 7'b0111001;//+
		key_detect = 8'd11;	//+
		end
		
		8'h7B: begin
		outSeg = 7'b0111111;//-
		key_detect = 8'd12;	//-
		end
		
		8'h7C: begin
		outSeg = 7'b0001001;//*
		key_detect = 8'd13;	//*
		end
		
		8'h4A: begin
		outSeg = 7'b0100001;// div
		key_detect = 8'd14;	// div
		end
		
		8'h71: begin
		outSeg = 7'b1111111;//delete
		key_detect = 8'd15;	//delete
		end
		
		8'h5A: begin
		outSeg = 7'b0000110;//Enter
		key_detect = 8'd16;	//Enter
		end
		
		8'h66: begin
		outSeg = 7'b0000111;// Delete all
		key_detect = 8'd17;	// Delete all
		end
		
		8'h15: outSeg = 7'b0011000;//Q
		8'h1D: outSeg = 7'b0111111;//W
		8'h24: outSeg = 7'b0000110;//E
		8'h2D: outSeg = 7'b0101111;//R
		8'h2C: outSeg = 7'b0000111;//T
		8'h35: outSeg = 7'b0010001;//Y
		8'h3C: outSeg = 7'b1000001;//U
		8'h43: outSeg = 7'b1111001;//I
		8'h44: outSeg = 7'b0100011;//O
		8'h4D: outSeg = 7'b0001100;//P
		8'h1C: outSeg = 7'b0001000;//A
		8'h1B: outSeg = 7'b0010010;//S
		8'h23: outSeg = 7'b0100001;//D
		8'h2B: outSeg = 7'b0001110;//F
		8'h34: outSeg = 7'b0010000;//G
		8'h33: outSeg = 7'b0001001;//H
		8'h3B: outSeg = 7'b1100001;//J
		8'h42: outSeg = 7'b0111111;//K
		8'h4B: outSeg = 7'b1000111;//L
		8'h1A: outSeg = 7'b0111111;//Z
		8'h22: outSeg = 7'b0111111;//X
		8'h21: outSeg = 7'b1000110;//C
		8'h2A: outSeg = 7'b1100011;//V
		8'h32: outSeg = 7'b0000011;//B
		8'h31: outSeg = 7'b0101011;//N
		8'h3A: outSeg = 7'b0111111;//M
		
		default: begin
		key_detect=8'd0;
		outSeg = 7'b1111111;
		end
		endcase
	end
	
endmodule
