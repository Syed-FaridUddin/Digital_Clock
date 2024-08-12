module CounterBCD (
	input clk,
	// input reset,
	input set,
	input enable,
	input [7:0]iniValue,
	input [7:0]setValue,
	input [7:0]rollBackVal,
	output [7:0]bcd
);
	
	reg [7:0]count;
	assign bcd = count;
	
	// always @ (posedge reset, posedge clk) begin
	always @ (posedge set, posedge clk) begin
		// if (reset) begin
			// count <= iniValue; // to be declared
		// end
		// else if (set) begin
		if (set) begin
			count <= setValue; // to be declared
		end
		else begin
		if (enable) begin
			if (count == rollBackVal) begin
				count <= iniValue;
			end
			else begin
				if (count[3:0] == 4'd9) begin
					count[7:4] <= count[7:4] + 4'd1;
					count[3:0] <= 4'd0;
				end
				else begin
					count[3:0] <= count[3:0] + 4'd1;
				end
			end
		end
		else begin
			count <= count;
		end
		end
	end


endmodule