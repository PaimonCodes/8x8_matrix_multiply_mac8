module buffer_delay(
	
	input clk,
	input [3:0] a, input [3:0] b, input [3:0] c,
	output reg [3:0] out1, output reg [3:0] out2, output reg [3:0] out3
	
);

	reg [3:0] a_r, b_r, c_r;

	always @ (posedge clk) begin
		a_r <= a;
		b_r <= b;
		c_r <= c;
		
		out1 <= a_r;
		out2 <= b_r;
		out3 <= c_r;
	end

endmodule 