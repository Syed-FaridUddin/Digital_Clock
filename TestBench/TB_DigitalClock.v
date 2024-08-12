/*
	******************************** R E S E T ******************************************
	While starting the clock once we power it, we require to do TWO reset or TWO set.
	
	This is bc, in the first reset/set :xxx_setValues are initialized (based on reset/set) but,
	For the CounterBCD gets set to 8'bz and the entire DigitalClock output goes to Hi-z.
	
	In the second reset, the earlier initilized value gets to the DigitalClock output and everything
	runs smoothy from there.
	***************************************************************************************
	
	******************************** S E T ******************************************	
	First set the value of xxx_setValues and then hit Set.
	This way set will not require two steps.
	Bc, we are initilizing xxx_setValues mannually.
*/

`timescale 1us/1us // 1us is used here to simulate f_clk
module TB_TopLevelModule();
	
	reg clk, reset, clkGenRst, set;
	reg [7:0]hr, min, sec;
	reg dayNight;
	wire AM;
	wire [23:0] digi_clock;
	TopLevelModule	UUT(
					 clk,
					 reset,
					 clkGenRst,
					 set,
					 hr,
					 min,
					 sec,	
					 dayNight,	// '1' = day '0' = night //
					 AM,
					 digi_clock
				);
				
	initial begin
		clk = 1'b0; reset = 1'b0; clkGenRst = 1'b0; set = 1'b0;
		//************************
		//*****compulsory two reset****//
		#10 clkGenRst 	= 1'b1;
		#5  clkGenRst 	= 1'b0;
		#15 reset 		= 1'b1;
		#10 reset 		= 1'b0;		
		#15 reset 		= 1'b1;
		#10 reset 		= 1'b0;
		//************************
		// setting to 6:40:30 AM
		// #5 hr = 8'b00000110;  min = 8'b01000000; sec = 8'b00110000; dayNight = 1'b0;
		// #10 set = 1'b1;
		// #50 set = 1'b0;
		
		// #15 reset = 1'b1;
		// #10 reset = 1'b0;
	end
	
	always clk = #5 ~clk;
	

endmodule