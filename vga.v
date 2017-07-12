module vga_sync (
input clk, //pin L1
input rst, //pin R22
output h_sync, //pin A11
output v_sync, //pin B11
output display_en,
output x_pos,
output y_pos
);
parameter h_visible_area=800,
			 h_pixels =1040,
			 h_pulse = 120, 	
			 h_back_porch = 64, 	
			 h_front_porch = 56; 
			 
parameter v_visible_area=600,
			 v_pixels = 666,
			 v_pulse = 6,		
			 v_back_porch = 23, 		
			 v_front_porch = 37;	
reg [10:0] h_cnt;
reg [10:0] v_cnt;


always @(posedge clk or negedge rst)
begin

	if (~rst) 
	begin
		h_cnt <= 0;
		v_cnt <= 0;
	end
	else
	
	begin

		if (h_cnt < h_pixels-1)
			h_cnt <= h_cnt + 1;
		else
		
		begin
			h_cnt <= 0;
			if (v_cnt < v_pixels-1)
				v_cnt <= v_cnt + 1;
			else
				v_cnt <= 0;
		end
		
	end
end


assign h_sync = (h_cnt < (h_visible_area + h_front_porch) || h_cnt > (h_visible_area + h_front_porch+ h_pulse)) ? 0:1;
assign v_sync = (v_cnt < (v_visible_area + v_front_porch) || v_cnt > (v_visible_area + v_front_porch+ v_pulse)) ? 0:1;
assign display_en =(h_cnt < h_visible_area && v_cnt < v_visible_area ) ? 1:0;
//assign x_pos = (display_en) ? h_cnt:11'bz;
//assign y_pos = (display_en) ? v_cnt:11'bz;
//always@(*) begin
//	if(display_en) begin
//	if(h_cnt<399 && v_cnt < 299)begin
//		red=3'b111;
//		green=2'b00;
//		blue=3'b000;
//		end
//	else if(h_cnt>399 && v_cnt < 299)begin
//		red=3'b000;
//		green=2'b00;
//		blue=3'b111;
//		end
//	else if(h_cnt<399 && v_cnt > 299)begin
//		red=3'b000;
//		green=2'b11;
//		blue=3'b000;
//		end
//	else if(h_cnt>399 && v_cnt > 299)begin
//		red=3'b111;
//		green=2'b11;
//		blue=3'b111;
//		end
//	else 
//		begin
//		red=3'b000;
//		green=2'b00;
//		blue=3'b000;
//		end
//	end
//
//	else begin
//		red=3'bzzz;
//		green=2'bzz;
//		blue=3'bzzz;
//	end
//end
endmodule