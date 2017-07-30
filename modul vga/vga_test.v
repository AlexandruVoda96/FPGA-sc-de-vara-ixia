module vga_test();
reg clk; 
wire h_sync; 
wire v_sync; 
wire display_en;
wire [10:0] x_pos,y_pos;
vga DUT(.clk(clk),.h_sync(h_sync),.v_sync(v_sync),.display_en(display_en),.x_pos(x_pos),.y_pos(y_pos));
initial begin
  clk=0;
  forever #1 clk=~clk;
  end
 
endmodule
