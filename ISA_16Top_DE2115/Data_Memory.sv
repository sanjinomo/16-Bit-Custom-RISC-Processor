module Data_Memory(
	input logic clk, 						//clock 
	input logic MemWEn,					//write enable 
	input logic MemRedEn,				//read enable 
	input logic [9:0] eff_address, 	//effictive address from alu
	input logic [15:0] WriteData, 	//16 bit write data 
	output logic [15:0] ReadData		//16 bit read data 

);

	//data memory for 1024 words each of them of 16 bits
	logic [15:0] data_Mem [0:1023];
	
	
	//synchronous write at MemWriteEn enable
	always_ff @(posedge clk) begin 
		if(MemWEn) data_Mem [eff_address] <= WriteData;  
	end
	
	
	//prevents stale data from reading when not enable  
	assign ReadData = (MemRedEn)? data_Mem[eff_address] : 16'h0000; //read 16 bits memory

endmodule