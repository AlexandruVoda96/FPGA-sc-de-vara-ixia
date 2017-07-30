module keyboard
(input clk,
input scl, 
input sda,
 output reg [2:0]direction);
	reg [7:0] codeword;
	reg [10:0]scan_code;
	reg [3:0]bit_cnt;
	reg data_received;
	reg data_valid;
	reg [2:0] last_direction;
parameter w=3'b011,a=3'b010,s=3'b001,d=3'b000,rst=3'b100;
initial begin
last_direction=rst;
direction=rst;
end

always @(negedge scl) begin
	//scan_code[bit_cnt] <= sda; //nu shifteaza bine
	scan_code[10:0] <= {sda, scan_code[10:1]};
	if(bit_cnt == 10) begin
		data_received <= 1;
		bit_cnt <= 0;
		
	end
	else begin
		bit_cnt <= bit_cnt + 4'd1;
		data_received <= 0;
	end
end

always @(posedge clk) begin
if(data_received == 1) begin
//	if((scan_code[10]^scan_code[8]^scan_code[7]^scan_code[6]^scan_code[5]
//	^scan_code[4]^scan_code[3]^scan_code[2]^scan_code[1]^scan_code[0]) == scan_code[9])
		data_valid <= 1;
//		else
//		data_valid <= 0;
	end

if (data_valid) begin
	codeword <= scan_code[8:1];
	case(codeword)
	8'h75:begin
	if(last_direction!=s)	begin
		direction<=w;
		last_direction<=w;
	end
	else if(last_direction==s)
		direction<=s;
	end
	8'h6B: begin
	if(last_direction!=d)	begin
		direction<=a;
		last_direction<=a;
	end
	else if(last_direction==d)
		direction<=d;
	end
	8'h72: begin
	if(last_direction!=w)	begin
		direction<=s;
		last_direction<=s;
	end
	else if(last_direction==w)
		direction<=w;
	end
	8'h74: begin
	if(last_direction!=a)	begin
		direction<=d;
		last_direction<=d;
	end
	else if(last_direction==a)
		direction<=a;
	end
	8'h29: begin
	direction<=rst;
	last_direction<=rst;
	end
	default: direction<=direction; 
	endcase
end
	
end



endmodule
