`timescale 1us/1us
module TB_ClockFreqDevider ();
	
	reg f_clk, reset;
	wire one_Hz;
	ClockFreqDevider UUT(
					 f_clk, //100KHz => T = 10us
					 reset,
					 one_Hz // 1Hz
				);
				
	initial begin
		f_clk = 1'b0; reset = 1'b0;
		#5  reset = 1'b1;
		#15 reset = 1'b0;
	end
	
	always f_clk = #5 ~f_clk;
	

endmodule