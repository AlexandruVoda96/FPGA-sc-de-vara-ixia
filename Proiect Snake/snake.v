module snake(
input clk,
input display_en,
input [10:0] rand_x,rand_y,
input [10:0] x_pos, y_pos,
input [2:0]direction,	
output reg [3:0] red,
output reg [3:0] green,
output reg [3:0] blue,
output [6:0] points
);
wire snake_c,apple_c,border_c,win_c;
reg [6:0] points_counter=0;
reg[25:0]update;
reg border;	
reg [10:0]apple_x=40,apple_y=40;
reg [10:0]snake_x[0:31];
reg [10:0]snake_y[0:31];
reg snake_body;
reg snake_head;
reg apple;
reg check;
reg win=0;
reg bad_collision=0;
reg good_collision=0;
integer i,j,k,m,n;
integer apple_count;
reg [4:0]size=1;
parameter w=3'b011,a=3'b010,s=3'b001,d=3'b000,rst=3'b100;
assign points=points_counter;


always @(posedge clk)begin 
	

//apple generator

	if(good_collision) begin
		apple_x<=rand_x;
		apple_y<=rand_y;
		good_collision<=0;
	end
	else begin
		apple_x<=apple_x;
		apple_y<=apple_y;
		good_collision<=0;
	end
	
//conditii pt culoare		
			apple <= (x_pos > apple_x-2 && x_pos < (apple_x+20-1)) && (y_pos > apple_y-1 && y_pos < (apple_y+20));
			border <= (((x_pos >= 0) && (x_pos <=21) || (x_pos >= 780) && (x_pos <= 799)) || 
((y_pos >= 0) && (y_pos <= 21) || (y_pos >= 580) && (y_pos <= 599)));
			snake_head <= (x_pos > snake_x[0]-2 && x_pos < (snake_x[0]+20-1)) && (y_pos > snake_y[0]-1 && y_pos < (snake_y[0]+20));
			check = 0;
	for(j = 1; j < size; j = j + 1)
		begin
			if(~check)
			begin				
		   snake_body = ((x_pos > snake_x[j]-2 && x_pos < snake_x[j]+20-1) && (y_pos > snake_y[j]-1 && y_pos < snake_y[j]+20));
		   check = snake_body;
			end
		end
		
//conditii reset			
		
		if(direction==rst) begin
		   win<=0;
			apple_count=0;
			good_collision <= 0;
			bad_collision <= 0;
			size <= 1;
			points_counter<=0;
		end
		if((border && snake_head &&~win) /*|| (snake_body && snake_head)*/)begin //se loveste
			bad_collision <= 1;
			apple_count=0;
			points_counter<=0;
			end
//conditii punctaj			

		if(snake_head && apple) begin
		   apple_count=apple_count+1; //creste din 3 in 3 !?
			good_collision <= 1;
			if(apple_count==3)begin
			size<=size+5'd1; 
			points_counter<=points_counter+5'd1;
			apple_count=0;
			end
			if(points_counter==5'd29)
			win<=1;
			
			end
//directions	
		if(update==5000000) begin //viteza sarpe
		update<=0;
		if(direction==rst || bad_collision==1 ||win==1)
			begin //space sau se loveste
			snake_x[0]<=11'd380;
			snake_y[0]<=11'd280;
			for(k = 1; k <= 31; k = k+1)
					begin
					snake_x[k] <= 11'd820;
					snake_y[k] <= 11'd620;
				end
			end

		else begin
		for(i = 31; i >= 1; i = i - 1) //ultimul pixel devine cap
			begin
				if(i < size)
				begin
					snake_x[i] <= snake_x[i - 1]; 
					snake_y[i] <= snake_y[i - 1];
				end
			end

end	

		case(direction)

			w: snake_y[0] <= (snake_y[0] - 11'd20);//w
			
			a:snake_x[0] <= (snake_x[0] - 11'd20);//a
			
			s:snake_y[0] <= (snake_y[0] + 11'd20);//s
			
			d: snake_x[0] <= (snake_x[0] + 11'd20);//d

		endcase	
		end
		else
		update<=update+26'd1;

end
		
	
//colorat
assign win_c = (win && ~bad_collision);
assign apple_c = ((apple || bad_collision) && ~win);	
assign snake_c = ((snake_head || snake_body) && ~bad_collision && ~win);
assign border_c = (border && ~bad_collision && ~win);
always@(posedge clk)
	begin
		if(display_en) begin
		if(snake_c||apple_c||border_c||win_c) begin
			if(snake_c)begin
				red=4'h6;
				green=4'hC;
				blue=4'h0;
			end
			if(apple_c)begin
				red=4'hC;
				green=4'h0;
				blue=4'h0;
			end
			if(border_c)begin
				red=4'b0000;
				green=4'b0000;
				blue=4'b0000;
			end
			if(win_c)begin
				red=4'h6;
				green=4'hC;
				blue=4'h0;
			end
			
			end
	//background
		else begin
		red=4'hF;
		green=4'hF;
		blue=4'h0;
		for(m=0;m<=600;m=m+40)begin  
			for(n=0;n<=800;n=n+40)begin
		if((y_pos>=m && y_pos<m+20) &&(x_pos>=n && x_pos<n+20))begin
		red=4'hF;
		green=4'hF;
		blue=4'hF;
		end
	end
end
		for(m=20;m<=600;m=m+40)begin 
			for(n=20;n<=800;n=n+40)begin
		if((y_pos>=m && y_pos<m+20) &&(x_pos>=n && x_pos<n+20))begin
		red=4'hF;
		green=4'hF;
		blue=4'hF;
		end
	end
end
		end
	end
	//backporch
	else begin
		red=4'b0000;
		green=4'b0000;
		blue=4'b0000;
	end 
end
endmodule
