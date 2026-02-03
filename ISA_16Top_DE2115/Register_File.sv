module Register_File (
	input logic clk, 					//clock
	input logic resetn, 				//active low reset  
	input logic wen, 					//write enable
	input logic [1:0] readRegAddr1, 	//rs, first source register address
	input logic [1:0] readRegAddr2,	//rt, second source register address
	input logic [1:0] writeRegAddr, 	//rt/rd, destination register
	input logic [15:0] writeData, //write data
	output logic [15:0] readData1, //read data 1
	output logic [15:0] readData2		//read data 2

);

	
	//internal 16 bit register 4*16
	logic [15:0] register [0:3]; 
	
	//if the read address is 0 ($zero) then output is 16bit 0
	assign readData1 = (readRegAddr1 == 2'b00)? 16'h0000: register[readRegAddr1]; 
	assign readData2 = (readRegAddr2 == 2'b00)? 16'h0000: register[readRegAddr2]; 
	
	//write operation with async reset 
	always_ff @(posedge clk, negedge resetn) begin
		if(!resetn) begin
			register[0] <= 16'h0000; //$zero
			register[1] <= 16'h0000; //a0
			register[2] <= 16'h0000; //s0
			register[3] <= 16'h0000; //ra
		end
		
		//shouldn't write for zero. So writeRegAddr != 0
		else if (wen && writeRegAddr != 2'b00) begin 
			register[writeRegAddr] <= writeData; 
		end 
		
	end 
	
endmodule 
	