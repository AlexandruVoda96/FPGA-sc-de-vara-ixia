module spi
(
 input clk,		//ceas master
 input rst,
 input miso,  //master input slave output
 input en,
 //input cpha, //faza ceasului cpha=0 se trimit date pe frontul crescator
 input cpol,   //polaritatea ceasului cpol=0 ceasul incepe de la 0
 input [7:0] tx_data,
 input [7:0] clk_div,  //cat de mult divizam ceasul masterului pt slave
 output reg [7:0] rx_data,
 output reg sclk,		//serial clock pt slave	
 output reg busy,		
 output reg ss,		//slave select
 output reg mosi		//master output slave input
 //output reg [n-1]addr;
 );
 
//FSM states 
localparam RESET = 2'd0;
localparam IDLE = 2'd1;
localparam RUNNING = 2'd2;
				
reg [1:0] state;
reg [7:0] clock_div_cnt; //cand clock_div_cnt ajunge la clk_div, sclk isi schimba valoarea 
reg [2:0] bit_cnt = 3'd7;

//transfer & bit counter msb first
		always@(posedge sclk) begin
										mosi <= tx_data[bit_cnt];
										rx_data[bit_cnt] <= miso;
										bit_cnt <= bit_cnt-1;
										  if(bit_cnt == 0) begin
										    state<=IDLE;
										    bit_cnt <=7 ;
										    end
								end
	
				

		always@(posedge clk) begin
			if (~rst) begin 
				state <= RESET;
				end
			else begin
				state <= IDLE;
							
		case(state)
		
// state - RESET
		RESET : begin
		busy <= 1;
		ss <= 1;
		clock_div_cnt <= 0;
		sclk <= cpol;
		if(~rst)
		  state<=RESET;
		  else
		    state<=IDLE;
		end
		
// state - IDLE		
		IDLE: begin
		ss <= 1;
		busy <= 0;
		sclk <= cpol;
		if (en) begin
		state <= RUNNING;
		end
		else  begin
		      state <= IDLE;
		      end
		end
		
// state - RUNNING		
		RUNNING:	begin
		busy <= 1;
		ss <= 0;
//clock divider
		if (clock_div_cnt == clk_div) begin
								clock_div_cnt <=0;
								sclk <= ~sclk;
								end
									else 
									clock_div_cnt <= clock_div_cnt + 1;
          if(bit_cnt == 0) 
			         state <= IDLE;
				      	else
		            state <= RUNNING;
		end	
	  
	  default : begin
		busy <= 1;
		ss <= 1;
		state <= IDLE;
		end					
		
		endcase
	end 
end

		
		
		
	endmodule					




