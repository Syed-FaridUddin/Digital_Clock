module TopLevelModule(
	input clk, //100KHz
	input reset,
	input clkGenRst,
	input set,
	input [7:0]hr,
	input [7:0]min,
	input [7:0]sec,	
	input dayNight,	// '1' = day '0' = night //
	output AM,
	output [23:0]digi_clock
);
	// reg digi_clock_reg;
	reg AM_reg;
	assign AM = AM_reg;
	// assign digi_clock = digi_clock_reg;
	
	
	reg  [7:0]hr_setValue;
	reg  [7:0]min_setValue;
	reg  [7:0]sec_setValue;
	
	
	wire [7:0]hr_bcd;
	wire [7:0]min_bcd;
	wire [7:0]sec_bcd;
	
	
	reg hr_enable;
	reg min_enable;
	reg sec_enable;
	
	wire one_Hz; //1Hz
	
	assign digi_clock = {hr_bcd, min_bcd, sec_bcd};
	
	// We can give input {hr,min,sec} but it only reflects at digi_clock when we press set.
	// Inputs {hr,min,sec} should be changed first and then set should be pressed.
	always @ (posedge set, posedge reset, posedge one_Hz) begin 
		if (set) begin
			hr_setValue  <= hr;
			min_setValue <= min;
			sec_setValue <= sec;
			
			AM_reg		 <= dayNight;
		end
		else if (reset) begin // reset is a special case of set where DigitalClock sets to  11:59:59 PM
			hr_setValue  <= 8'b00010001; 
			min_setValue <= 8'b01011001; 
			sec_setValue <= 8'b01011001; 
			
			AM_reg		 <= 1'b0;			
		end
		else begin
			hr_setValue  <= hr_setValue;
			min_setValue <= min_setValue;
			sec_setValue <= sec_setValue;
			
			if (digi_clock == {8'b00010001,8'b01011001,8'b01011001}) begin //11:59:59
				AM_reg <= ~ AM_reg;
			end
			else begin
				AM_reg <= AM_reg;
			end			
		end
	end
	
	
	////////// Enable signals
	
	
	
	always @ (*) begin
		sec_enable = ~(set | reset);
	end
	
	always @ (*) begin
		if (sec_bcd == 8'b01011001) begin// 59
			min_enable = 1'b1;
		end
		else begin
			min_enable = 1'b0;
		end
	end
	
	always @ (*) begin
		if ((sec_bcd == 8'b01011001)&&(min_bcd == 8'b01011001)) begin// 59
			hr_enable = 1'b1;
		end
		else begin
			hr_enable = 1'b0;
		end
	end
	
	//////////////// Slow Clock generator
	ClockFreqDevider ClockGen(
				 .f_clk(clk), //100KHz
				 .reset(clkGenRst), // no need to reset clock generator
				 .one_Hz(one_Hz) // 1Hz
			);
	
	//////////////// counters
	
	
	CounterBCD HOUR(
				.clk(one_Hz),
				.set(set|reset),
				.enable(hr_enable),
				.iniValue(8'b00000001), //always fixed to 1
				.setValue(hr_setValue),
				.rollBackVal(8'b00010010), // always fixed to 12.
				.bcd(hr_bcd)
			);
			
	CounterBCD MIN(
				.clk(one_Hz),
				.set(set|reset),
				.enable(min_enable),
				.iniValue(8'b0), // always fixed to 0.
				.setValue(min_setValue),
				.rollBackVal(8'b01011001), // always fixed to 59.
				.bcd(min_bcd)
			);
			
	CounterBCD SEC(
				.clk(one_Hz),
				.set(set|reset),
				.enable(sec_enable),
				.iniValue(0), // always fixed to 0.
				.setValue(sec_setValue),
				.rollBackVal(8'b01011001), // always fixed to 59.
				.bcd(sec_bcd)
			);
	

endmodule