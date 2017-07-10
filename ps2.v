module ps2(
input clk, //clock placa
input scl, //clock de la tastatura
input sda,	//date de la tastatura
output [7:0]data_out // 8 leduri
);
reg reading; // 1 cand primeste biti
//reg [11:0] reading_cnt; //cat timp a trecut de la ultimul pachet
reg prev_clock;
reg [7:0]clock_div_cnt = 0;
reg clock_div = 0;
reg err;
reg [10:0]scan_code; //stocheaza cei 11 biti primiti`
reg [7:0]codeword;
reg [3:0]bit_cnt;
reg full;

// valori initiale
initial begin
		prev_clock = 1;		
		err = 0;		
		scan_code = 0;
		bit_cnt = 0;			
		codeword = 0;
		reading = 0;
		//reading_cnt = 0;
	end

//divizor de frecventa de 250 ori tclk fpga
always @(posedge clk) begin
	if(clock_div_cnt < 249) begin
		clock_div_cnt <= clock_div_cnt+1;
		clock_div <= 0;
		end
	else begin
		clock_div_cnt<=0;
		clock_div <= 1;
		end
end

/* 
//numara cat timp citeste
always @(posedge clk) begin	
		if (clock_div) begin
			if (reading)				
				reading_cnt <= reading_cnt + 1;	
			else 						
				reading_cnt <= 0;			
		end
	end
*/

always @(posedge clk) begin
	if(clock_div) begin
		if(scl != prev_clock) begin
			if(!scl) begin
				reading <= 1; //citeste
				err <=0; 
				scan_code[10:0] <= {sda, scan_code[10:1]};
				bit_cnt=bit_cnt+1;
			end
		end
		else if (bit_cnt == 11) begin
			bit_cnt <=0;
			reading <= 0; //nu mai citeste 
			full <= 1; //un pack de 11 biti a fost primit
		if (!scan_code[10] || scan_code[0] || !(scan_code[1]^scan_code[2]^scan_code[3]^scan_code[4]^scan_code[5]^scan_code[6]^scan_code[7]^scan_code[8]^scan_code[9])) 
				err <= 1; //daca nu verifica bitul de paritate primesc eroare 
			else 
				err <= 0;
		end
		else  begin						//daca nu a primit pack-ul de 11 biti
			full <= 0;					//inca primeste
			
			/*	
			if (bit_cnt < 11 && reading_cnt >= 4000) begin	//daca a trecut prea mult timp
				bit_cnt <= 0;				//reseteaza bit_cnt
				reading <= 0;				//asteapta pt urmatorul pachet 
				
			end 
			*/
	end
	prev_clock <= scl;
	end
end

//stocheaza date
always @(posedge clk) begin
		if(clock_div) begin
			if(full) begin 
				if(err) begin //daca eroare 
					codeword <= 8'd0;
				end
				else begin
					codeword <= scan_code[8:1]; //preia codul necesar
				end
			end
			else codeword <= 8'd0; //daca nu e full
		end
		else codeword <= 8'd0; //daca nu a dat ceasul divizat
end

assign data_out = codeword;
endmodule


