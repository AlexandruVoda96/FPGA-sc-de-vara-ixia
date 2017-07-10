module top(input clk,scl,sda,
output [6:0]OUT);
wire [7:0]data;
ps2 i1(.clk(clk),.scl(scl),.sda(sda),.data_out(data));
transcodor i2(.in(data),.out(OUT));
endmodule