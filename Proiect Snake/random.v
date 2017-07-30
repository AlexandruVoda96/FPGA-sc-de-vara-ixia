module random(
input clk, 
output reg [10:0]rand_x, 
output reg [10:0]rand_y);
	
	reg [6:0]x=4, y=4;

	always @(posedge clk) begin
		x <= x + 7'd4;	
		y <= y + 7'd4;
		
		if(x>72) begin
			rand_x <= 11'd720;
			x<=7'd4;
			end
		else
			rand_x <= (x * 11'd10);
			
		if(y>52) begin
			rand_y <= 11'd520;
			y<=7'd4;
			end
		else
			rand_y <= (y * 11'd10);
			
		end

endmodule