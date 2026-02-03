module PC (
	input logic clk, 					//clock  
	input logic resetn, 				//active low reset 
	input logic [9:0] nextPc, 		//next PC address
	output logic [9:0] currentPC	//current PC address 
); 

	always_ff @(posedge clk, negedge resetn) begin 
		if(!resetn) currentPC <= 10'h000; //PC reset to 0
		else currentPC <= nextPc; 			// go to next PC on posedge 
	end 
	
endmodule