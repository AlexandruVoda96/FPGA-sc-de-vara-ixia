module top (
input clk,
input scl,
input sda,
output h_sync,
output v_sync,
output [3:0] red,
output [3:0] green,
output [3:0] blue,
output [13:0] points_7seg,
output [6:0] digit2, digit3
);

wire [2:0]direction;			
wire display_en;
wire [10:0] x_pos, y_pos;
wire [10:0] rand_x,rand_y;
wire [6:0] points;
vga_sync vga(.clk(clk),.h_sync(h_sync),.v_sync(v_sync),.display_en(display_en),.x_pos(x_pos),.y_pos(y_pos));
keyboard kb(.clk(clk),.scl(scl),.sda(sda),.direction(direction));		
random applegen (.clk(clk),.rand_x(rand_x),.rand_y(rand_y));
transcodor score(.points(points), .q(points_7seg));
snake mechanic(.clk(clk),.display_en(display_en),.rand_x(rand_x),.rand_y(rand_y),.x_pos(x_pos),.y_pos(y_pos),.direction(direction),.red(red),.green(green),.blue(blue),.points(points));
assign digit2=7'b1111111;
assign digit3=7'b1111111;


endmodule
