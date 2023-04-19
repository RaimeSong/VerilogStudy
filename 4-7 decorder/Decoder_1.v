module Decoder_1(in,out);

input 	[3:0] in;
output   [8:0] out ;

reg [8:0] out ;

always @(*)  begin
	case (in )
	4'b0000 : out = 7'b000111111; 	// 0
	4'b0001 : out = 7'b000000110; 	// 1
	4'b0010 : out = 7'b001011011; 	// 2
	4'b0011 : out = 7'b001001111; 	// 3
	4'b0100 : out = 7'b001100110; 	// 4
	4'b0101 : out = 7'b001101101; 	// 5
	4'b0110 : out = 7'b001111101; 	// 6
	4'b0111 : out = 7'b000000111; 	// 7
	4'b1000 : out = 7'b001111111; 	// 8
	4'b1001 : out = 7'b001100111; 	// 9
	4'b1010 : out = 7'b001110111; 	// A
	4'b1011 : out = 7'b001111100; 	// b
	4'b1100 : out = 7'b000111001; 	// C
	4'b1101 : out = 7'b001011110; 	// d
	4'b1110 : out = 7'b001111001; 	// E
	4'b1111 : out = 7'b001110001; 	// F
	default : out = 7'b000000000;
	
	endcase
	end
endmodule
