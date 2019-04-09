module ASM (input clk,
	 input ssd_clk,
    input rst,
    input clr,
    input ent,
    input change,
	 output reg [4:0] led,
    input [3:0] sw,
	 output [3:0]AN,
	 output [6:0]seven_out
	 ); 


//registers
 reg [19:0] ssd;
 reg [15:0] password; 
 reg [15:0] inpassword;
 reg [5:0] current_state;
 reg islocked;
 reg [5:0] next_state;	
 
// parameters for States, you will need more states obviously
parameter IDLE = 5'b00000; //idle state 
parameter GETFIRSTDIGIT = 5'b00001; // get_first_input_state // this is not a must, one can use counter instead of having another step, design choice
parameter GETSECONDDIGIT = 5'b00010; //get_second input state
parameter GETTHIRDDIGIT = 5'b00011; //get_third input state
parameter GETFOURTHDIGIT = 5'b00100; //get_fourth input state

parameter NEWFIRSTDIGIT= 5'b00101;
parameter NEWSECONDDIGIT= 5'b00110;
parameter NEWTHIRDDIGIT= 5'b00111;
parameter NEWFOURTHDIGIT= 5'b01000;

parameter UNLOCKEDSTATE = 5'b01001;
parameter CHECKPASSWORD = 5'b01010;
parameter LOCKEDSTATE = 5'b01011;
parameter CLEAR = 5'b01100;



