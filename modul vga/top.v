module top (
input clk,
input rst,
output h_sync,
output v_sync,
output reg [2:0] red,
output reg [1:0] green,
output reg [2:0] blue
);
				
wire display_en;
wire [10:0] x_pos, y_pos;
vga_sync vga(.clk(clk),.rst(rst),.h_sync(h_sync),.v_sync(v_sync),.display_en(display_en),.x_pos(x_pos),.y_pos(y_pos));
		
				
always@(*) begin
	if(display_en) begin
	if(x_pos<399 && y_pos < 299)begin
		red=3'b111;
		green=2'b00;
		blue=3'b000;
		end
	else if(x_pos>399 && y_pos < 299)begin
		red=3'b000;
		green=2'b00;
		blue=3'b111;
		end
	else if(x_pos<399 && y_pos > 299)begin
		red=3'b000;
		green=2'b11;
		blue=3'b000;
		end
	else if(x_pos>399 && y_pos > 299)begin
		red=3'b111;
		green=2'b11;
		blue=3'b111;
		end
	else 
		begin
		red=3'b000;
		green=2'b00;
		blue=3'b000;
		end
	end

	else begin
		red=3'bzzz;
		green=2'bzz;
		blue=3'bzzz;
	end
end
	
endmodule