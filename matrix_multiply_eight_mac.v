module matrix_multiply_eight_mac(

	input clk, start, reset, 
	output reg done, 
	output reg [10:0] clock_count

);

	parameter IDLE = 3'h0;
	parameter MULTIPLIER = 3'h1;
	parameter ACCUMULATE = 3'h2;
	parameter DONE = 3'h3;
	
	reg [2:0] state, state_c;
				
	reg [3:0] counter;
	
	reg [10:0] clock_count_c;
	
	reg [3:0] remaining_count, remaining_count_c;
	
	reg done_c;
	
	// Init matrix A and matrix B
	reg signed [7:0] matrix_A [63:0];
	reg signed [7:0] matrix_B [63:0];
	ram_output RAMOUTPUT();
	
	// Matrix traverse
	wire [3:0] c_s, d_s, e_s;
	reg [3:0] c, d, e;

	wire [3:0] f_s, g_s, h_s;
	reg [3:0] f, g, h;
	
	wire [3:0] i_s, j_s, k_s;
	reg [3:0] i, j, k;

	wire [3:0] l_s, m_s, n_s;
	reg [3:0] l, m, n;
	
	wire [3:0] o_s, p_s, q_s;
	reg [3:0] o, p, q;

	wire [3:0] r_s, s_s, t_s;
	reg [3:0] r, s, t;
	
	wire [3:0] u_s, v_s, w_s;
	reg [3:0] u, v, w;
	
	wire [3:0] x_s, y_s, z_s;
	reg [3:0] x, y, z;

	initial begin
		$readmemb("ram_a_init.txt",matrix_A);
		$readmemb("ram_b_init.txt",matrix_B);
		
		c = 0;
		d = 0;
		e = 0;
		
		f = 1;
		g = 0;
		h = 0;
		
		i = 2;
		j = 0;
		k = 0;
		
		l = 3;
		m = 0;
		n = 0;
		
		o = 4;
		p = 0;
		q = 0;
		
		r = 5;
		s = 0;
		t = 0;
		
		u = 6;
		v = 0;
		w = 0;
		
		x = 7;
		y = 0;
		z = 0;
	end
	
	// 8 MACs init
	reg macc_clear0, macc_clear1, macc_clear2, macc_clear3,
		macc_clear4, macc_clear5, macc_clear6, macc_clear7;
	reg signed [7:0] inA0, inB0, inA1, inB1, inA2, inB2, inA3, inB3,
		inA4, inB4, inA5, inB5, inA6, inB6, inA7, inB7;
		
	wire signed [18:0] out0, out1, out2, out3, out4, out5, out6, out7;
	
	MAC m0(.inA(inA0), .inB(inB0), .macc_clear(macc_clear0), .clk(clk), .out(out0));
	MAC m1(.inA(inA1), .inB(inB1), .macc_clear(macc_clear1), .clk(clk), .out(out1));
	MAC m2(.inA(inA2), .inB(inB2), .macc_clear(macc_clear0), .clk(clk), .out(out2));
	MAC m3(.inA(inA3), .inB(inB3), .macc_clear(macc_clear1), .clk(clk), .out(out3));
	MAC m4(.inA(inA4), .inB(inB4), .macc_clear(macc_clear0), .clk(clk), .out(out4));
	MAC m5(.inA(inA5), .inB(inB5), .macc_clear(macc_clear1), .clk(clk), .out(out5));
	MAC m6(.inA(inA6), .inB(inB6), .macc_clear(macc_clear0), .clk(clk), .out(out6));
	MAC m7(.inA(inA7), .inB(inB7), .macc_clear(macc_clear1), .clk(clk), .out(out7));
	
	// Buffer init
	reg signed [18:0] to_buffer0, to_buffer1, to_buffer2, to_buffer3, 
							to_buffer4, to_buffer5, to_buffer6, to_buffer7;
							
	reg [5:0] to_buffer0_addr, to_buffer1_addr, to_buffer2_addr, to_buffer3_addr, 
				to_buffer4_addr, to_buffer5_addr, to_buffer6_addr, to_buffer7_addr;
	wire [5:0] addr_out;
	wire signed [18:0] buffer_out;
	reg start_buff;
	
	wire buffer_done;
	
	receiving_buffer b0(.data0(to_buffer0), .data1(to_buffer1), .data2(to_buffer2), .data3(to_buffer3), 
								.data4(to_buffer4), .data5(to_buffer5), .data6(to_buffer6), .data7(to_buffer7),
								.clk(clk), 
								.addr0(to_buffer0_addr), .addr1(to_buffer1_addr), .addr2(to_buffer2_addr), .addr3(to_buffer3_addr),
								.addr4(to_buffer4_addr), .addr5(to_buffer5_addr), .addr6(to_buffer6_addr), .addr7(to_buffer7_addr),
								.addr_out(addr_out), .data_out(buffer_out), .start(start_buff));
	
	// Two clock delays to wait for MAC OUT
	buffer_delay d0(.clk(clk), .a(c), .b(d), .c(e), .out1(c_s), .out2(d_s), .out3(e_s));
	buffer_delay d1(.clk(clk), .a(f), .b(g), .c(h), .out1(f_s), .out2(g_s), .out3(h_s));
	buffer_delay d2(.clk(clk), .a(i), .b(j), .c(k), .out1(i_s), .out2(j_s), .out3(k_s));
	buffer_delay d3(.clk(clk), .a(l), .b(m), .c(n), .out1(l_s), .out2(m_s), .out3(n_s));
	buffer_delay d4(.clk(clk), .a(o), .b(p), .c(q), .out1(o_s), .out2(p_s), .out3(q_s));
	buffer_delay d5(.clk(clk), .a(r), .b(s), .c(t), .out1(r_s), .out2(s_s), .out3(t_s));
	buffer_delay d6(.clk(clk), .a(u), .b(v), .c(w), .out1(u_s), .out2(v_s), .out3(w_s));
	buffer_delay d7(.clk(clk), .a(x), .b(y), .c(z), .out1(x_s), .out2(y_s), .out3(z_s));

	
	always @(posedge clk) begin
		state <= state_c;
		done <= done_c;
		clock_count <= clock_count_c;
		remaining_count <= remaining_count_c;
	end
	
	always @(posedge clk) begin
		// Write to buffer which will write to ram
		if (e_s == 7 && h_s == 7 && k_s == 7 && n_s == 7 &&
			 q_s == 7 && t_s == 7 && w_s == 7 && z_s == 7) begin
			start_buff <= 1;
			
			to_buffer0 <= out0;
			to_buffer1 <= out1;
			to_buffer2 <= out2;
			to_buffer3 <= out3;
			to_buffer4 <= out4;
			to_buffer5 <= out5;
			to_buffer6 <= out6;
			to_buffer7 <= out7;
			
			to_buffer0_addr <= 8*c_s+d_s;
			to_buffer1_addr <= 8*f_s+g_s;
			to_buffer2_addr <= 8*i_s+j_s;
			to_buffer3_addr <= 8*l_s+m_s;
			to_buffer4_addr <= 8*o_s+p_s;
			to_buffer5_addr <= 8*r_s+s_s;
			to_buffer6_addr <= 8*u_s+v_s;
			to_buffer7_addr <= 8*x_s+y_s;
			

		end else begin
			start_buff <= 0;
		end
		RAMOUTPUT.mem[addr_out] <= buffer_out;
	end
	
	always @(*) begin
		// Case when user pressed reset
		if (reset) begin
			state_c = IDLE;
		end
		
		// State allocation
		case (state)
		
			IDLE:
				begin
					done_c = 0;
					clock_count_c = 0;
					remaining_count_c = 0;
					state_c = start ? MULTIPLIER : IDLE;
				end
				
			MULTIPLIER:
				begin
					// Start clock count
					clock_count_c = clock_count + 1;
					
					// Set MAC clear to 1
					macc_clear0 = 1;
					macc_clear1 = 1;
					macc_clear2 = 1;
					macc_clear3 = 1;
					macc_clear4 = 1;
					macc_clear5 = 1;
					macc_clear6 = 1;
					macc_clear7 = 1;
					
					// Fetch first element
					inA0 = matrix_A[d+8*e];
					inB0 = matrix_B[e+8*c];
					inA1 = matrix_A[g+8*h];
					inB1 = matrix_B[h+8*f]; 	
					
					inA2 = matrix_A[j+8*k];
					inB2 = matrix_B[k+8*i];
					inA3 = matrix_A[m+8*n];
					inB3 = matrix_B[n+8*l]; 	
					
					inA4 = matrix_A[p+8*q];
					inB4 = matrix_B[q+8*o];
					inA5 = matrix_A[s+8*t];
					inB5 = matrix_B[t+8*r]; 	
					
					inA6 = matrix_A[v+8*w];
					inB6 = matrix_B[w+8*u];
					inA7 = matrix_A[y+8*z];
					inB7 = matrix_B[z+8*x]; 	
					
					// Go to accumulate state
					e = e + 1;
					h = h + 1;
					k = k + 1;
					n = n + 1;
					q = q + 1;
					t = t + 1;
					w = w + 1;
					z = z + 1;					
					
					state_c = ACCUMULATE;
				end
				
			ACCUMULATE:
				begin
					// Continue clock count
					clock_count_c = clock_count + 1;
					
					// Turn off MAC clear because we accumulate
					macc_clear0 = 0;
					macc_clear1 = 0;
					macc_clear2 = 0;
					macc_clear3 = 0;
					macc_clear4 = 0;
					macc_clear5 = 0;
					macc_clear6 = 0;
					macc_clear7 = 0;
					
					// Fetch next product
					inA0 = matrix_A[d+8*e];
					inB0 = matrix_B[e+8*c];
					inA1 = matrix_A[g+8*h];
					inB1 = matrix_B[h+8*f]; 	
					
					inA2 = matrix_A[j+8*k];
					inB2 = matrix_B[k+8*i];
					inA3 = matrix_A[m+8*n];
					inB3 = matrix_B[n+8*l]; 	
					
					inA4 = matrix_A[p+8*q];
					inB4 = matrix_B[q+8*o];
					inA5 = matrix_A[s+8*t];
					inB5 = matrix_B[t+8*r]; 	
					
					inA6 = matrix_A[v+8*w];
					inB6 = matrix_B[w+8*u];
					inA7 = matrix_A[y+8*z];
					inB7 = matrix_B[z+8*x]; 		
					
					
					// See if accumulate is done
					// Edit traverse
					e = e + 1;
					h = h + 1;
					k = k + 1;
					n = n + 1;
					q = q + 1;
					t = t + 1;
					w = w + 1;
					z = z + 1;
					if (e < 8 && h < 8 && k < 8 && n < 8 &&
						 q < 8 && t < 8 && w < 8 && z < 8) begin
						state_c = ACCUMULATE;
					end else begin
						e = 0;
						h = 0;
						k = 0;
						n = 0;
						q = 0;
						t = 0;
						w = 0;
						z = 0;
						
						d = d + 1;
						g = g + 1;
						j = j + 1;
						m = m + 1;
						p = p + 1;
						s = s + 1;
						v = v + 1;
						y = y + 1;
						
						state_c = MULTIPLIER;
					end
						
					if ((c < 1 && d > 7) && (f < 2 && g > 7) && (i < 3 && j > 7) && 
						 (l < 4 && m > 7) && (o < 5 && p > 7) && (r < 6 && s > 7) && 
						 (u < 7 && v > 7) && (x < 8 && y > 7)) begin
						 
						c = c + 1;
						f = f + 1;
						i = i + 1;
						l = l + 1;
						o = o + 1;
						r = r + 1;
						u = u + 1;
						x = x + 1;	
						
						d = 0;
						g = 0;
						j = 0;
						m = 0;
						p = 0;
						s = 0;
						v = 0;
						y = 0;
					end
					
					// Priority exit
					if (c > 0) begin
						state_c = DONE;
					end
						
				end
				
			DONE:
				begin
					// Allow for remaining clock cycles to finish buffering
					// 8 cycles buffer + 2 cycles MAC and buffer delay
					if (remaining_count > 10) begin
						done_c = 1;
					end else begin
						remaining_count_c = remaining_count + 1;
						clock_count_c = clock_count + 1;
						state_c = DONE;
					end
				end
				
		endcase
	end

endmodule