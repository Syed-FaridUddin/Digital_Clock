module ClockFreqDevider (
	input f_clk, //100KHz
	input reset,
	output one_Hz // 1Hz
);
	reg enable_UUT0;
	wire [7:0]count_UUT0;
	
	reg enable_UUT1;
	wire [7:0]count_UUT1;
	
	reg enable_UUT2;
	wire [7:0]count_UUT2;
	
	reg one_Hz_reg;
	assign one_Hz = one_Hz_reg;
	
	always @ (*) begin
		if (reset) begin
			enable_UUT0 = 1'b0;
		end
		else begin
			enable_UUT0 = 1'b1;
		end
	end
	
	always @ (*) begin
		if (reset) begin
			enable_UUT1 = 1'b0;
		end
		else begin
			if (count_UUT0 == 8'b10011001) begin
				enable_UUT1 = 1'b1;
			end
			else begin
				enable_UUT1 = 1'b0;
			end 
		end
	end
	
	always @ (*) begin
		if (reset) begin
			enable_UUT2 = 1'b0;
		end
		else begin
			if ((count_UUT0 == 8'b10011001) && (count_UUT1 == 8'b10011001)) begin
				enable_UUT2 = 1'b1;
			end
			else begin
				enable_UUT2 = 1'b0;
			end 
		end
	end
	
	//assign one_Hz = ((count_UUT0 == 8'b10011001) && (count_UUT1 == 8'b10011001) && (count_UUT2 == 8'b00001001)) ? 1'b1:1'b0;
	always @ (*) begin
		if (count_UUT2 < 8'b00000101) begin
			one_Hz_reg = 1'b0;
		end
		else begin
			one_Hz_reg = 1'b1; 
		end
	end
	
	
	CounterBCD UUT0(
				.clk(f_clk),
				.set(reset),
				.enable(enable_UUT0),
				.iniValue(8'b0),
				.setValue(8'b0),
				.rollBackVal(8'b10011001), //99
				.bcd(count_UUT0)
			);
	
		
	CounterBCD UUT1(
				.clk(f_clk),
				.set(reset),
				.enable(enable_UUT1),
				.iniValue(8'b0),
				.setValue(8'b0),
				.rollBackVal(8'b10011001), //99
				.bcd(count_UUT1)
			);
			
		
	CounterBCD UUT2(
				.clk(f_clk),
				.set(reset),
				.enable(enable_UUT2),
				.iniValue(8'b0),
				.setValue(8'b0),
				.rollBackVal(8'b00001001), //9
				.bcd(count_UUT2)
			);
			
	

endmodule