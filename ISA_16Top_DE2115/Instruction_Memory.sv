module Instruction_Memory (
	input logic [9:0] PC, //10 bit Program Counter 
	output logic [15:0] Instruction //16 bits instruction output  

);

	//instruction memory for 1024 words each of them of 16 bits
	logic [15:0] instruction_Mem [0:1023];
	
	//we will load the instruction bits through instruction.hex file and put it in instruction memory 
	//D:\Uah_Fpga\ISADesignProject531\try2\ISA_16Top
	initial begin 
		$readmemh("instruction.hex", instruction_Mem);
	end 
	
	assign Instruction = instruction_Mem[PC]; //read 16 bits instruction
	
endmodule
	