`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:11:06 04/07/2016 
// Design Name: 
// Module Name:    seven_segment 
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
module seven_segment(
    input clk,
	 input [19:0] big_bin, 
	 output reg [3:0]AN,
	 output [6:0]seven_out
    );
	
	reg [4:0] seven_in;
	reg [1:0] count;
	
	initial begin
		AN = 4'b1110;
		seven_in = 0;
		count = 0;
	end

	always @(posedge clk) 
	begin
		count <= count + 1;
		case (count)
	 	0: begin 
			AN <= 4'b1110;
			seven_in <= big_bin[4:0];
	 	end
	 
	 	1: begin 
			AN <= 4'b1101;
			seven_in <= big_bin[9:5];
			
		end

		2: begin 
			AN <= 4'b1011;
			seven_in <= big_bin[14:10];
					
		end

		3: begin 
			AN <= 4'b0111;
			seven_in <= big_bin[19:15];
		end
		endcase
	end

	binary_to_segment disp0(seven_in,seven_out);

endmodule
