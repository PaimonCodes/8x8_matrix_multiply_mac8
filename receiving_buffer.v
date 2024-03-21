module receiving_buffer(

	input clk,
	input start,
	input signed [18:0] data0, data1, data2, data3, data4, data5, data6, data7,
	input [5:0] addr0, addr1, addr2, addr3, addr4, addr5, addr6, addr7,
	
	output reg [5:0] addr_out,
	output reg signed [18:0] data_out
	
);

	reg [2:0] state, state_c;
	
	reg [18:0] data0_r, data1_r, data2_r, data3_r, data4_r, data5_r, data6_r, data7_r;
	reg [18:0] data_c;
	reg [5:0] addr0_r, addr1_r, addr2_r, addr3_r, addr4_r, addr5_r, addr6_r, addr7_r;
	reg [5:0] addr_c;
	
	initial begin
		data0_r = data0;
		data1_r = data1;
		data2_r = data2;
		data3_r = data3;
		data4_r = data4;
		data5_r = data5;
		data6_r = data6;
		data7_r = data7;
		
		addr0_r = addr0;
		addr1_r = addr1;
		addr2_r = addr2;
		addr3_r = addr3;
		addr4_r = addr4;
		addr5_r = addr5;
		addr6_r = addr6;
		addr7_r = addr7;
		state = 3'b000;
	end
	
	always @(posedge clk) begin
		state <= state_c;
		data_out <= data_c;
		addr_out <= addr_c;
	end
	
	always @(*) begin

		case (state)
			3'b000:
			begin
				// Start
				data0_r = data0;
				data1_r = data1;
				data2_r = data2;
				data3_r = data3;
				data4_r = data4;
				data5_r = data5;
				data6_r = data6;
				data7_r = data7;
					
				addr0_r = addr0;
				addr1_r = addr1;
				addr2_r = addr2;
				addr3_r = addr3;
				addr4_r = addr4;
				addr5_r = addr5;
				addr6_r = addr6;
				addr7_r = addr7;
				
				data_c = data0_r;
				addr_c = addr0_r;
				state_c = 3'b001;
			end
			
			3'b001:
			begin
				data_c = data1_r;
				addr_c = addr1_r;
				state_c = 3'b010;
			end
			
			3'b010:
			begin
				data_c = data2_r;
				addr_c = addr2_r;
				state_c = 3'b011;
			end
			
			3'b011:
			begin
				data_c = data3_r;
				addr_c = addr3_r;
				state_c = 3'b100;
			end
			
			3'b100:
			begin
				data_c = data4_r;
				addr_c = addr4_r;
				state_c = 3'b101;
			end
			
			3'b101:
			begin
				data_c = data5_r;
				addr_c = addr5_r;
				state_c = 3'b110;
			end
			
			3'b110:
			begin
				data_c = data6_r;
				addr_c = addr6_r;
				state_c = 3'b111;
			end
			
			3'b111:
			begin
				data_c = data7_r;
				addr_c = addr7_r;
				state_c = 3'b000;
			end
			
		endcase
	end

endmodule