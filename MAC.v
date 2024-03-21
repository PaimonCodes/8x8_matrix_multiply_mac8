module MAC(input signed [7:0] inA, input signed [7:0] inB, input macc_clear, input clk, output reg signed [18:0] out);

	reg signed [18:0] accumulator;
	reg signed [15:0] multiplier;
	
	always @(posedge clk) begin
		out <= accumulator;
	end
	
	always @(*) begin
		multiplier = inA * inB;
		accumulator = macc_clear ? multiplier : multiplier + out;	
	end

endmodule