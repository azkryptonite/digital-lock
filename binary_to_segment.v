`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    
// Design Name: 
// Module Name:    binary_to_segment 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module binary_to_segment(
    input [4:0] binary_in,
    output reg [6:0] seven_out
    );

always @(binary_in)
begin
	case(binary_in)								//1 means off and 0 means on
		5'b00000: seven_out =7'b0000001;			// O
		5'b00001: seven_out =7'b1001111;			// 1 or I
		5'b00010: seven_out =7'b0010010;			// 2
		5'b00011: seven_out =7'b0000110;			// 3
		5'b00100: seven_out =7'b1001100;			// 4
		5'b00101: seven_out =7'b0100100;			// 5
		5'b00110: seven_out =7'b0100000;			// 6
		5'b00111: seven_out =7'b0001111;			// 7
		5'b01000: seven_out =7'b0000000;			// 8
		5'b01001: seven_out =7'b0000100;			// 9
		5'b01010: seven_out =7'b0001000;			// A
		5'b01011: seven_out =7'b1100000;			// B
		5'b01100: seven_out =7'b0110001;			// C
		5'b01101: seven_out =7'b1000010;			// D
		5'b01110: seven_out =7'b0110000;			// E
		5'b01111: seven_out =7'b0111000;			// F
		5'b10000: seven_out =7'b1110000; 		// t
		5'b10001: seven_out =7'b1111110;			// -
		5'b10010: seven_out =7'b0011000;			// P
		5'b10011: seven_out =7'b0100100;			// S
		5'b10100: seven_out =7'b1000010;       // d
		5'b10101: seven_out =7'b0110001;			// C
		5'b10110: seven_out =7'b1111111;			// OFF status, for 2 middle 7-segments
		5'b10111: seven_out =7'b1000001;			// U or V
		5'b11000: seven_out =7'b1101010;			// n
		5'b11001: seven_out =7'b1110001;			// L

		default: seven_out = 7'h1;
	endcase
end


endmodule
