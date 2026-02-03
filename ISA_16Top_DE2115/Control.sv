module Control(
	input logic [3:0] opcode, 				//4 bits opcode 
	output logic ReadReg2Src, 				//ReadReg2Src signal from control
	output logic RegDest, 					//RegDest signal from control 
	output logic RegWrite,					//RegWrite signal from control 
	output logic ALUsrc, 						//ALUsrc signal from control 
	output logic [2:0] ALUControl, 		//ALUControl signal from control
	output logic MemRead, 					//MemRead signal from control
	output logic MemWrite, 					//MemWrite signal from control
	output logic MemToReg, 					//MemToReg signal from control
	output logic Branch, 						//Branch signal from control
	output logic BranchNotEqual,			//Branch Not Equal signal from control 
	output logic Jump, 						//Jump signal from control
	output logic JumpReg						//JumpReg signal from control

); 

	//Here, we will decide what control signals will be put for each of the operations 
	
	always_comb begin 
		//first we put the default values to 0 
		ReadReg2Src = 1'b0; 
		RegDest = 1'b0; 
		RegWrite = 1'b0; 
		ALUsrc = 1'b0; 
		ALUControl = 3'b000; 
		MemRead = 1'b0; 
		MemWrite = 1'b0; 
		MemToReg = 1'b0; 
		Branch = 1'b0;
		BranchNotEqual = 1'b0; 
		Jump = 1'b0; 
		JumpReg = 1'b0;
	 
		//Now we will put the signals according to the opcode using a case statement 
		case(opcode)
		
			//R Type Instruction, for all of them data will be written in the Register File. So RegWrite = 1 for all  
			4'b0000: begin 
				RegWrite = 1'b1; 
				ALUControl = 3'b000; //Add 
			end 
			4'b0001: begin 
				RegWrite= 1'b1; 
				ALUControl = 3'b001; //Sub
			end
			4'b0010: begin 
				RegWrite = 1'b1;
				ALUControl = 3'b010; //And
			end 
			4'b0011: begin 
				RegWrite = 1'b1; 
				ALUControl = 3'b011; //Or
			end 
			4'b0111: begin
				RegWrite = 1'b1; 
				ALUControl = 3'b100; //SLT 
			end 
			
			
			//I type Instruction 
			4'b0100: begin 
				ALUsrc = 1'b1; 		//select second input of ALu (signExtImm)
				RegWrite = 1'b1; 
				ALUControl = 3'b000; //Addi 
			end 
			//For LW/Load Word, we don't need readData2 so ReadReg2Src not needed here.  
			4'b0101: begin 
				ALUsrc = 1'b1; 		//select second input of ALu (signExtImm)
				MemRead = 1'b1; 		//for LW, we read data from memory 
				RegWrite = 1'b1; 		//Data written in Reg File 
				MemToReg = 1'b1; 		//the read data form memory is then Written back
				ALUControl = 3'b000; //we use add operation to find the effective address (base addr + signExtImm)
			end 
		
			//For SW/Store Word 
			4'b0110: begin 
				ALUsrc = 1'b1; 		//select second input of ALu (signExtImm)
				MemWrite = 1'b1; 		//Data Written to memory 
				ALUControl = 3'b000; //we use add operation to find the effective address (base addr + signExtImm)
				ReadReg2Src = 1'b1; 	//we select rt's instuction address 
			
			end
			//For BEQ, Branch Instruction 
			4'b1000: begin 
				Branch = 1'b1; 
				ALUControl = 3'b001; //We will use Subtraction. If result 0, we get zeroFlag 
				ReadReg2Src = 1'b1;
			end 
			//For BNE, Branch Instruction	
			4'b1001: begin 
				BranchNotEqual = 1'b1; 
				ALUControl = 3'b001; //We will use Subtraction. If result 0, we get zeroFlag 
				ReadReg2Src = 1'b1;
				//Need to think about separating BNE and BEQ (work left)
			end
			//For LUI, Load Upper Immidiate 
			4'b1101: begin 
				ALUsrc = 1'b1; 		//select second input of ALu (signExtImm)		
				RegWrite = 1'b1; 
				ALUControl = 3'b101; //We will use add operation to perform this 
				//Need to think about it (work done!)
			end 
			4'b1110: begin 
				ALUsrc = 1'b1;			//select second input of ALu (signExtImm)
				RegWrite = 1'b1; 
				ALUControl = 3'b011; //Ori 
				
			end 
			
			//J type instruction 
			4'b1010: begin 
				Jump = 1'b1; 	//for jump (j) instruction 
			end 
			// for jal (jump and link)
			4'b1011: begin 
				Jump = 1'b1; 
				RegWrite = 1'b1; 
				RegDest = 1'b1; 		//selects write to $ra in Datapath, saves return address PC+1 to ra 
			end 
			
			//for jr (jump register)
			4'b1100: begin 
				Jump = 1'b1; 
				JumpReg = 1'b1; 
				
			end 
			
			//HALT case 
			4'b1111: begin 
				//All signals stay 0 
			end 
			
		endcase
	end 
endmodule 	
	
		