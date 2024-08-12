module TB_CounterBCD ();
	
	reg  clk, reset, set, enable;
	reg  [7:0]iniValue, setValue, rollBackVal;
	wire [7:0]bcd;
	CounterBCD UUT(
				 clk,
				 reset,
				 set,
				 enable,
				 iniValue,
				 setValue,
				 rollBackVal,
				 bcd
				);
				
	initial begin
	
	//****************** Hour
		clk = 1'b0; reset = 1'b0; set = 1'b0; enable = 1'b0; iniValue = 8'd1; setValue = 8'b00000101; rollBackVal = 8'b00010010;//(18)10
		#3  reset  = 1'b1; 
		#5  enable = 1'b1;
		#10 reset  = 1'b0;
		
		#100 set = 1'b1;		
		#50  set = 1'b0;
		
		#60 enable = 1'b0;
		#20 enable = 1'b1;
		
		#200 reset = 1'b1;
		#30  reset = 1'b0;
		
		
	//****************** Min & sec		
		// clk = 1'b0; reset = 1'b0; iniValue = 8'd0; rollBackVal = 8'b01011001; //59
		// #3  reset = 1'b1;
		// #10 reset = 1'b0;
		
		// #800 reset = 1'b1;
		// #30  reset = 1'b0;
	end
	
	always clk = #5 ~clk;

endmodule