module ISA_16Top_DE2115 (
	input logic CLOCK_50, 
	input logic [3:0] KEY, 						//Press for clock pulse 
	output logic [17:0] LEDR, 				  //to display current instuction 
	output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7 //to display the PC

);


	logic resetn; 
	assign resetn = KEY[0]; //active low resetn
	
	//internal logic for cpu signals 
	logic [9:0] fpga_pc; 
	logic [15:0] fpga_instruction;
	
	// use KEY[1] as step clock (press → one instruction)
   logic cpu_clk;
   assign cpu_clk = ~KEY[1];   // KEY[1]: 1 (released), 0 (pressed) → invert, then posedge when pressed

	
	ISA_16Top isacpu (
		.clk(cpu_clk), 
		.resetn(resetn),
		.PC(fpga_pc), 					//10 bit program counter 
		.Instruction(fpga_instruction)		//16 bit instruction
	
	
	); 
	
	
	//output current PC in HEX display
	logic [3:0] fp_hex0, fp_hex1, fp_hex2, fp_hex3;

	assign fp_hex0 = fpga_pc[3:0]; 
	assign fp_hex1 = fpga_pc[7:4]; 
	assign fp_hex2 = {2'b00, fpga_pc[9:8]}; 
	
	//instantiating the 7 segment display module which will connect to the segment 
	seven_seg h0 (.HEX(fp_hex0), .segment(HEX0));
	seven_seg h1 (.HEX(fp_hex1), .segment(HEX1)); 
	seven_seg h2 (.HEX(fp_hex2), .segment(HEX2));

	//HEX3 blank 
	assign HEX3 = 7'b111_1111;
	
	logic [3:0] instruction_hex0, instruction_hex1, instruction_hex2, instruction_hex3;


	//Instruction output in HEX display 
	assign instruction_hex0 = fpga_instruction[3:0];    
   assign instruction_hex1 = fpga_instruction[7:4];
   assign instruction_hex2 = fpga_instruction[11:8];
   assign instruction_hex3 = fpga_instruction[15:12];  
	
	seven_seg hi0 (.HEX(instruction_hex0), .segment(HEX4)); // HEX4 = instr[3:0]
   seven_seg hi1 (.HEX(instruction_hex1), .segment(HEX5)); // HEX5 = instr[7:4]
   seven_seg hi2 (.HEX(instruction_hex2), .segment(HEX6)); // HEX6 = instr[11:8]
   seven_seg hi3 (.HEX(instruction_hex3), .segment(HEX7)); // HEX7 = instr[15:12]
	

endmodule 
	 
	