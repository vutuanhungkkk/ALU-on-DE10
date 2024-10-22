
module ps2_7segment(
	input PS2Clk,
	input FPGAClk,
	input rst,
	input datain,
	output [6:0] SEG1,
	output [6:0] SEG2,
	output [6:0] SEG3,
	output [6:0] SEG4,
	output [6:0] SEG5,
	output [6:0] SEG6,
	output [7:0] key,
	output [15:0] a,
	output [15:0] b,
	output [15:0] r,
	output [15:0] operator,
	output done,
	output shift
	);
	
	reg Qreg; //enable register before f0
	reg Qreg2; //
	reg [10:0] Q; //output register of the 1st shift
	reg [7:0] Qseg; //output of register after f0 comp
	reg clrCounter; // clear of counter module
	reg [5:0] QSynch; //output synchronizer module
	
	wire [15:0] a_w;
	wire [15:0] b_w;
	wire [15:0] r_w;
	wire [15:0] op_code;
	wire done_w;
	wire [3:0] add;
	
	wire [15:0] a_w1 = 16'd8;
	wire [15:0] b_w1 = 16'd9;
	wire [15:0] op_code1 = 16'd12;
	
	wire comp0a; //output of comparator 0a(10)
	wire compf0; //output of comparator f0(240)
	wire [5:0] count; //output of counter module
	wire [10:0] D; //input register of the 1st shift
	wire [7:0] D1;
	wire [5:0] DSynch; //input synchronizer module
	wire [5:0] seg7;
	wire [7:0] data;
	
	wire comp21;
	wire midout; //
	wire [5:0] countSynch;
	wire [7:0] key_detect;
	wire [7:0] key_detect1;
	wire [7:0] key_detect2;
	wire [7:0] key_detect_op;

	wire [7:0] key_detect3;
	wire [7:0] key_detect4;
	wire [7:0] key_detect5;
	
	wire [7:0] key_detect6;
	wire [7:0] key_detect7;
	wire [7:0] key_detect8;
	
	wire [7:0] key_detect20;
	
	wire [7:0]segments0;
	wire [7:0]segments1;
	wire [7:0]segments2;
	wire [7:0]segments3;
	wire [7:0]segments4;
	wire [7:0]segments5;
	wire [3:0]count1;
	wire [3:0]count2;
	wire [7:0]operator_w;
	
	assign key = Qseg;
	assign clk2 = FPGAClk;
	assign shift = midout;
	
	shiftreg sr1(.clk(~PS2Clk),.rst(~rst),.shren(1),.din(datain),.dout(D));
	assign D1 =  Q[8:1];
	counter c(.clk(PS2Clk),.clr(clrCounter),.rst(~rst),.count(count));
	assign comp0a = (count == 10) ? 1 : 0;
	
	//2 registers (for synchronize)
	always @(posedge FPGAClk) begin
		if(FPGAClk)
			Qreg <= comp0a;
		else 
			Qreg <= Qreg;
	end
	
	
	always @(posedge FPGAClk) begin
		if(FPGAClk)
			clrCounter <= Qreg;
		else
			clrCounter <= clrCounter;
	end
	
	//synch module 
	synch s(.PS2Clk(PS2Clk),.FPGAClk(FPGAClk),.rst(~rst),.midout(midout),.count(countSynch));
	
	
	//Register before f0 comparator
	assign comp21 = (countSynch == 33) ? 1 : 0;
	
	always @ (negedge Qreg) begin
		
		if(comp21)
			Q <= 0;
		else
			Q <= D;
	end
	
	assign compf0 = (D1 != 240) ? 1 : 0;
	
	reg [8:0] keycount = 0;
	
	//register after f0
	always @(posedge FPGAClk) begin
		if(compf0) begin
			Qseg <= D1;
			keycount <= keycount + 1;
			end
		else begin
			Qseg <= Qseg;
			keycount <= 0;
	end
	end
	
	// Shift register for 7 segment 
	
	shiftreg2 s2(.clk(FPGAClk),.data(Qseg),.rst(~rst),.c(),.del(delete),.shren(midout),.dout0(segments0),.dout1(segments1),.dout2(segments2),.dout3(segments3),.dout4(segments4),.dout5(segments5));
	
	counter_3b c1(.key_pressed(midout),.rst(delete),.count(count1));  // counter to determine the number of digits (a)
	
	
	counter_3b c2(.key_pressed(midout),.rst(delete),.count(count2));  // counter to determine the number of digits (b)
	
	// Decoders for 7 segment
	
	decoder d1(.in(segments0),.outSeg(SEG1),.key_detect());
	decoder d2(.in(segments1),.outSeg(SEG2),.key_detect());
	decoder d3(.in(segments2),.outSeg(SEG3),.key_detect());
	decoder d4(.in(segments3),.outSeg(SEG4),.key_detect());
	decoder d5(.in(segments4),.outSeg(SEG5),.key_detect());
	decoder d6(.in(segments5),.outSeg(SEG6),.key_detect());
	
	// Decoder for Alu
	
	decoder d7(.in(Qseg),.outSeg(),.key_detect(key_detect3));
	decoder d8(.in(Qseg),.outSeg(),.key_detect(key_detect4));
	decoder d9(.in(Qseg),.outSeg(),.key_detect(key_detect5));
	decoder d10(.in(Qseg),.outSeg(),.key_detect(key_detect20));
	
	// system flags
	
	wire op_det;
	wire op, delete, go;
	assign op = (key_detect3 == 8'd11 || key_detect3 == 8'd12 || key_detect3 == 8'd13 || key_detect3 == 8'd14) ? 1 : 0;
	assign go = (key_detect20 == 8'd16) ? 1 : 0;
	assign delete = (key_detect5 == 8'd15) ? 1 : 0;

	
	// Register files for operand a and b

	regFile rF(.rst(rst),.del(delete),.writeData(key_detect4),.writeEnable(1),.readAddress1(add),.writeAddress(count1),.clk(FPGAClk),.readData1(key_detect),.readData2(key_detect1),.readData3(key_detect2));

	regFile rF2(.rst(rst),.del(delete),.writeData(key_detect4),.writeEnable(1),.readAddress1(add),.writeAddress(count2),.clk(FPGAClk),.readData1(key_detect6),.readData2(key_detect7),.readData3(key_detect8));
	

	// Generate the operands, up to 3 digits
	
	operands op_a(.data(key_detect),.data1(key_detect1),.data2(key_detect2),.FPGAClk(FPGAClk),.op(op),.digits(count1),.a(a_w));
	
	operands op_b(.data(key_detect6),.data1(key_detect7),.data2(key_detect8),.FPGAClk(FPGAClk),.op(go),.digits(count2),.a(b_w));
	
	
	// Store the opcode
	
	reg8 r1(.rst(),.D(key_detect3),.writeEnable(op),.clk(FPGAClk),.Q(operator_w));
	
	// ALU
	
	alu a1(.a(a_w),.b(b_w),.op(operator_w),.r(r_w));
	
	assign a = a_w;
	assign b = b_w;
	assign r = r_w;
	assign operator = operator_w;
	assign done = go;

	assign scanCode = Q[8:1];
	
	
endmodule
