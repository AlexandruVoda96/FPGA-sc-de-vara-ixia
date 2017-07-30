module ps2_test();
     reg clk,scl,sda;
     wire [7:0] data_out;
     
     ps2 kb(.clk(clk),
							.scl(scl),
							.sda(sda),
							.data_out(data_out));
		initial begin
		     clk=0;
		     forever #1 clk=~clk;
		      end
		initial begin
		     scl=1;
		     forever #10 scl=~scl;
		      end
		 //w=3'b011,a=3'b010,s=3'b001,d=3'b000,rst=3'b100;
		// 75-w , 6B-a, 72-s, 74-d, 29-rst
		initial begin
		  
		    
		    //inceput pachet
					  
					sda=1;   //0    //bit start 
					
			    @(posedge scl)
					sda=0;   //1
					@(posedge scl)
					sda=1;   //2
					@(posedge scl)
					sda=0;   //3
					@(posedge scl)
					sda=0;   //4
					@(posedge scl)
					
					sda=1;   //5
					@(posedge scl)
					sda=1;   //6
					@(posedge scl)
					sda=1;   //7
					@(posedge scl)
					sda=0;   //8
					
					//paritate si stop
					@(posedge scl)
					sda=1;   //9
					@(posedge scl)
					sda=1;   //10
					
					//final pachet
					
					//inceput pachet
					  
					@(posedge scl)
					sda=1;   //0    //bit start 
					
			    @(posedge scl)
					sda=1;   //1
					@(posedge scl)
					sda=1;   //2
					@(posedge scl)
					sda=0;   //3
					@(posedge scl)
					sda=0;   //4
					@(posedge scl)
					
					sda=1;   //5
					@(posedge scl)
					sda=1;   //6
					@(posedge scl)
					sda=1;   //7
					@(posedge scl)
					sda=0;   //8
					
					//paritate si stop
					@(posedge scl)
					sda=1;   //9
					@(posedge scl)
					sda=1;   //10
					
					//final pachet
					
					
					
					
					
					#50 $stop;
				  end
	endmodule

