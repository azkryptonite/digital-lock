module topmodule(input clk_in,
    input rst,
    input clr,
    input ent,
    input chg,
	 output [4:0]led,
	 output [3:0]AN,
    input [3:0]sw,
	 output [6:0]seven_out
    ); 
	
	wire clk_out1, clk_out2, clk_out3, clear, enter, change;

    //Initialize clock and buttons
    clk_divider1k clock1k(clk_in, rst, clk_out1);

    clk_divider10M  clock10M(clk_in, rst, clk_out2);
    clk_divider240 clock240(clk_in, rst, clk_out3);
	 
    debouncer clear1(clk_out2, rst, clr, clear);
    debouncer enter1(clk_out2, rst, ent, enter);
    debouncer change1(clk_out2, rst, chg, change);

    //Implement the asm module
    ASM ASMmodule(clk_out2, clk_out1, rst, clear, enter, change, led, sw, AN, seven_out);

    


endmodule