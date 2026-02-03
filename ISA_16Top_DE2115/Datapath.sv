module Datapath (
	input logic clk,							//clock 
	input logic resetn, 						//active low reset 
	input logic [15:0] Instruction,		//16 bit Instruction 
	input logic ReadReg2Src, 				//ReadReg2Src signal from control
	input logic RegDest, 					//RegDest signal from control 
	input logic RegWrite,					//RegWrite signal from control 
	input logic ALUsrc, 						//ALUsrc signal from control 
	input logic [2:0] ALUControl, 		//ALUControl signal from control
	input logic MemRead, 					//MemRead signal from control
	input logic MemWrite, 					//MemWrite signal from control
	input logic MemToReg, 					//MemToReg signal from control
	input logic Branch, 						//Branch signal from control
	input logic BranchNotEqual, 				//Branch Not Equal signal from control 
	input logic Jump, 						//Jump signal from control
	input logic JumpReg,						//JumpReg signal from control
	output logic [9:0] PC, 					//program counter output 
	output logic zeroFlag					//zero flag from ALU 
	
);


	//specify common instruction fields internal according to the format 
	logic [3:0] opcode;
	logic [1:0] rs, rt, rd; 
	logic [7:0] immidiate; 
	logic [11:0] jumpAddr;
	
	//split and assign the 16 bit instruction according to format (all)
	assign opcode = Instruction[15:12];
	assign rd = Instruction[11:10];
	assign rs = Instruction[9:8];
	assign rt = Instruction[7:6];
	assign immidiate = Instruction[7:0];
	assign jumpAddr = Instruction[11:0];
	
	//Register File internal 
	logic [1:0] writeRegAddr; 	//rt/rd, destination register
	logic [15:0] writeData; 	//write data
	logic [15:0] readData1; 	//read data 1
	logic [15:0] readData2;		//read data 2
	logic [1:0] reg2addr; 		//second reg address for the Register file 
	
	
	//ALU internal  
	logic [15:0] AluSecondInput; //first input will be readData1, but for some cases we decide the input for second 
	logic [15:0] AluResult; //Alu output result 
	
	//data memory internal 
	logic [15:0] memReadData; //output read data 
	
	
	
	//sign extension of the 8 bit immidiate value
	logic [15:0] SignExtImm;
	//we will extend according to the sign on the MSB
	assign SignExtImm = {{8{immidiate[7]}}, immidiate}; //Bit swizling and concatening  
	
	//next PC logic
	logic [9:0] currentPC, nextPc, pcPlus1, branchTarget;
	
	assign pcPlus1 = currentPC + 10'd1; //word addresable, goes to immidiate next instruction 
	assign branchTarget = pcPlus1 + SignExtImm[9:0];  //branch target address for branch instructions 
	
	always_comb begin 
		if(Jump) begin 
			if(JumpReg) nextPc = readData1[9:0]; //for JR (Jump Register) 
			else nextPc = jumpAddr[9:0]; //for J/JAL (Jump/ Jump and Link)
		end 
		else if ((Branch & zeroFlag) || (BranchNotEqual & ~zeroFlag)) nextPc = branchTarget; //When we get Brach signal from control and zero flag from alu 
		else nextPc = pcPlus1;  //else we just go to the next instruction 
	end 
	
	
	
	
	//Now we are goint to connect the datapath 
	//we will need couple of MUX for the flow according to signals 
	
	//The behaivior of destination register for jump and link will be different
	//But for both R type destination register is rd(Instruction[11:10]), and for I type rt(Instruction[11:10])	
	//(MUX:RegDest) for JAL, writeRegAddr = 2'b11 represents $ra, saves the return address  
	assign writeRegAddr = RegDest? 2'b11 : Instruction[11:10];  

	
	//(MUX:RegDest) and (MUX:MemToReg)
	//If RegDest is 1(JAL) we write pcPlus1. We concatenate 7 bit 0 at front with pcPlus1 
	//Else if MemToReg is 1 we write Memory data
	//Else we write Alu Result 
	assign writeData = RegDest?  {6'b0, pcPlus1} : (MemToReg? memReadData : AluResult); 
	
	
	//(MUX:ReadReg2Src) for selecting rt (R type/I type) rt, for R type is [7:6], for I type [11:10]
	assign reg2addr = ReadReg2Src ? Instruction[11:10]:Instruction[7:6]; //When 0 it is R type, and For 1 it is I-type 
	
	
	//Instantiating the Register File 
	Register_File rf (
		.clk(clk), 					//clock
		.resetn(resetn), 				//active low reset 
		.wen(RegWrite), 					//write enable
		.readRegAddr1(rs), 	//rs, first source register address always [9:8]
		.readRegAddr2(reg2addr),	//rt, for R type is [7:6], for I type [11:10]
		.writeRegAddr(writeRegAddr), 	//rt/rd, destination register
		.writeData(writeData), //write data
		.readData1(readData1), //read data 1
		.readData2(readData2)		//read data 2

	
	);
	
	
	//(MUX:ALUsrc)  to choose signExtImm or readData2 
	assign AluSecondInput = ALUsrc ? SignExtImm:readData2; 
	
	//Instantiating the ALU
	ALU alu(
		.operandA(readData1), //from readData1
		.operandB(AluSecondInput), //from readData2
		.aluControl(ALUControl), //defines what operation
		.AluResult(AluResult), //Alu Result
		.zero(zeroFlag)		//zero flag for branch operation 
	
	
	);
	
	//Instantiating the Data_Memory 
	Data_Memory dm (
		.clk(clk), 						//clock
		.MemWEn(MemWrite),					//write enable 
		.MemRedEn(MemRead),				//read enable 
		.eff_address(AluResult[9:0]), 	//effictive address from alu
		.WriteData(readData2), 	//16 bit write data from Register file Read Data 2
		.ReadData(memReadData)		//16 bit read data from memory 

	);
	
	//Instantiating the PC (Program Counter)
	PC pc(
		.clk(clk), 					//clock 
		.resetn(resetn), 				//active low reset 
		.nextPc(nextPc), 		//next PC address
		.currentPC(currentPC)	//current PC address 
	);
	
	assign PC = currentPC; 
	
endmodule 
	