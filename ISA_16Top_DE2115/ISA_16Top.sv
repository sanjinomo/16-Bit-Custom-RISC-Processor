module ISA_16Top(
	input logic clk, 
	input logic resetn,
	output logic [9:0] PC, 					//10 bit program counter 
	output logic [15:0] Instruction		//16 bit instruction

);

	 
	logic ReadReg2Src, RegDest, RegWrite, ALUsrc, MemRead, MemWrite, MemToReg, Branch, BranchNotEqual, Jump, JumpReg; //All the control signals
	logic [2:0] ALUControl; 		//Control for ALU 
	logic zeroFlag; 					//for zeroFlag from ALU 
	
	//Instantiating the Instruction_Memory 
	Instruction_Memory im (
		.PC(PC), //10 bit Program Counter 
		.Instruction(Instruction)  //16 bits instruction output
	
	);
	
	//Instantiating the Control this will give us the control outputs for the datapath 
	Control ct (
		.opcode(Instruction[15:12]), 				// first 4 bits of instruction, opcode 
		.ReadReg2Src(ReadReg2Src), 					//ReadReg2Src signal from control
		.RegDest(RegDest), 						//RegDest signal from control 
		.RegWrite(RegWrite),						//RegWrite signal from control 
		.ALUsrc(ALUsrc), 							//ALUsrc signal from control 
		.ALUControl(ALUControl), 					//ALUControl signal from control
		.MemRead(MemRead), 						//MemRead signal from control
		.MemWrite(MemWrite), 						//MemWrite signal from control
		.MemToReg(MemToReg), 						//MemToReg signal from control
		.Branch(Branch), 							//Branch signal from control
		.BranchNotEqual(BranchNotEqual),
		.Jump(Jump), 							//Jump signal from control
		.JumpReg(JumpReg)							//JumpReg signal from control
	);
	
	
	
	//Now we will pass the 16 bits instruction to the Datapath  along with clk and resetn
	//All the control signals will come from the output of Control Module 
	//Instantiating the Datapath 
	Datapath dp (
		.clk(clk),							//clock 
		.resetn(resetn), 						//active low reset 
		.Instruction(Instruction),		//16 bit Instruction 
		.ReadReg2Src(ReadReg2Src), 				//ReadReg2Src signal from control
		.RegDest(RegDest), 					//RegDest signal from control 
		.RegWrite(RegWrite),					//RegWrite signal from control 
		.ALUsrc(ALUsrc), 						//ALUsrc signal from control 
		.ALUControl(ALUControl), 		//ALUControl signal from control
		.MemRead(MemRead), 					//MemRead signal from control
		.MemWrite(MemWrite), 					//MemWrite signal from control
		.MemToReg(MemToReg), 					//MemToReg signal from control
		.Branch(Branch), 						//Branch signal from control
		.BranchNotEqual(BranchNotEqual), 
		.Jump(Jump), 						//Jump signal from control
		.JumpReg(JumpReg),						//JumpReg signal from control
		.PC(PC), 					//program counter output 
		.zeroFlag(zeroFlag)					//zero flag from ALU 
	
	); 
	
endmodule 