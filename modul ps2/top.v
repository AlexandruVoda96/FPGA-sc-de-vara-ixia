module top(input clk,scl,sda,
output [6:0]OUT1,
output [6:0]OUT2);
wire [7:0]data;
ps2 ps2(.clk(clk),.scl(scl),.sda(sda),.data_out(data));
transcodor i0(.in(data[3:0]),.out(OUT1));
transcodor i1(.in(data[7:4]),.out(OUT2));
endmodule