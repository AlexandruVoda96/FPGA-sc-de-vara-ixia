module ps2(
input clk, //clock placa
input scl, //clock de la tastatura
input sda,	//date de la tastatura
output [7:0]data_out 
);

reg data_valid=0;
reg [10:0]scan_code; 
reg [7:0]codeword=8'h0;
reg [3:0]bit_cnt=0;
reg data_received=0;

always @(negedge scl) begin
	//scan_code[bit_cnt] <= sda;
	scan_code[10:0] <= {sda, scan_code[10:1]};
	if(bit_cnt == 10) begin
		data_received <= 1;
		bit_cnt <= 0;
		
	end
	else begin
		bit_cnt <= bit_cnt + 1;
		data_received <= 0;
	end
end

always @(posedge clk) begin
if(data_received == 1) begin
	if((scan_code[10]^scan_code[9]^scan_code[8]^scan_code[7]^scan_code[6]^scan_code[5]^scan_code[4]^scan_code[3]^scan_code[2]^scan_code[0]) == scan_code[1])
		data_valid <= 1;
		else
		data_valid <= 0;
	end

if (data_valid) begin
	codeword <= scan_code[8:1];
end
	
end

assign data_out = codeword;

endmodule