// parameters for output, you will need more obviously
parameter C=5'b01111; // you should decide on what should be the value of C, the answer depends on your binary_to_segment file implementation
parameter L=5'b01101; // same for L and for other guys, each of them 5 bit. IN ssd module you will provide 20 bit input, each 5 bit will be converted into 7 bit SSD in binary to segment file.
parameter S=5'b10011;
parameter d=5'b10100;
parameter O=5'b00000;
parameter P=5'b10010;
parameter E=5'b01110;
parameter n=5'b01100;
parameter dash=5'b10001;
parameter blank=5'b01010;
parameter zero = 1'b0;


	//Sequential part for state transitions to RESET
	always @ (posedge clk or posedge rst)
	begin
		// your code goes here
		if(rst==1)
			current_state<= IDLE;
		else
		current_state<= next_state;
		
	end

	//Combinational part - next state definitions
	always @ (*)
	begin
			if(current_state == IDLE)
			begin
				if(ent == 1)
					next_state = GETFIRSTDIGIT;
				else if(clr == 1)
					next_state = GETFIRSTDIGIT;
				else 
					next_state = current_state;			
			end
			
			else if (current_state == UNLOCKEDSTATE)
			begin
				if (ent == 1)
					next_state = GETFIRSTDIGIT;
				else if (change == 1)
					next_state = NEWFIRSTDIGIT;
				else
					next_state = current_state;
			end
			
			else if (current_state == LOCKEDSTATE)
			begin
				if (ent == 1)
					next_state = GETFIRSTDIGIT;
				else
					next_state = current_state;
			end
			
			else if (current_state == GETFIRSTDIGIT)
			begin
				if (ent == 1)
					next_state = GETSECONDDIGIT;
				else if(clr == 1)
					next_state = GETFIRSTDIGIT;
				else
					next_state = current_state;
			end

			else if (current_state == GETSECONDDIGIT)
			begin
				if (ent == 1)
					next_state = GETTHIRDDIGIT;
				else if(clr == 1)
					next_state = GETFIRSTDIGIT;
				else
					next_state = current_state;
			end

			else if (current_state == GETTHIRDDIGIT)
			begin
				if (ent == 1)
					next_state = GETFOURTHDIGIT;
				else if(clr == 1)
					next_state = GETFIRSTDIGIT;
				else
					next_state = current_state;
			end

			else if (current_state == GETFOURTHDIGIT)
			begin
				if (ent == 1)
					next_state = CHECKPASSWORD;
				else if(clr == 1)
					next_state = GETFIRSTDIGIT;
				else
					next_state = current_state;
			end
	
			//WHEN UNLOCKED STATE

			else if (current_state == NEWFIRSTDIGIT)
			begin
				if (ent == 1)
					next_state = NEWSECONDDIGIT;
				else if(clr == 1)
					next_state = NEWFIRSTDIGIT;
				else
					next_state = current_state;
			end

			else if (current_state == NEWSECONDDIGIT)
			begin
				if (ent == 1)
					next_state = NEWTHIRDDIGIT;
				else if(clr == 1)
					next_state = NEWFIRSTDIGIT;
				else
				next_state = current_state;
			end

			else if (current_state == NEWTHIRDDIGIT)
			begin
				if (ent == 1)
					next_state = NEWFOURTHDIGIT;
				else if(clr == 1)
					next_state = NEWFIRSTDIGIT;
				else
					next_state = current_state;
			end

			else if (current_state == NEWFOURTHDIGIT)
			begin
				if (ent == 1)
					next_state = LOCKEDSTATE;
				else if(clr == 1)
					next_state = NEWFIRSTDIGIT;
				else
					next_state = current_state;
			end
			
			//Checking password
			else if (current_state == CHECKPASSWORD)
			begin
				if (inpassword == password)
				begin
					if (islocked == 1)
						next_state = UNLOCKEDSTATE;
					else
						next_state = LOCKEDSTATE;					
				end	
				else
				begin
					if (islocked == 1)
						next_state = LOCKEDSTATE;
					else
						next_state = UNLOCKEDSTATE;
				end
			end
			
			else
				next_state = current_state;
				
	end
	 

	 //Sequential part for control registers, this part is responsible from assigning control registers or stored values
	always @ (posedge clk or posedge rst)
	begin
		if(rst)
		begin
			//inpassword[15:0]<=0; // password which is taken coming from user, 
			password[15:0]<=16'b0000000000000000;
			islocked <= 1;
		end

		else 
			if(current_state == IDLE)
			begin
			 	password[15:0] <= 16'b0000000000000000; 
			end
		
			else if(current_state == GETFIRSTDIGIT)
			begin
				if(ent==1)
					inpassword[15:12]<=sw[3:0]; // inpassword is the password entered by user, first 4 digin will be equal to current switch values
			end

			else if (current_state == GETSECONDDIGIT)
			begin

				if(ent==1)
					inpassword[11:8]<=sw[3:0]; // inpassword is the password entered by user, second 4 digit will be equal to current switch values
			end

			else if (current_state == GETTHIRDDIGIT)
			begin

				if(ent==1)
					inpassword[7:4]<=sw[3:0]; // inpassword is the password entered by user, second 4 digit will be equal to current switch values
			end

			else if (current_state == GETFOURTHDIGIT)
			begin
				if(ent==1)
					inpassword[3:0]<=sw[3:0]; // inpassword is the password entered by user, second 4 digit will be equal to current switch values
			end
			
			else if (current_state == LOCKEDSTATE || current_state == IDLE)
			begin
				islocked <= 1;
			end
			
			else if (current_state == UNLOCKEDSTATE)
			begin
				islocked <= 0;
			end
			
			else if(current_state == NEWFIRSTDIGIT)
			begin
				if(ent==1)
					password[15:12]<=sw[3:0];
			end

			else if (current_state == NEWSECONDDIGIT)
			begin
				if(ent==1)
					password[11:8]<=sw[3:0];
			end

			else if (current_state == NEWTHIRDDIGIT)
			begin
				if(ent==1)
					password[7:4]<=sw[3:0];
			end

			else if (current_state == NEWFOURTHDIGIT)
			begin
				if(ent==1)
					password[3:0]<=sw[3:0];
			end
	end

	// Sequential part for outputs; this part is responsible from outputs; i.e. SSD and LEDS
	always @(posedge clk)
	begin

		if(current_state == IDLE)
		begin
		ssd <= {C, L, S, d};	//CLSD
		led <= IDLE;
		end

		else if(current_state == GETFIRSTDIGIT)
		begin
		ssd <= { zero,sw[3:0], blank, blank, blank};	
		led <= GETFIRSTDIGIT;
		end

		else if(current_state == GETSECONDDIGIT)
		begin
		ssd <= { dash,zero,sw[3:0], blank, blank};
		led <= GETSECONDDIGIT;
		end

		else if(current_state == GETTHIRDDIGIT)
		begin
		ssd <= { dash , dash,zero,sw[3:0], blank};
		led <= GETTHIRDDIGIT;
		end

		else if(current_state == GETFOURTHDIGIT)
		begin
		ssd <= { dash , dash, dash,zero,sw[3:0]};
		led <= GETFOURTHDIGIT;
		end

		else if(current_state == NEWFIRSTDIGIT)
		begin
		ssd <= { zero, sw[3:0], blank, blank, blank};	// you should modify this part slightly to blink it with 1Hz. The 0 is at the beginning is to complete 4bit SW values to 5 bit.
		led <= NEWFIRSTDIGIT;
		end

		else if(current_state == NEWSECONDDIGIT)
		begin
		ssd <= {zero,password[15:12], zero,sw[3:0], blank, blank};	// you should modify this part slightly to blink it with 1Hz. 0 after tire is to complete 4 bit sw to 5 bit. Padding 4 bit sw with 0 in other words.	
		led <= NEWSECONDDIGIT;
		end

		else if(current_state == NEWTHIRDDIGIT)
		begin
		ssd <= { zero,password[15:12] , zero, password[11:8], zero,sw[3:0], blank};	
		led <= NEWTHIRDDIGIT;
		end

		else if(current_state == NEWFOURTHDIGIT)
		begin
		ssd <= { zero,password[15:12] , zero, password[11:8], zero, password[7:4], zero,sw[3:0]};
		led <= NEWFOURTHDIGIT;
		end

		else if(current_state == UNLOCKEDSTATE)
		begin
		ssd <= {O, P, E, n};
		led <= UNLOCKEDSTATE;		
		end

		else if(current_state == LOCKEDSTATE)
		begin
		ssd <= {C, L, S, d};	
		led <= LOCKEDSTATE;			
		end

	end


	//Print to SSD
    seven_segment SSD(ssd_clk, ssd, AN, seven_out);

endmodule